# =============================================================================
#  solver.jl — Numerical steady-state backend for MacroModelClaw
#
#  Implements the strategy designed in:
#    - NonlinearSolvers_MacroModelClaw.md  (solver catalogue + §8 architecture)
#    - NonlinearSolve_Integration_Plan.md  (NonlinearSolve.jl integration)
#
#  Two entry points are exposed to the MCP layer:
#
#    solve_steady_state_system(...)  — pure NonlinearSolve.jl path. The caller
#        (Walras) supplies the steady-state residual equations, the unknown
#        names, parameter values, optional box bounds and an initial guess.
#        We build the residual, run the polyalgorithm fallback chain with a
#        box-constraint transform, and return the solved values.
#
#    solve_steady_state_model(...)  — MacroModelling.jl path. The caller supplies
#        a MacroModelling `@model` / `@parameters` definition as text. We let
#        MM.jl's frontend do the symbolic reduction / block decomposition /
#        calibration folding ("MM.jl 求解稳态的思路"), then read off the NSSS.
#
#  Both return a plain Dict that the MCP server serialises to JSON.
# =============================================================================

using NonlinearSolve
using LinearAlgebra: norm
using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

# -----------------------------------------------------------------------------
# Box-constraint transforms (NonlinearSolvers_MacroModelClaw.md §8.3)
# NonlinearSolve.jl root-finders are unconstrained, so we solve in transformed
# coordinates and map back. Two-sided -> logit/sigmoid, one-sided -> log/exp.
# -----------------------------------------------------------------------------
function _make_transforms(lb::Vector{Float64}, ub::Vector{Float64})
    has_lb = isfinite.(lb)
    has_ub = isfinite.(ub)
    both   = has_lb .& has_ub
    lo     = has_lb .& .!has_ub          # one-sided lower bound only

    function to_constrained(v)
        u = collect(v)
        @inbounds for i in eachindex(u)
            if both[i]
                u[i] = lb[i] + (ub[i] - lb[i]) / (1 + exp(-v[i]))
            elseif lo[i]
                u[i] = lb[i] + exp(v[i])
            end
        end
        return u
    end

    function to_unconstrained(u)
        v = collect(u)
        @inbounds for i in eachindex(v)
            if both[i]
                x = clamp((u[i] - lb[i]) / (ub[i] - lb[i]), 1e-9, 1 - 1e-9)
                v[i] = log(x / (1 - x))
            elseif lo[i]
                v[i] = log(max(u[i] - lb[i], 1e-9))
            end
        end
        return v
    end

    return to_constrained, to_unconstrained
end

# -----------------------------------------------------------------------------
# The polyalgorithm fallback chain. Mirrors CLAUDE.md's
#   fsolve -> continuation -> Levenberg-Marquardt -> differential evolution
# expressed with NonlinearSolve.jl solvers, plus random restarts.
# -----------------------------------------------------------------------------
const _SOLVER_CHAIN = [
    ("FastShortcutNonlinearPolyalg", () -> FastShortcutNonlinearPolyalg()),
    ("RobustMultiNewton",            () -> RobustMultiNewton()),
    ("TrustRegion",                  () -> TrustRegion()),
    ("LevenbergMarquardt",           () -> LevenbergMarquardt()),
]

"""
    _solve_chain(resid!, u0; lb, ub, abstol, maxiters, restarts)

Run the residual through the solver fallback chain in transformed coordinates.
Returns `(success::Bool, u::Vector, residnorm::Float64, method::String)`.
"""
function _solve_chain(resid!, u0::Vector{Float64};
                      lb::Vector{Float64}, ub::Vector{Float64},
                      abstol::Float64 = 1e-12, maxiters::Int = 10_000,
                      restarts::Int = 4)

    to_constrained, to_unconstrained = _make_transforms(lb, ub)

    # residual in transformed (v) space
    function f_t!(F, v, p)
        resid!(F, to_constrained(v), p)
        return nothing
    end

    n = length(u0)
    best_u = copy(u0); best_res = Inf; best_method = "none"; ok = false

    # restart 0 uses the supplied guess; subsequent restarts perturb it
    for r in 0:restarts
        guess = r == 0 ? copy(u0) :
                clamp.(u0 .* (1 .+ 0.5 .* (mod.(collect(1:n) .* (r + 1), 7) ./ 7 .- 0.5)),
                       nextfloat.(lb), prevfloat.(ub))
        v0 = to_unconstrained(guess)

        for (name, mk) in _SOLVER_CHAIN
            local sol
            try
                prob = NonlinearProblem(f_t!, v0, nothing)
                sol  = solve(prob, mk(); abstol = abstol, maxiters = maxiters)
            catch err
                @debug "solver $name threw" exception = err
                continue
            end
            u  = to_constrained(sol.u)
            Fv = similar(u); resid!(Fv, u, nothing); rn = norm(Fv)
            if rn < best_res
                best_res = rn; best_u = u; best_method = r == 0 ? name : "$name (restart $r)"
            end
            # residual norm is the authoritative convergence test for a root-find
            # (avoids depending on solver-specific retcode symbols across versions)
            if rn < sqrt(abstol)
                return true, u, rn, (r == 0 ? name : "$name (restart $r)")
            end
        end
    end

    ok = best_res < 1e-6
    return ok, best_u, best_res, best_method
