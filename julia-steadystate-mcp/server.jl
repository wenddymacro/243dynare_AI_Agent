# =============================================================================
#  server.jl — MCP (Model Context Protocol) stdio server for MacroModelClaw's
#  Julia steady-state backend.
#
#  Transport : JSON-RPC 2.0 over stdio, newline-delimited (MCP stdio spec).
#  Run       : julia --project=. server.jl
#  Logging   : everything diagnostic goes to stderr; stdout is protocol-only.
#
#  Tools exposed:
#    - solve_steady_state_system   (NonlinearSolve.jl path; Walras-supplied system)
#    - solve_steady_state_model    (MacroModelling.jl path; @model/@parameters text)
#
#  The returned steady-state Dict is meant to be fed, by the agent layer, into
#  LLMacro-Dynare-LSP's `dynare_check_blanchard_kahn(steady_state=...)` — so this
#  server replaces ONLY LLMacro's Python `dynare_compute_steady_state`.
# =============================================================================

include(joinpath(@__DIR__, "src", "solver.jl"))
using JSON3

const PROTOCOL_VERSION = "2024-11-05"

log_err(args...) = (println(stderr, "[steadystate-mcp] ", args...); flush(stderr))

# ----------------------------------------------------------------------------- tool schemas
function tool_definitions()
    return [
        Dict(
            "name" => "solve_steady_state_system",
            "description" =>
                "Solve a deterministic steady state from an explicit residual system " *
                "using the NonlinearSolve.jl polyalgorithm fallback chain " *
                "(FastShortcutNonlinearPolyalg -> RobustMultiNewton -> TrustRegion -> " *
                "LevenbergMarquardt) with box-constraint transforms and random restarts. " *
                "Use this when Walras has written the steady-state equations. Enforces an " *
                "exact-ID check (#equations == #unknowns).",
            "inputSchema" => Dict(
                "type" => "object",
                "properties" => Dict(
                    "equations" => Dict("type" => "array", "items" => Dict("type" => "string"),
                        "description" => "Steady-state residual equations. Each is 'lhs = rhs' or a residual 'expr' (==0). Use parameter and unknown names directly."),
                    "unknowns" => Dict("type" => "array", "items" => Dict("type" => "string"),
                        "description" => "Unknown variable names; defines solution ordering."),
                    "parameters" => Dict("type" => "object",
                        "description" => "Map of parameter name -> numeric value, injected by name."),
                    "initial_guess" => Dict("type" => "array", "items" => Dict("type" => "number"),
                        "description" => "Optional x0, same order as unknowns (Prescott's suggestion). Defaults to ones."),
                    "bounds" => Dict("type" => "object",
                        "description" => "Optional map name -> [lb, ub] (use null for unbounded side), e.g. {\"C\":[0,null]}."),
                ),
                "required" => ["equations", "unknowns", "parameters"],
            ),
        ),
        Dict(
            "name" => "solve_steady_state_model",
            "description" =>
                "Solve the non-stochastic steady state of a MacroModelling.jl model given " *
                "its @model / @parameters source text. Uses MM.jl's frontend (symbolic " *
                "removal of steady-state-redundant variables, block/SCC decomposition, " *
                "calibration folding) for the solve. Use this as the independent oracle to " *
                "validate Walras's hand-written steady state. WARNING: evaluates Julia code.",
            "inputSchema" => Dict(
                "type" => "object",
                "properties" => Dict(
                    "model_source" => Dict("type" => "string",
                        "description" => "Full @model NAME begin ... end and @parameters NAME begin ... end text."),
                    "parameters" => Dict("type" => "object",
                        "description" => "Optional parameter overrides (e.g. calibrated a_bar, kappa_L)."),
                    "model_name" => Dict("type" => "string",
                        "description" => "Optional model name; auto-detected from @model if omitted."),
                ),
                "required" => ["model_source"],
            ),
        ),
    ]
end

# ----------------------------------------------------------------------------- dispatch
function call_tool(name::String, args)
    if name == "solve_steady_state_system"
        eqs   = String.(args["equations"])
        unk   = String.(args["unknowns"])
        pars  = Dict{String,Float64}(string(k) => Float64(v) for (k, v) in args["parameters"])
        guess = haskey(args, "initial_guess") && args["initial_guess"] !== nothing ?
                Float64.(args["initial_guess"]) : nothing
        bnds  = haskey(args, "bounds") && args["bounds"] !== nothing ?
                Dict(string(k) => (v[1], v[2]) for (k, v) in args["bounds"]) : nothing
        return solve_steady_state_system(; equations = eqs, unknowns = unk,
                                           parameters = pars, initial_guess = guess,
                                           bounds = bnds)
    elseif name == "solve_steady_state_model"
        src  = String(args["model_source"])
        pars = haskey(args, "parameters") && args["parameters"] !== nothing ?
               Dict(string(k) => v for (k, v) in args["parameters"]) : nothing
        nm   = get(args, "model_name", nothing)
        return solve_steady_state_model(; model_source = src, parameters = pars,
                                          model_name = nm === nothing ? nothing : String(nm))
    else
        return Dict("success" => false, "message" => "unknown tool: $name")
    end
end

# ----------------------------------------------------------------------------- JSON-RPC plumbing
ok_result(id, result)        = Dict("jsonrpc" => "2.0", "id" => id, "result" => result)
err_result(id, code, msg)    = Dict("jsonrpc" => "2.0", "id" => id,
                                    "error" => Dict("code" => code, "message" => msg))

function handle(req)
    method = get(req, "method", "")
    id     = get(req, "id", nothing)

    if method == "initialize"
        return ok_result(id, Dict(
            "protocolVersion" => PROTOCOL_VERSION,
            "capabilities"    => Dict("tools" => Dict()),
            "serverInfo"      => Dict("name" => "macromodelclaw-steadystate", "version" => "0.1.0"),
        ))
    elseif method == "tools/list"
        return ok_result(id, Dict("tools" => tool_definitions()))
    elseif method == "tools/call"
        params = get(req, "params", Dict())
        name   = get(params, "name", "")
        args   = get(params, "arguments", Dict())
        out    = try
            call_tool(String(name), args)
        catch err
            Dict("success" => false, "message" => sprint(showerror, err))
        end
        return ok_result(id, Dict(
            "content" => [Dict("type" => "text", "text" => JSON3.write(out))],
            "isError" => out isa Dict && get(out, "success", true) == false,
        ))
    elseif startswith(method, "notifications/")
        return nothing            # notifications get no response
    elseif id === nothing
        return nothing
    else
        return err_result(id, -32601, "Method not found: $method")
    end
end

function main()
    log_err("ready; protocol ", PROTOCOL_VERSION)
    while !eof(stdin)
        line = readline(stdin)
        isempty(strip(line)) && continue
        local req
        try
            req = JSON3.read(line, Dict)
        catch err
            log_err("parse error: ", sprint(showerror, err))
            continue
        end
        resp = handle(req)
        resp === nothing && continue
        println(stdout, JSON3.write(resp))
        flush(stdout)
    end
end

main()
