# macromodelclaw-steadystate (Julia MCP server)

The steady-state numerical backend for MacroModelClaw. **Replaces** LLMacro‑Dynare‑LSP's
Python `dynare_compute_steady_state` tool with a Julia implementation built on
**MacroModelling.jl's NSSS approach** (symbolic reduction + block decomposition +
calibration folding) and **NonlinearSolve.jl** as the numerical engine
(polyalgorithm fallback chain + box-constraint transforms).

Design rationale lives in the repo root:
[`NonlinearSolvers_MacroModelClaw.md`](../NonlinearSolvers_MacroModelClaw.md) and
[`NonlinearSolve_Integration_Plan.md`](../NonlinearSolve_Integration_Plan.md).
Pipeline wiring lives in [`docs/steady_state_julia_integration.md`](../docs/steady_state_julia_integration.md).

## Tools

| Tool | Path | Use |
|---|---|---|
| `solve_steady_state_system` | NonlinearSolve.jl | Walras supplies the SS residual equations, unknowns, params, optional `x0`/bounds. Enforces exact-ID (`#eq == #unknown`). Returns solved values + residual norm + method. |
| `solve_steady_state_model` | MacroModelling.jl | Supply `@model`/`@parameters` text; MM.jl frontend solves. Independent oracle to validate Walras's hand-written SS. **Evaluates Julia code.** |

## Install

```bash
cd julia-steadystate-mcp
julia --project=. -e 'using Pkg; Pkg.instantiate()'   # first run only; compiles deps
julia --project=. server.jl                            # starts the stdio MCP server
```

First `instantiate` is slow (MacroModelling + NonlinearSolve precompile). To cut
per-call latency, build a sysimage with PackageCompiler and point the launcher at it.

## Register with Claude Code

Add to the MacroModelClaw plugin's `mcpServers` (alongside the LLMacro `dynare` MCP):

```json
{
  "mcpServers": {
    "dynare": {
      "command": "python",
      "args": ["-m", "dynare_lsp.mcp_server"]
    },
    "macromodelclaw-steadystate": {
      "command": "julia",
      "args": ["--project=/ABS/PATH/julia-steadystate-mcp",
               "/ABS/PATH/julia-steadystate-mcp/server.jl"]
    }
  }
}
```

> The third instrument server — the **MATLAB Agentic Toolkit** (Klein's execution layer) —
> is **not** added here. It self-registers when you run `setupAgenticToolkit("install")`
> inside MATLAB R2021a+. See [`docs/steady_state_julia_integration.md`](../docs/steady_state_julia_integration.md) §6.

## Quick smoke test (RBC)

`solve_steady_state_system` with the closed RBC system (parameters pre-substituted by
Prescott/Walras), unknowns ordered, `bounds` keeping quantities positive:

```jsonc
{
  "name": "solve_steady_state_system",
  "arguments": {
    "unknowns":  ["C","K","H","Y","W","Rk","Rr","I","LAM","A","G"],
    "parameters": {"beta":0.99,"alpha":0.33,"delta":0.025,"sigma":2.0,
                   "phi":1.0,"gbar":0.2,"kappa_L":<from calib>,"abar":<from calib>},
    "equations": [
      "LAM = C^(-sigma)",
      "LAM = beta*LAM*Rr",
      "1 = beta*(Rk + (1-delta))",
      "kappa_L*H^phi = LAM*W",
      "K = (1-delta)*K + I",
      "Y = A*K^alpha*H^(1-alpha)",
      "(1-alpha)*Y = W*H",
      "alpha*Y = Rk*K",
      "Y = C + I + G",
      "A = abar",
      "G = gbar"
    ],
    "bounds": {"C":[0,null],"K":[0,null],"H":[0,1],"Y":[0,null],"I":[0,null]}
  }
}
```

> `solve_steady_state_model` can cross-check the same model from
> [`models/rbc_steadystate.jl`](../models/rbc_steadystate.jl)'s `@model RBC` block.

## Status

Reference implementation. The numerical path follows the validated design in the two
root documents but has **not** been executed here (no Julia toolchain in the authoring
environment). Run the smoke test above after `Pkg.instantiate()` and reconcile against
`models/rbc_steadystate.jl`'s analytical SS before wiring into the live pipeline.
