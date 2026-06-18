# =============================================================
#  RBC Model — MacroModelling.jl steady-state solver
#  Source: RBC_model.polished.md (Nispi Landi, 2018)
#  Equilibrium system: equations (1)–(11), kappa_I = 0
#  Normalizations: y_ss = 1, h_ss = 1/3
# =============================================================

using MacroModelling, Printf

# -------------------------------------------------------------
# Part 1: Analytical steady-state (closed-form, Section 3 of md)
# -------------------------------------------------------------

# Calibration
const β    = 0.99
const α    = 0.33
const δ    = 0.025
const σ    = 2.0
const φ    = 1.0
const ḡ    = 0.2
const ρ_a  = 0.9
const ρ_g  = 0.9

# Normalizations
y_ss  = 1.0
h_ss  = 1/3

# Sequence of closed-form solutions
r_r_ss = 1 / β
r_k_ss = 1/β - (1 - δ)
k_ss   = α * y_ss / r_k_ss
i_ss   = δ * k_ss
w_ss   = (1 - α) * y_ss / h_ss
c_ss   = y_ss - i_ss - ḡ
lam_ss = c_ss^(-σ)
a_ss   = y_ss / (k_ss^α * h_ss^(1 - α))
κL_ss  = w_ss / (h_ss^φ * c_ss^σ)

println("=" ^ 60)
println("  PART 1 — Analytical Steady State  (Section 3, md doc)")
println("=" ^ 60)
analytical = [
    ("y",     y_ss),
    ("c",     c_ss),
    ("i",     i_ss),
    ("k",     k_ss),
    ("h",     h_ss),
    ("w",     w_ss),
    ("r_r",   r_r_ss),
    ("r_k",   r_k_ss),
    ("lam",   lam_ss),
    ("a",     a_ss),
    ("g",     ḡ),
    ("q",     1.0),
]
for (nm, v) in analytical
    @printf "  %-6s = %12.8f\n" nm v
end
@printf "\n  ← derived params:  a_ss = %.8f,  kappa_L = %.8f\n\n" a_ss κL_ss

# -------------------------------------------------------------
# Part 2: MacroModelling.jl model definition
#
# Variable naming:
#   Endogenous (levels, uppercase in md → lowercase here):
#     lam, c, i_inv, k, h, y, w, r_r, r_k, a, g
#   Exogenous shocks: eps_a, eps_g
#
# q ≡ 1 when kappa_I = 0, so Tobin's q equation drops out.
# 11 equations, 11 endogenous variables.
# -------------------------------------------------------------

@model RBC begin

    # (1) Marginal utility of consumption
    lam[0] = c[0]^(-sigma)

    # (2) Bond Euler equation
    lam[0] = beta * lam[1] * r_r[0]

    # (3) Capital Euler equation  (q = 1 when kappa_I = 0)
    1 = beta * (lam[1] / lam[0]) * (r_k[1] + (1 - delta))

    # (4) Labor supply (intratemporal FOC)
    kappa_L * h[0]^phi = lam[0] * w[0]

    # (5) Capital accumulation  (no adjustment cost)
    k[0] = (1 - delta) * k[-1] + i_inv[0]

    # (6) Cobb-Douglas production function
    y[0] = a[0] * k[-1]^alpha * h[0]^(1 - alpha)

    # (7) Firm FOC: labor demand
    (1 - alpha) * y[0] = w[0] * h[0]

    # (8) Firm FOC: capital demand
    alpha * y[0] = r_k[0] * k[-1]

    # (9) Goods market clearing  (b^r = 0)
    y[0] = c[0] + i_inv[0] + g[0]

    # (10) TFP process: log AR(1)
    log(a[0]) = (1 - rho_a) * log(a_bar) + rho_a * log(a[-1]) + std_a * eps_a[x]

    # (11) Government spending process: log AR(1)
    log(g[0]) = (1 - rho_g) * log(g_bar) + rho_g * log(g[-1]) + std_g * eps_g[x]

end

@parameters RBC begin
    beta    = 0.99
    alpha   = 0.33
    delta   = 0.025
    sigma   = 2.0
    phi     = 1.0
    rho_a   = 0.9
    rho_g   = 0.9
    g_bar   = 0.2
    std_a   = 0.01
    std_g   = 0.01
    # calibrated from y=1, h=1/3 normalizations (set below)
    a_bar   = 1.0
    kappa_L = 1.0
end

# Override with calibrated values
calibrated_params = [:a_bar => a_ss, :kappa_L => κL_ss]

# -------------------------------------------------------------
# Part 3: Solve steady state numerically via MacroModelling.jl
# -------------------------------------------------------------
println("=" ^ 60)
println("  PART 2 — MacroModelling.jl  get_steady_state()")
println("=" ^ 60)

SS = get_steady_state(RBC, parameters = calibrated_params)

# Extract as Dict
var_names = get_variables(RBC)
ss_vals   = SS[:, 1]
ss_dict   = Dict(string(v) => ss_vals[i] for (i, v) in enumerate(var_names))

for nm in sort(string.(var_names))
    @printf "  %-8s = %12.8f\n" nm ss_dict[nm]
end

# -------------------------------------------------------------
# Part 4: Comparison table
# -------------------------------------------------------------
println()
println("=" ^ 70)
println("  PART 3 — Comparison: MacroModelling.jl  vs  Analytical")
println("=" ^ 70)
@printf "  %-8s  %14s  %14s  %10s  %s\n" "var" "MM.jl" "analytical" "abs.diff" "pass"
println("  " * "─" ^ 56)

tol = 1e-6
all_pass = true

compare = [
    ("y",     y_ss),
    ("c",     c_ss),
    ("i_inv", i_ss),
    ("k",     k_ss),
    ("h",     h_ss),
    ("w",     w_ss),
    ("r_r",   r_r_ss),
    ("r_k",   r_k_ss),
    ("lam",   lam_ss),
    ("a",     a_ss),
    ("g",     ḡ),
]

n_fail = 0
for (nm, anl) in compare
    mm   = get(ss_dict, nm, NaN)
    d    = abs(mm - anl)
    ok   = d < tol
    ok || (n_fail += 1)
    flag = ok ? "✓" : "✗"
    @printf "  %-8s  %14.8f  %14.8f  %10.2e  %s\n" nm mm anl d flag
end

println()
if n_fail == 0
    println("  All variables match analytical SS to within $tol  ✓")
else
    println("  WARNING: $n_fail variable(s) deviate beyond $tol  ✗")
end
