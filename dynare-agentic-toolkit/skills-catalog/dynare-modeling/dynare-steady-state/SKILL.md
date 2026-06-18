---
name: dynare-steady-state
description: Write a Dynare-compatible _steadystate.m file for numerical steady-state solving. Use when the model has no closed-form steady state and fsolve is needed. Generates the correct function signature and fsolve-based solver from the user's equations.
metadata:
  version: "1.0"
---

# Writing _steadystate.m for Dynare

## When to Use

Use `_steadystate.m` when:
- The steady-state system is nonlinear and cannot be solved analytically step by step
- The model has price stickiness, financial frictions, or other features that couple steady-state variables nonlinearly
- `steady_state_model;` block produces wrong results or you cannot isolate each variable analytically

Use `steady_state_model;` block instead when:
- Each variable can be solved sequentially from others (triangular system)
- A simple NK model with zero steady-state inflation: `PI=1, R=1/beta, N=...` can be computed line by line

## Dynare's Required Function Signature

The `_steadystate.m` file **must** use exactly this signature:

```matlab
function [ys, params, check] = modelname_steadystate(ys, exo, M_, options_)
```

- `ys`: vector of steady-state values (same length as `M_.endo_names`, same order)
- `params`: `M_.params` — return this unchanged unless your solver modifies parameter values
- `check`: set to 1 if solver failed (Dynare will report an error); 0 if success
- `exo`: vector of deterministic exogenous steady-state values (usually zeros)
- `M_`: Dynare model structure (contains `M_.params`, `M_.param_names`, `M_.endo_names`)
- `options_`: Dynare options structure

The filename must be `<modelname>_steadystate.m` where `<modelname>` matches the `.mod` filename exactly (case-sensitive).

## Workflow

### 1. Identify variables requiring numerical solving

Read the `.mod` file. List variables whose steady-state values depend on others in a nonlinear, non-triangular way.

### 2. Extract parameter values from M_.params

```matlab
for i = 1:length(M_.param_names)
    eval([strtrim(M_.param_names(i,:)) ' = M_.params(i);']);
end
```

This creates local variables for all parameters (e.g., `beta`, `alpha`, `sigma`) in the function workspace.

### 3. Write the fsolve system

See `scripts/steadystate_fsolve.m` for the full template. The key pattern:

```matlab
function res = ss_residuals(x, p)
    C = x(1); N = x(2); Y = x(3); K = x(4);
    beta = p.beta; alpha = p.alpha; delta = p.delta; sigma = p.sigma;
    res(1) = C^(-sigma) - beta * C^(-sigma) * (alpha*Y/K + 1 - delta);  % Euler
    res(2) = (1-alpha) * Y/N - C^sigma;                                   % Labor
    res(3) = Y - K^alpha * N^(1-alpha);                                   % Production
    res(4) = Y - C - delta*K;                                             % Goods market
end
```

### 4. Assign ys output vector

After solving, assign results to `ys` in the order of `M_.endo_names`. Always use `strcmp` — never hardcode indices:

```matlab
endo_names = cellstr(M_.endo_names);
ys(strcmp(endo_names, 'C')) = C_ss;
ys(strcmp(endo_names, 'Y')) = Y_ss;
ys(strcmp(endo_names, 'A')) = 1;
ys(strcmp(endo_names, 'PI')) = PIss;
ys(strcmp(endo_names, 'R'))  = PIss / beta;
```

### 5. Validate with evaluate_matlab_code

After writing the file, re-run Dynare and inspect the steady state:

```matlab
dynare('model.mod', 'noclearall');
disp(oo_.steady_state)
```

Check that no values are NaN and values are economically plausible.

## Template Files

- `scripts/steadystate_template.m` — blank template with correct signature and parameter extraction
- `scripts/steadystate_fsolve.m` — full fsolve-based example (RBC model)
- `scripts/steadystate_closed_form.m` — mixed: analytical for some vars, fsolve for others

## Gotchas

**Variable order in `ys`:** The `ys` vector must be indexed by Dynare's `M_.endo_names` order. Always use `strcmp(cellstr(M_.endo_names), 'varname')` — never hardcode index numbers.

**`check = 1` on solver failure:** If `fsolve` does not converge (exit flag ≤ 0), set `check = 1`. This causes Dynare to report a clear error rather than using a wrong solution silently.

**Function name must match filename:** `function [ys,params,check] = mymodel_steadystate(...)` must be in file `mymodel_steadystate.m`.
