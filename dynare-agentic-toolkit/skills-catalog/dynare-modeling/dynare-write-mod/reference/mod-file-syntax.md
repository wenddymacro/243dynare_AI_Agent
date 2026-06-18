# Dynare .mod File Syntax Reference

Requires Dynare 6.x. Full documentation: https://www.dynare.org/manual/

## Block Order

1. `var` — endogenous variables
2. `varexo` — exogenous shocks
3. `varexo_det` — deterministic exogenous (optional)
4. `parameters` — declare parameter names
5. Parameter value assignments
6. `model;...end;` — equilibrium equations
7. `initval;...end;` OR `steady_state_model;...end;` (or companion `_steadystate.m`)
8. `shocks;...end;`
9. `stoch_simul(options);`

## Variable Declarations

```dynare
var C Y PI R N A;           // space-separated
varexo eps_a eps_r;
parameters beta alpha sigma phi rho_a PIss Rss;
```

## Model Block

```dynare
model;
  // Comments use // or /* */
  1/C = beta * (1/C(+1)) * R / PI(+1);   // Euler equation
  log(A) = rho_a * log(A(-1)) + eps_a;    // AR(1) process
end;
```

**Rules:**
- One equation per line, ending with `;`
- Time subscripts: `(+1)` for lead, `(-1)` for lag, no subscript = current period
- Equations are written as `LHS = RHS;` — Dynare computes `LHS - RHS = 0` internally
- Number of equations must equal number of `var` declarations exactly

## Steady State

**Option A — `steady_state_model` block (analytical):**
```dynare
steady_state_model;
  A   = 1;
  PI  = PIss;
  R   = PIss / beta;
  N   = ((1-alpha)/phi)^(1/(sigma+alpha));
  Y   = N^(1-alpha);
  C   = Y;
end;
```

**Option B — `initval` block (initial guess + `steady` command):**
```dynare
initval;
  A   = 1;
  PI  = 1;
  R   = 1/beta;
  N   = 0.33;
  Y   = 0.5;
  C   = 0.5;
end;
steady;   // Dynare solves numerically from initval
```

**Option C — companion `_steadystate.m` file (numerical solver):** Use `dynare-steady-state` skill.

## Shocks Block

```dynare
shocks;
  var eps_a;   stderr 0.01;       // standard deviation
  var eps_r;   stderr 0.0025;
  // Cross-correlation (optional):
  corr eps_a, eps_r = 0.0;
end;
```

## stoch_simul Command

```dynare
stoch_simul(order=2, irf=20, hp_filter=1600, nograph);
// or with variable list (compute moments only for listed vars):
stoch_simul(order=2, irf=20) C Y PI R;
```

## Useful Commands After stoch_simul

```matlab
% After dynare run, in MATLAB:
oo_.steady_state          % steady-state vector (indexed by M_.endo_names order)
oo_.irfs                  % struct: oo_.irfs.C_eps_a = IRF of C to eps_a shock
oo_.mean                  % unconditional mean
oo_.var                   % unconditional variance
M_.endo_names             % endogenous variable names (char array)
M_.param_names            % parameter names
M_.params                 % parameter values
options_                  % all solver options used
```

## Common Gotchas

- **Equation count must match `var` count exactly.** If you declare 6 variables, you need exactly 6 equations.
- **Log of negative:** If any variable can go negative, don't take `log()` of it directly.
- **Gross vs net rates:** This toolkit uses gross rates (`PI = 1 + pi`, `R = 1 + r`). Do not mix gross and net.
- **`PIss = 1` for zero steady-state inflation.** Set explicitly as a parameter.
- **Time subscripts on shocks:** Shocks (`varexo`) should never have time subscripts in the model block (they are always current-period).