end

# -----------------------------------------------------------------------------
# Build an in-place residual f!(F, u, p) from text equations.
#
#   equations : Vector of strings. Each is either a residual "expr" (== 0) or an
#               equality "lhs = rhs" (converted to lhs - (rhs)).
#   unknowns  : Vector of variable names, defining the order of u.
#   params    : Dict{String,Float64} of parameter values, injected by name.
#
# RuntimeGeneratedFunctions avoids the world-age problem of eval-then-call.
# -----------------------------------------------------------------------------
function build_residual(equations::Vector{String}, unknowns::Vector{String},
                        params::Dict{String,Float64})
    body = Expr(:block)
    for (i, u) in enumerate(unknowns)
        push!(body.args, :($(Symbol(u)) = u[$i]))
    end
    for (k, val) in params
        push!(body.args, :($(Symbol(k)) = $(val)))
    end
    for (i, raw) in enumerate(equations)
        ex = Meta.parse(strip(raw))
        if ex isa Expr && ex.head == :(=)            # "lhs = rhs" -> residual
            ex = Expr(:call, :-, ex.args[1], Expr(:call, :+, ex.args[2]))
        end
        push!(body.args, :(F[$i] = $ex))
    end
    fexpr = :((F, u, p) -> begin
        $body
        return nothing
    end)
    return @RuntimeGeneratedFunction(fexpr)
end

# -----------------------------------------------------------------------------
# Public entry 1 — pure NonlinearSolve.jl path
# -----------------------------------------------------------------------------
function solve_steady_state_system(; equations::Vector{String},
                                     unknowns::Vector{String},
                                     parameters::Dict{String,Float64},
                                     initial_guess = nothing,
                                     bounds = nothing,
                                     abstol::Float64 = 1e-12,
                                     maxiters::Int = 10_000)
    n = length(unknowns)
    length(equations) == n || return Dict(
        "success" => false,
        "message" => "exact-ID violation: $(length(equations)) equations vs $n unknowns",
    )

    u0 = initial_guess === nothing ? fill(1.0, n) : Float64.(initial_guess)
    lb = fill(-Inf, n); ub = fill(Inf, n)
    if bounds !== nothing
        for (i, nm) in enumerate(unknowns)
            if haskey(bounds, nm)
                b = bounds[nm]
                lb[i] = b[1] === nothing ? -Inf : Float64(b[1])
                ub[i] = b[2] === nothing ?  Inf : Float64(b[2])
            end
        end
    end

    resid! = build_residual(equations, unknowns, parameters)
    ok, u, rn, method = _solve_chain(resid!, u0; lb = lb, ub = ub,
                                     abstol = abstol, maxiters = maxiters)

    return Dict(
        "success"       => ok,
        "message"       => ok ? "converged" : "no solution within tolerance (best residual $(rn))",
        "method_used"   => method,
        "residual_norm" => rn,
        "values"        => Dict(unknowns[i] => u[i] for i in 1:n),
        "n_numerical"   => n,
    )
end

# -----------------------------------------------------------------------------
# Public entry 2 — MacroModelling.jl path (symbolic reduction + blocks)
# -----------------------------------------------------------------------------
function solve_steady_state_model(; model_source::String,
                                    parameters = nothing,
                                    model_name = nothing)
    local SS, var_names
    try
        @eval Main begin
            using MacroModelling
        end
        mod = Module(:ClawModelSandbox)
        Core.eval(mod, :(using MacroModelling))
        Core.eval(mod, Meta.parseall(model_source))

        name = model_name === nothing ? _detect_model_name(model_source) : Symbol(model_name)
        model = Core.eval(mod, name)

        kw = parameters === nothing ? () :
             (parameters = [Symbol(k) => Float64(v) for (k, v) in parameters],)
        SS = MacroModelling.get_steady_state(model; kw...)
        var_names = string.(MacroModelling.get_variables(model))
        vals = SS[:, 1]
        return Dict(
            "success"     => true,
            "message"     => "solved by MacroModelling.jl frontend (symbolic + block + NSSS solver)",
            "method_used" => "MacroModelling.get_steady_state",
            "values"      => Dict(var_names[i] => vals[i] for i in eachindex(var_names)),
            "n_numerical" => length(var_names),
        )
    catch err
        return Dict(
            "success" => false,
            "message" => "MacroModelling.jl steady-state failed: $(sprint(showerror, err))",
        )
    end
end

# crude `@model NAME begin` name sniffer
function _detect_model_name(src::String)
    m = match(r"@model\s+([A-Za-z_][A-Za-z0-9_]*)", src)
    m === nothing && error("could not find an @model NAME block in model_source")
    return Symbol(m.captures[1])
end
