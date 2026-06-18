# MacroModelClaw

**A multi-agent AI workflow for automating DSGE model development in Dynare.**

You write the economics in a single structured document (`model-doc.md`); a pipeline of ten
agents — each named after a foundational economist — parses it, writes the `.mod` and
`_steadystate.m` files, solves the steady state, runs Dynare, classifies errors, reviews the
economics, and ships a complete, validated model.

> The agents are backed by **three MCP instrument servers**: a Dynare language server
> (parse/diagnose), a Julia steady-state solver (`MacroModelling.jl` + `NonlinearSolve.jl`),
> and the MATLAB Agentic Toolkit (execution).

<p align="center">
  <img src="user-project/results/irf_tfp.png" width="640"
       alt="RBC impulse responses to a TFP shock, generated end-to-end by the pipeline">
  <br>
  <em>Demo output: RBC impulse responses to a TFP shock — generated end-to-end by the pipeline
  (see <a href="Xu, Wenli and Shi, Kang, MacroModelClaw: An AI-Collaborative Workflow for DSGE Model Development (June 18, 2026). Available at SSRN: https://ssrn.com/abstract=">the paper</a>, §3).</em>

**Citing: Xu, Wenli and Shi, Kang, MacroModelClaw: An AI-Collaborative Workflow for DSGE Model Development (June 18, 2026). Available at SSRN: https://ssrn.com/abstract=**
</p>

## The pipeline

| Agent | Namesake | Role |
|---|---|---|
| **Keynes** | J.M. Keynes | Orchestrator — state machine, circuit breaker |
| **Tinbergen** | J. Tinbergen | Parser — reads `model-doc.md`, exact-ID check |
| **Prescott** | E.C. Prescott | Calibrator — parameter values, initial guesses |
| **Kydland** | F.E. Kydland | ModelWriter — writes `model.mod` |
| **Judd** | K.L. Judd | NSSS Solver — numerical steady state (Julia) |
| **Walras** | L. Walras | SteadyStateWriter — writes `model_steadystate.m` |
| **Klein** | L.R. Klein | Runner — executes Dynare (MATLAB Agentic Toolkit) |
| **Hendry** | D.F. Hendry | Validator — classifies SYN/SS/BK/ID errors |
| **Lucas** | R.E. Lucas | Reviewer — IRF signs, moments, Lucas critique |
| **Marshall** | A. Marshall | Shipper — packages `user-project/` |

## Repository map

| Path | Contents |
|---|---|
| [`docs/`](docs/) | Architecture reference, integration design, **user guide** |
| [`models/`](models/) | DSGE model documents (e.g. [`RBC_model.polished.md`](models/RBC_model.polished.md)) |
| [`paper/`](paper/) | The journal paper ([PDF](paper/MacroModelClaw.pdf), LaTeX, figures) |
| [`slides/`](slides/) | Beamer presentation |
| [`julia-steadystate-mcp/`](julia-steadystate-mcp/) | Julia steady-state MCP server (Judd) |
| [`dynare-agentic-toolkit/`](dynare-agentic-toolkit/) | Claude Code plugin (skills) |
| [`user-project/`](user-project/) | A complete example run (RBC) |

The full design is in [`docs/dynare_agent_architecture.md`](docs/dynare_agent_architecture.md);
the academic write-up is [`paper/MacroModelClaw.pdf`](paper/MacroModelClaw.pdf).

---

# User Guide

A quickstart and workflow guide for using MacroModelClaw to go from a single model document to a
running, reviewed Dynare DSGE model.

> **Audience:** you write economics (`model-doc.md`), the agents write and run the Dynare code.
> You do not need to write `.mod` or `_steadystate.m` by hand, and you do not need to derive the
> steady state — the Julia module auto-solves it from your equations and calibration. Supplying
> an analytical steady state is optional and only speeds things up.

## 1. What it does

You provide **one structured document** (`model-doc.md`). A pipeline of ten economist-named
agents then:

1. parses and validates it (Tinbergen),
2. extracts calibration and initial values (Prescott),
3. writes `model.mod` (Kydland),
4. solves the non-stochastic steady state numerically (Judd, Julia SS MCP),
5. writes `model_steadystate.m` from it (Walras),
6. runs Dynare via the MATLAB Agentic Toolkit (Klein),
7. classifies any errors and routes fixes (Hendry),
8. reviews the economics — IRF signs, moments, Lucas critique (Lucas),
9. packages everything into `user-project/` (Marshall),

with Keynes orchestrating and circuit-breaking the loop.

## 2. Prerequisites

Three MCP instrument servers back the agents — *parse/diagnose*, *steady-state solve*, *execute*:

