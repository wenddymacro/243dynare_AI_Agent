# Dynare Agentic Toolkit

A skills-based toolkit for Dynare DSGE modeling with AI coding agents. Modeled on the [matlab-agentic-toolkit](https://github.com/mathworks/matlab-agentic-toolkit) architecture.

## What It Does

Gives AI coding agents (Claude Code and others) the knowledge and execution capability to:

- Set up and verify Dynare 6.x environments
- Write `.mod` files with nonlinear equilibrium equations
- Solve steady states numerically with companion `_steadystate.m` files
- Run `stoch_simul` and extract impulse response functions
- Post-process `oo_` / `M_` / `options_` structures

## Requirements

- Dynare **6.x or above** (required)
- MATLAB **R2021a+** with the official [MATLAB Agentic Toolkit](https://github.com/matlab/matlab-agentic-toolkit) (MathWorks MCP server; supersedes the older third-party `matlab-mcp-server`) — install via `setupAgenticToolkit("install")` inside MATLAB
- Claude Code (or another agent that supports Claude-style plugins)

## Plugins

| Plugin | Skills | Install for |
|---|---|---|
| `dynare-core` | `dynare-setup`, `dynare-debug` | Everyone |
| `dynare-modeling` | `dynare-write-mod`, `dynare-steady-state`, `dynare-irf`, `dynare-postprocess` | Active modeling work |

`dynare-modeling` requires `dynare-core`.

## Getting Started

See [GETTING_STARTED.md](GETTING_STARTED.md) for installation and first-use instructions.

## Notation Convention

All generated files use a standardized notation (uppercase level variables, `ss` suffix for steady-state values, `eps_` prefix for shocks). See `skills-catalog/dynare-modeling/dynare-write-mod/reference/notation-conventions.md`.

## Phase 2 Vision

Phase 1 (this toolkit): user provides model equations. Phase 2 (future): modular sector composition → full pipeline automation. The notation convention and `_steadystate.m` template structure are forward-compatible with Phase 2.
