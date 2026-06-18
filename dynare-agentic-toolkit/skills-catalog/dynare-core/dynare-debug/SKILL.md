---
name: dynare-debug
description: Diagnose and fix Dynare errors — Blanchard-Kahn failures, collinear Jacobian, NaN in steady state, MEX issues, equation count mismatches. Use whenever a Dynare run produces an error or unexpected output.
metadata:
  version: "1.0"
---

# Debugging Dynare Models

## When to Use

- Any Dynare error message during a run
- `stoch_simul` fails or produces NaN/Inf results
- Blanchard-Kahn conditions not satisfied
- Model runs but IRFs look wrong (explosive, zero, or implausible)

## Reference Resources

Before running diagnostics, check these resources — especially the forum, which often has exact error messages with community-verified solutions:

- **Manual:** https://www.dynare.org/manual/ — authoritative reference for all commands, options, and error descriptions
- **Forum:** https://forum.dynare.org/ — search the exact error message text; most common errors have prior threads with solutions

Use these resources when local diagnostics have not resolved the error after 3 or more attempts.

## Auto-Trigger

When `run_matlab_file` or `evaluate_matlab_code` returns a Dynare error, **do not silently move on or guess**. Instead:

1. Identify the error class from the table below
2. Run the targeted diagnostic
3. Propose and verify the fix by re-running
4. **If the error persists after 3 or more fix attempts**, search https://forum.dynare.org/ for the exact error message text and apply community-verified solutions; after resolving, execute Step 4 and record the solution in the knowledge base (set **Source** to the full forum URL)

## Error Classification

| Error Message | Class | Diagnostic Direction |
|---|---|---|
| `Blanchard-Kahn conditions are not satisfied` | BK failure | Count forward-looking variables vs unstable eigenvalues; check Taylor principle |
| `Collinearity problems in the jacobian` | Identification | Find linearly dependent equations; remove redundant constraints |
| `NaN: oo_.steady_state contains NaN` | Steady state | Check parameter values; log of negative; division by zero in equations |
| `The model has N equations for N+k endogenous` | Equation count | Count `var` declarations vs equations in `model;...end;` block |
| `MEX file not found` / `mex` errors | MEX | Recompile MEX files |
| `Error using ... (line N)` in user code | Runtime | Inspect variable at that line |
| `order=2` crashes but `order=1` works | Perturbation | Verify regularity; check for unit roots |
| `dynare_version` below 6.0 | Version | Prompt user to upgrade |

## Workflow

### Step 0: Query the knowledge base

Read `knowledge-base/known-errors.md`. Find the section that matches the current error class, then scan entries linearly and compare the current error message against each **Error message:** field. Partial match is sufficient.

- **Match found** → Apply the solution steps from that entry. After a successful fix, proceed to Step 4 (write-back) and finish.
- **No match** → Continue to Step 1.

### Step 1: Read the .mod file

Use the `Read` tool (not MATLAB's `type`) to read the `.mod` file. Count: number of `var` declarations vs number of equations in `model;...end;` block. These must match exactly.

### Step 2: Run targeted diagnostic

**For BK failures:**
```matlab
% After dynare run (even failed), check eigenvalues
disp(oo_.dr.eigval)
fprintf('Unstable eigenvalues: %d\n', sum(abs(oo_.dr.eigval) > 1))
disp(M_.nsfwrd)   % number of non-predetermined forward-looking vars
```

The number of unstable eigenvalues must equal `M_.nsfwrd`. If too many unstable eigenvalues: Taylor principle violated (phi_pi < 1 or too low). If too few: policy rule too passive or model locally explosive.

**For NaN in steady state:**
```matlab
% Check parameter values
for i = 1:length(M_.param_names)
    fprintf('%s = %g\n', M_.param_names{i,:}, M_.params(i));
end
% Find which steady state values are NaN
endo_names = cellstr(M_.endo_names);
for i = 1:length(endo_names)
    if isnan(oo_.steady_state(i))
        fprintf('NaN: %s\n', endo_names{i});
    end
end
```

Common causes: `log(0)`, `1/0`, missing parameter initialization, or steady-state solver diverged.

**For equation count mismatch:**
Read the `.mod` file with the `Read` tool. Count lines ending in `;` inside `model;...end;`. Compare to the number of variables in `var`. Each variable needs exactly one equation.

**For collinearity:**
Look for market-clearing conditions that duplicate an identity already implied by other equations (Walras' law is a common culprit). One equation in the system is a linear combination of others — remove it.

**For MEX errors:**
```matlab
cd(fileparts(which('dynare')));
ls mex/   % check if .mexa64 / .mexw64 / .mexmaci64 files exist
```
If empty: direct user to recompile. On macOS/Linux: run `dynare_make` from the Dynare source or reinstall with precompiled MEX.

### Step 3: Propose and verify fix

After identifying the cause, propose a specific edit to the `.mod` file or parameters. Re-run:
```matlab
dynare('model.mod', 'noclearall');
```

Verify: no error messages, `oo_.steady_state` has no NaN, `stoch_simul` completes.

### Step 4: Write to knowledge base

After successfully resolving the error, append the solution to `knowledge-base/known-errors.md`:

1. Identify the error category and find the corresponding section
2. Check whether an identical **Error message:** already exists in that section — if yes, skip
3. If not, append a new entry at the end of the section using this format:

```
### [PREFIX-NNN] One-line description of the error cause

**Error message:** `exact or representative error text`
**Root cause:** one-line explanation
**Solution:**
1. Step one
2. Step two (if applicable)

**Source:** local diagnosis / https://forum.dynare.org/t/xxxxx (if from forum)
**Date:** YYYY-MM-DD
```

4. Auto-increment the entry number (find the highest existing number in the section + 1)
5. If the error does not belong to any existing category, append under **Other / New Categories** with prefix OTH-XXX

## Gotchas

**order=2 vs order=1:** If `order=2` fails but `order=1` works, isolate whether the issue is the steady state/linearization or the second-order approximation. Fix `order=1` first, then re-try `order=2`.

**`noclearall` during debugging:** Use `dynare('model.mod', 'noclearall')` to keep existing workspace variables between runs. Without it, Dynare clears the workspace on each run, losing diagnostic state.

**Dynare 6.x deprecations:** Some Dynare 5.x syntax produces warnings or errors in 6.x. If migrating 5.x `.mod` files, check the Dynare 6 release notes.

**Never run `restoredefaultpath`:** It removes the MCP server packages and breaks the eval channel. Recovery requires restarting MATLAB.
