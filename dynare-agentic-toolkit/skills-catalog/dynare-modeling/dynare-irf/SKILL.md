---
name: dynare-irf
description: Extract, plot, and analyze impulse response functions from Dynare oo_.irfs. Use after stoch_simul completes to visualize model dynamics and compare parameterizations.
metadata:
  version: "1.0"
---

# Impulse Response Functions in Dynare

## When to Use

- Extracting IRFs after `stoch_simul` has run successfully
- Plotting IRF panels for selected variables and shocks
- Comparing IRFs across parameterizations or model variants
- Normalizing shocks to different sizes

## oo_.irfs Structure

After `stoch_simul`, Dynare populates `oo_.irfs` as a struct where each field is named `<varname>_<shockname>`:

```matlab
oo_.irfs.C_eps_a    % IRF of C to a 1 std dev eps_a shock (T×1 vector)
oo_.irfs.Y_eps_a    % IRF of Y to eps_a
oo_.irfs.C_eps_r    % IRF of C to eps_r
```

The length of each IRF vector equals the `irf` option in `stoch_simul` (default 40 if not set explicitly).

**Important for order=2:** With second-order perturbation, IRFs are state-dependent. Dynare reports IRFs around the stochastic steady state (the ergodic mean), not the deterministic steady state. This is the correct object for welfare analysis.

## Before Extracting

Confirm `stoch_simul` ran with `irf > 0`:
```matlab
options_.irf         % should be > 0
fieldnames(oo_.irfs) % list all available IRF fields
```

## Workflow

### 1. List available IRFs

```matlab
fieldnames(oo_.irfs)
```

This shows all `varname_shockname` combinations. Confirm the IRFs you need exist before extracting.

### 2. Extract IRFs using scripts/extract_irf.m

```matlab
vars   = {'C', 'Y', 'PI', 'R', 'N'};
shock  = 'eps_a';
T      = options_.irf;
irf_mat = zeros(T, length(vars));
for i = 1:length(vars)
    field = [vars{i} '_' shock];
    if isfield(oo_.irfs, field)
        irf_mat(:,i) = oo_.irfs.(field);
    else
        warning('IRF not found: %s', field);
    end
end
```

Or call the helper function:
```matlab
irf_mat = extract_irf(oo_, options_, {'C','Y','PI','R'}, 'eps_a');
```

### 3. Plot IRF panel using scripts/plot_irf_panel.m

```matlab
plot_irf_panel(irf_mat, {'C','Y','PI','R'}, 'eps_a', {'Consumption','Output','Inflation','Rate'});
```

### 4. Compare IRFs across parameterizations

Run the model twice, save `oo_.irfs` under different names, then use `compare_irf`:

```matlab
dynare('model_baseline.mod', 'noclearall');
irf_base = oo_.irfs;
dynare('model_alternative.mod', 'noclearall');
irf_alt  = oo_.irfs;

irf_mat1 = extract_irf_from_struct(irf_base, options_, {'C','Y'}, 'eps_a');
irf_mat2 = extract_irf_from_struct(irf_alt,  options_, {'C','Y'}, 'eps_a');
compare_irf(irf_mat1, irf_mat2, {'C','Y'}, 'eps_a', {'Baseline','Alternative'});
```

## Gotchas

**Units:** Dynare normalizes IRFs to a 1 standard deviation shock. To get a 1% shock response:
```matlab
irf_1pct = oo_.irfs.Y_eps_a / sqrt(options_.Sigma_e(1,1)) * 0.01;
```
where `options_.Sigma_e(1,1)` is the variance (std dev squared) of the first shock.

**Variable names are case-sensitive:** `oo_.irfs.C_eps_a` not `oo_.irfs.c_eps_a`.

**irf=0 means no IRFs:** If `stoch_simul` was called with `irf=0`, `oo_.irfs` will be empty. Re-run with `irf=20` (or your preferred horizon).

**order=2 IRFs vs order=1:** At `order=1`, IRFs are state-independent (same regardless of initial conditions). At `order=2`, IRFs are computed at the ergodic mean of the state vector. For large shocks or welfare analysis, `order=2` IRFs are preferred.