| Component | Why | Check |
|---|---|---|
| **Claude Code** + MacroModelClaw plugin | runs the agents | plugin installed |
| **Python 3.10+** + LLMacro‑Dynare‑LSP | parse/diagnose: preprocessor, diagnostics, BK check | `python -m dynare_lsp --check model.mod` |
| **Julia 1.10+** + `julia-steadystate-mcp` deps | steady-state solve (Judd) | `julia --project=julia-steadystate-mcp -e 'using NonlinearSolve, MacroModelling'` |
| **Dynare 6.x / 7.x** + **MATLAB R2021a+** + **MATLAB Agentic Toolkit** | execute: Klein runs Dynare; Walras lints `.m` | ask the agent "what MATLAB version / toolboxes?" → `detect_matlab_toolboxes` answers |

One-time setup:

```bash
# Julia steady-state backend (Judd)
cd julia-steadystate-mcp && julia --project=. -e 'using Pkg; Pkg.instantiate()'

# LLMacro diagnostic/verification layer (Python 3.10+)
git clone https://github.com/pdwhoward/LLMacro-Dynare-LSP.git
cd LLMacro-Dynare-LSP && pip install -e ".[solver]"
```

```matlab
% MATLAB execution layer (Klein) — run INSIDE MATLAB R2021a+
% open agenticToolkitInstaller.mltbx (from matlab/matlab-agentic-toolkit releases), then:
setupAgenticToolkit("install")   % installs MATLAB Core skills + auto-configures the MCP
```

The LLMacro + Julia MCP servers are registered in the plugin `mcpServers` block; the MATLAB
Agentic Toolkit registers itself during `setupAgenticToolkit`. See
[`julia-steadystate-mcp/README.md`](julia-steadystate-mcp/README.md) and
[`docs/steady_state_julia_integration.md`](docs/steady_state_julia_integration.md).

> **macOS preprocessor:** LLMacro's bundled preprocessor is a Windows `.exe`. Point it at a
> native binary from your Dynare install via the `DYNARE_PREPROCESSOR` env var in the `dynare`
> MCP server config (the env var beats the bundled copy, which is auto-skipped on macOS):
> ```json
> "env": { "DYNARE_PREPROCESSOR": "/Applications/Dynare/7.0-x86_64/preprocessor/dynare-preprocessor" }
> ```

## 3. Quickstart

```text
1. Write models/your_model/model-doc.md   (the only file you author — see §4)
      → minimum: §1 equations + §2 calibration. The steady state is optional (Julia auto-solves).
      → template: models/RBC_model.polished.md
2. In Claude Code:  "Run the MacroModelClaw pipeline on models/RBC_model.polished.md"
3. Answer any HOLD questions Tinbergen raises (e.g. a missing parameter value)
4. Read results in  user-project/   (see §6)
```

That's the whole loop. Everything below is detail on the input format, the workflow, and how to
read the outputs.

## 4. The input: `model-doc.md`

This is the **single source of truth**. (Canonical spec:
[`docs/dynare_agent_architecture.md`](docs/dynare_agent_architecture.md) §2.) A complete worked
example you can copy as a template is
[`models/RBC_model.polished.md`](models/RBC_model.polished.md).

### What's required vs. optional

| Section | Required? | Purpose |
|---|---|---|
| §1 — equations + variable/parameter definitions | **required** | the model itself |
| §2 — calibration (parameter values) | **required** | the numbers to solve at |
| §3 — analytical steady state and/or residual system | **optional** | *accelerator* (see below) |

> **You do not have to derive the steady state.** The Julia steady-state module
> (`solve_steady_state_model`, MacroModelling.jl) auto-detects and computes the non-stochastic
> steady state from the §1 equations and §2 parameter values alone — symbolic reduction of
> redundant variables, block/SCC decomposition, then a numerical solve (NonlinearSolve.jl).
> Supplying §3 is **optional but valuable**: a closed-form derivation or a residual system
> sharply cuts the solve cost, improves robustness on strongly nonlinear models, and lets Walras
> emit a *deterministic* `_steadystate.m`. Provide it if you have it; omit it otherwise.

### §1 — Dynamic Equilibrium System (required)
The equilibrium equations (timing explicit) **and** a variable/parameter definition table.
Write the math in natural notation; the agents normalize to the code convention below.

### §2 — Calibration (required)
Parameter values with source. Some parameters may be pinned by steady-state normalizations
rather than set directly (e.g. normalize `y=1, h=1/3` and back out `ā`, `κ_L`).

