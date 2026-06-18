---
name: dynare-write-mod
description: Write or edit Dynare .mod files for DSGE models. Scaffolds variable declarations, nonlinear FOC equations, stoch_simul block, and shocks. Use when writing a new model or modifying an existing .mod file.
metadata:
  version: "1.0"
---

# Writing Dynare .mod Files

## When to Use

- Writing a new DSGE model from scratch
- Adding variables, equations, or shocks to an existing `.mod` file
- Converting linearized equations to nonlinear form for Dynare
- Setting up `stoch_simul` options

## Before Writing

1. **Confirm perturbation order.** Default is `order=2`. Ask the user:
   > "I'll use `order=2` by default (second-order perturbation — captures risk premia and precautionary savings). Would you prefer `order=1` (faster, log-linear approximation) or `order=3` (higher moments, slower)?"

2. **Check notation.** All generated files follow the convention in `reference/notation-conventions.md`:
   - Endogenous levels: uppercase (`C`, `Y`, `PI`, `R`, `N`, `K`)
   - Steady-state values: uppercase + `ss` suffix (`Css`, `Yss`, `PIss`)
   - Parameters: lowercase (`beta`, `alpha`, `sigma`, `phi`)
   - Shocks: `eps_` prefix (`eps_a`, `eps_r`)

3. **Determine if `_steadystate.m` is needed.** If the model has no closed-form steady state, use the `dynare-steady-state` skill to write a companion `_steadystate.m` file. Ask the user if they have analytical steady-state expressions.

## .mod File Structure

A complete `.mod` file has these blocks in order:

```dynare
// 1. Variable declarations
var C Y PI R N A;           // endogenous variables (uppercase)
varexo eps_a eps_r;          // exogenous shocks (eps_ prefix)
parameters beta alpha sigma phi rho_a rho_r phi_pi phi_y PIss Rss;

// 2. Parameter values
beta   = 0.99;
alpha  = 0.33;
sigma  = 1.0;
phi    = 1.0;
rho_a  = 0.9;
rho_r  = 0.8;
phi_pi = 1.5;
phi_y  = 0.5;
PIss   = 1.0;
Rss    = PIss / beta;

// 3. Model block — nonlinear equilibrium equations
model;
  // Euler equation
  1/C = beta * (1/C(+1)) * R / PI(+1);
  // Labor supply
  phi * N^sigma = (1 - alpha) * A * (N/C)^(-alpha) / C;
  // Production
  Y = A * N^(1-alpha);
  // Market clearing
  Y = C;
  // Taylor rule
  R = Rss * (PI/PIss)^phi_pi * (Y/exp(log(Y(-1))))^phi_y * exp(eps_r);
  // TFP process
  log(A) = rho_a * log(A(-1)) + eps_a;
end;

// 4. Steady state (use steady_state_model block OR companion _steadystate.m)
steady_state_model;
  A   = 1;
  PI  = PIss;
  R   = Rss;
  N   = ((1-alpha)/phi)^(1/(sigma+alpha));
  Y   = N^(1-alpha);
  C   = Y;
end;

// 5. Shocks
shocks;
  var eps_a; stderr 0.01;
  var eps_r; stderr 0.0025;
end;

// 6. Simulation
stoch_simul(order=2, irf=20, hp_filter=1600);
```

## Workflow

1. **Scaffold the file** using the structure above, filling in the user's equations.
2. **Write equations in nonlinear form** — original FOC conditions, not log-linearized. Dynare linearizes internally. See `reference/nonlinear-equation-patterns.md` for common patterns.
3. **Verify equation count:** number of equations in `model;...end;` must equal number of variables declared in `var`.
4. **Run via MCP:**
   ```matlab
   dynare('model.mod', 'noclearall');
   ```
5. **If errors:** invoke `dynare-debug` skill.

## Reference Files

Read these before writing equations for the relevant pattern:

- `reference/notation-conventions.md` — naming rules (read first)
- `reference/mod-file-syntax.md` — full `.mod` syntax reference
- `reference/nonlinear-equation-patterns.md` — Euler equations, Calvo pricing, Taylor rule, market clearing

## stoch_simul Options

| Option | Default | Notes |
|---|---|---|
| `order` | 2 | 1=log-linear, 2=second-order, 3=third-order |
| `irf` | 20 | IRF horizon in periods |
| `hp_filter` | — | Apply HP filter with smoothing parameter (e.g., 1600 for quarterly) |
| `periods` | 0 | Simulate N periods (0 = no simulation) |
| `noprint` | — | Suppress console output |
| `nograph` | — | Suppress automatic plots |
| `nocorr` | — | Do not compute correlations |
