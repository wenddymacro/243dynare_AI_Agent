---
name: dynare-setup
description: Set up Dynare in a MATLAB session. Detect installation, configure path, verify version (6.x+ required), and run a smoke test. Use at the start of any Dynare session, when path errors appear, or when verifying a new install.
metadata:
  version: "1.0"
---

# Setting Up Dynare

## When to Use

- Starting a new Dynare session (first step before any modeling)
- `Undefined function 'dynare'` or path-related errors
- After installing or updating Dynare
- Verifying Dynare is correctly configured

## Version Requirement

This toolkit requires **Dynare 6.x or above**. Always verify with `dynare_version` after setup. If below 6.0, inform the user and stop — do not attempt to run models on older versions.

## Workflow

### 1. Check if Dynare is already on the MATLAB path

```matlab
which dynare
```

If this returns a path, Dynare is already on the path. Skip to Step 4 (verify version).

If it returns `'dynare' not found`, proceed to Step 2.

### 2. Locate Dynare installation

Try common installation paths in order:

**macOS:**
```matlab
candidate_paths = {
    '/Applications/Dynare/6.x/matlab',
    '/usr/local/dynare/6.x/matlab',
    fullfile(getenv('HOME'), 'dynare', 'matlab')
};
for i = 1:length(candidate_paths)
    if exist(candidate_paths{i}, 'dir')
        fprintf('Found Dynare at: %s\n', candidate_paths{i});
    end
end
```

**Windows:**
```matlab
candidate_paths = {
    'C:\dynare\6.x\matlab',
    'C:\Program Files\Dynare\6.x\matlab'
};
for i = 1:length(candidate_paths)
    if exist(candidate_paths{i}, 'dir')
        fprintf('Found Dynare at: %s\n', candidate_paths{i});
    end
end
```

If no candidate path is found, **recommend installing the latest version first**:

> "Dynare does not appear to be installed. I recommend downloading the latest version from https://www.dynare.org/download/ — select the installer for your platform (macOS pkg, Windows exe, or source). After installation, re-run this setup skill."

If the user confirms Dynare is already installed but at a non-standard path, ask: "Please provide the path to the Dynare matlab directory (e.g., `/Applications/Dynare/6.3/matlab`)."

### 3. Add Dynare to the MATLAB path

Replace `<dynare_matlab_path>` with the path found above:

```matlab
addpath('<dynare_matlab_path>');
```

Ask the user: "Should I make this permanent by adding it to your `startup.m`? (recommended for regular use)"

If yes, locate or create `startup.m`:
```matlab
% Find where startup.m should go
userpath
```

Append to startup.m:
```matlab
addpath('<dynare_matlab_path>');
```

### 4. Verify Dynare version

```matlab
dynare_version
```

- If output is `6.x` or higher: proceed
- If output is below `6.0`: tell the user "This toolkit requires Dynare 6.x+. Please upgrade your installation before proceeding."

### 5. Run smoke test

Create and run a minimal test to confirm Dynare is working end-to-end. Write this to `/tmp/dynare_smoke_test.mod` and run it:

```matlab
% Contents of /tmp/dynare_smoke_test.mod:
% var Y;
% varexo e;
% parameters rho;
% rho = 0.9;
% model;
%   Y = rho*Y(-1) + e;
% end;
% shocks;
%   var e; stderr 0.01;
% end;
% stoch_simul(order=1, irf=0, noprint);
```

Run with:
```matlab
dynare('/tmp/dynare_smoke_test.mod', 'noclearall');
```

- If it runs without error: report "Dynare is correctly set up. Version: <X>. Ready to proceed."
- If MEX error appears: see Gotchas below.

## Gotchas

**MEX files not compiled:** On first install, Dynare's MEX files (compiled C routines for speed) may not be present. Symptom: `Error using ... Cannot find mexw64` or similar. Fix:
```matlab
cd('<dynare_matlab_path>');
dynare_make   % or: mex -setup; then rebuild
```
If this fails, direct the user to the Dynare installation documentation for their platform.

**Windows paths with spaces:** Paths like `C:\Program Files\Dynare` must be quoted:
```matlab
addpath('C:\Program Files\Dynare\6.2\matlab');
```

**Multiple Dynare versions:** `which -all dynare` shows all versions on path. Warn the user if multiple versions are detected; the first one found will be used.

**`restoredefaultpath` breaks MCP:** Never run `restoredefaultpath` — it removes the MCP server packages and breaks the eval channel. If it was run accidentally, restart MATLAB.