### §3 — Steady state (optional accelerator)
Supply closed-form solutions, a residual system, or both:
- **Closed form:** Walras emits a deterministic `_steadystate.m`; Judd only *checks* it.
- **Residual system + unknown list:** must be **exactly identified** (#equations = #unknowns);
  Judd solves it via `solve_steady_state_system`.
- **Omitted:** Judd solves the whole NSSS automatically via `solve_steady_state_model`.

### Notation (enforced in *generated* code — not your input)
| Kind | Convention | Example |
|---|---|---|
| Endogenous levels | UPPERCASE | `C`, `Y`, `PI`, `R` |
| Steady-state values | UPPERCASE + `ss` | `Css`, `Yss`, `PIss` |
| Parameters | lowercase | `beta`, `alpha`, `sigma` |
| Shocks | `eps_` prefix | `eps_a`, `eps_g` |

### HOLD conditions (Tinbergen pauses and asks you)
| ID | Trigger | What you'll be asked |
|---|---|---|
| **HOLD-1** | a §2 parameter has a symbol but no value, not pinned by a normalization or listed as an unknown | supply the value |
| **HOLD-2** | *(only if you provide a §3 residual system)* `#equations ≠ #unknowns` | add/remove an equation or unknown |
| **HOLD-3** | *(only if you provide a §3 derivation)* a §1 variable it leaves uncovered | complete it — or delete §3 and let Julia auto-solve |

**HOLD-2 and HOLD-3 only fire on the optional hand-derived path.** With §1 + §2 alone, the Julia
auto-solver takes over and neither applies.

## 5. The workflow, step by step

| # | Agent | Reads | Produces | What to watch |
|---|---|---|---|---|
| 1 | **Tinbergen** | `model-doc.md` | 4 spec files | HOLD-1/2/3 questions |
| 2 | **Prescott** | §2 (+ §3 if provided) | `calibration-spec.md`, `x0` | param values complete |
| 3 | **Kydland** | spec | `model.mod` | no invented Dynare syntax |
| 4 | **Judd** | `model.mod` (auto) or §3 system | SS values + residual norm | auto-solves; or validates §3 |
| 5 | **Walras** | `model.mod` + Judd's SS | `model_steadystate.m` | deterministic if §3 closed-form; else seeded from Judd |
| 6 | **Klein** | `model.mod` | run log, `oo_`/`M_` | preprocessor SYN gate, then MATLAB run (warm session) |
| 7 | **Hendry** | stderr, SS, BK | `validation-report.md` | error class: **SYN / SS / BK / ID** |
| 8 | **Lucas** | IRFs, moments, §1 | `review-report.md` | IRF signs, moment match, Lucas critique |
| 9 | **Marshall** | all outputs | `user-project/` | final package |

## 6. Reading the outputs (`user-project/`)

```
user-project/
├── inputs/model-doc.md          # read-only archive of what you submitted
├── specs/                       # Tinbergen's 4 spec files
├── model/                       # model.mod + model_steadystate.m
├── results/                     # IRF plots, moments_table.csv, steadystate_table.csv, validation-report.md
├── review/review-report.md      # Lucas: IRF signs, moments, Lucas critique
└── logs/                        # dynare_output.log + agent-trace.jsonl
```

Start with `results/validation-report.md` (did it run cleanly?) then `review/review-report.md`
(is it economically sane?). `logs/agent-trace.jsonl` is the full audit trail.

## 7. Troubleshooting (error class → who fixes it)

| Symptom | Class | Fixed by | Typical cause |
|---|---|---|---|
| Dynare rejects the file / parse error | **SYN** | Hendry → Kydland | mis-written equation/option |
| Steady state won't solve / residuals large | **SS** | Hendry → Judd/Walras | bad `x0`, wrong `_steadystate.m`, non-exact ID |
| "Blanchard-Kahn conditions not satisfied" | **BK** | Hendry → Kydland/Walras | timing error, indeterminacy |
| Identification warning | **ID** | Hendry → user/Kydland | under-identified parameters |
| Runs, but IRF sign looks wrong | review | Lucas → you | model/calibration issue, not a code bug |

Common environment issues:
- **Klein can't run Dynare** → the MATLAB Agentic Toolkit isn't connected; install it inside
  MATLAB R2021a+ and restart.
- **First Julia call is slow** → MacroModelling/NonlinearSolve precompiling; build a sysimage.

## 8. Tips

- **Start minimal.** §1 + §2 is enough — let Judd auto-solve. Add §3 only for hard/large models.
- **If you hand-derive §3, make the residual system exactly identified.**
- **Trust the cross-check.** Agreement between Walras's `_steadystate.m` and Judd's numerical
  solve is strong evidence the steady state is correct before Dynare runs.
- **Read `agent-trace.jsonl`** when something surprises you — it records the exact spec each agent
  saw, preserving the information barriers.

---

## See also

- [`docs/dynare_agent_architecture.md`](docs/dynare_agent_architecture.md) — canonical design
- [`docs/steady_state_julia_integration.md`](docs/steady_state_julia_integration.md) — LLMacro + Julia + MATLAB integration
- [`docs/macromodelclaw_user_guide.md`](docs/macromodelclaw_user_guide.md) — this guide (canonical copy)
- [`paper/MacroModelClaw.pdf`](paper/MacroModelClaw.pdf) — the paper
