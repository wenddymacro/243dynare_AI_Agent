---
name: dynare-postprocess
description: Extract and analyze Dynare output structures (oo_, M_, options_). Named steady-state values, second moments, variance decomposition, and CSV/Excel export. Use after any successful Dynare run to access results programmatically.
metadata:
  version: "1.0"
---

# Post-Processing Dynare Output

## When to Use

- Extracting specific variable values from `oo_.steady_state`
- Computing or displaying second moments (variance, standard deviation, autocorrelation)
- Building variance decomposition tables
- Exporting results to CSV or Excel for external analysis
- Any time the user wants to work with Dynare results beyond the automatic console output

## Key Dynare Output Structures

| Structure | Contains | How to access |
|---|---|---|
| `oo_.steady_state` | Steady-state vector (ordered by `M_.endo_names`) | `oo_.steady_state(idx)` where idx from `strcmp` |
| `oo_.irfs` | IRF matrices by `varname_shockname` | `oo_.irfs.C_eps_a` |
| `oo_.mean` | Unconditional mean (order≥2 only) | `oo_.mean` |
| `oo_.var` | Variance-covariance matrix | `oo_.var(i,j)` |
| `oo_.autocorr` | Autocorrelation matrices (cell array, lags 1–5) | `oo_.autocorr{k}(i,j)` for lag k |
| `oo_.variance_decomposition` | Variance share per shock per variable | N_vars × N_shocks matrix |
| `M_.params` | Parameter values vector | `M_.params(idx)` |
| `M_.param_names` | Parameter names (char array) | `cellstr(M_.param_names)` |
| `M_.endo_names` | Endogenous variable names (char array) | `cellstr(M_.endo_names)` |
| `M_.exo_names` | Exogenous shock names | `cellstr(M_.exo_names)` |
| `options_` | All solver options | `options_.order`, `options_.irf` |

## Workflow

### 1. Map variable names to indices

Always use name-based indexing — never hardcode numeric indices:

```matlab
endo_names  = cellstr(M_.endo_names);
param_names = cellstr(M_.param_names);
exo_names   = cellstr(M_.exo_names);

idx_C = find(strcmp(endo_names, 'C'));
C_ss  = oo_.steady_state(idx_C);
```

### 2. Extract steady state

```matlab
% Quick extraction for a list of variables
vars = {'C','Y','PI','R','N'};
endo_names = cellstr(M_.endo_names);
for i = 1:length(vars)
    idx = find(strcmp(endo_names, vars{i}));
    fprintf('%s = %.6f\n', vars{i}, oo_.steady_state(idx));
end
```

Or use `scripts/extract_steady_state.m` for a formatted table.

### 3. Extract moments

```matlab
std_C = sqrt(oo_.var(strcmp(cellstr(M_.endo_names),'C'), strcmp(cellstr(M_.endo_names),'C')));
```

Or use `scripts/extract_moments.m` for a moments table with relative standard deviations and autocorrelations.

### 4. Variance decomposition

`oo_.variance_decomposition` is an `N_vars × N_shocks` matrix (rows = variables in `M_.endo_names` order, cols = shocks in `M_.exo_names` order, values = % variance explained):

```matlab
exo_names  = strtrim(cellstr(M_.exo_names));
endo_names = cellstr(M_.endo_names);
idx_Y = find(strcmp(endo_names, 'Y'));
for j = 1:length(exo_names)
    fprintf('%s -> Y: %.1f%%\n', exo_names{j}, oo_.variance_decomposition(idx_Y,j));
end
```

Or use `scripts/extract_variance_decomp.m` for a formatted table.

### 5. Export to CSV

Use `scripts/export_results.m` to export steady state, std devs, and autocorrelations to a CSV file.

## Gotchas

**`oo_.mean` only available with order≥2:** At order=1, the mean equals the deterministic steady state. At order=2, Dynare computes the stochastic mean (differs due to risk corrections).

**`oo_.var` covers all variables:** The variance matrix is N×N for all `var` declarations. Always use `strcmp` to find the right row/column.

**Char array vs cellstr:** `M_.endo_names` is a char array padded with spaces. Always convert with `cellstr()` before `strcmp`. `strtrim()` removes trailing spaces when displaying.

**`variance_decomposition` requires moments to be computed:** If `stoch_simul` was called with `nocorr` or `nofunctions`, variance decomposition may be absent.
