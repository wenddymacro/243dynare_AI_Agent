# Getting Started with Dynare Agentic Toolkit

## Prerequisites

1. **Dynare 6.x / 7.x** installed. Download from [dynare.org](https://www.dynare.org/download/).
2. **MATLAB R2021a or later** with the official **MATLAB Agentic Toolkit**
   ([matlab/matlab-agentic-toolkit](https://github.com/matlab/matlab-agentic-toolkit)) — this
   is MathWorks' MCP server and supersedes the older third-party `matlab-mcp-server`.
   Install from *inside MATLAB R2021a+*: open `agenticToolkitInstaller.mltbx`, then run
   ```matlab
   setupAgenticToolkit("install")
   ```
   It installs the **MATLAB MCP Core Server**, auto-configures Claude Code's MCP (no manual
   `mcpServers` editing), and exposes `run_matlab_file`, `evaluate_matlab_code`,
   `check_matlab_code`, `run_matlab_test_file`, and `detect_matlab_toolboxes`. Install only the
   **MATLAB Core** skill group. Restart Claude Code afterward.
3. **Claude Code** CLI installed.

## Installation

### Step 1: Clone this repo

```bash
git clone https://github.com/wenddymacro/dynare-agentic-toolkit.git
cd dynare-agentic-toolkit
```

### Step 2: Register the plugin with Claude Code

```bash
claude mcp add .claude-plugin/marketplace.json
```

Or add it to your Claude Code settings manually:

```json
{
  "plugins": ["path/to/dynare-agentic-toolkit/.claude-plugin/marketplace.json"]
}
```

### Step 3: Start Claude Code and run setup

In your project directory:

```bash
claude
```

Then tell Claude:

> "Set up Dynare for this session."

Claude will run the `dynare-setup` skill to detect your installation, configure the path, and verify the version.

## First Model Workflow

1. **Setup:** "Set up Dynare." → `dynare-setup` skill
2. **Write model:** "Write a basic New Keynesian .mod file with Calvo pricing." → `dynare-write-mod` skill
3. **Steady state:** "Write a `_steadystate.m` file for this model." → `dynare-steady-state` skill
4. **Run:** Claude calls `run_matlab_file` → `dynare('model.mod')`
5. **IRFs:** "Show me IRFs for a monetary policy shock." → `dynare-irf` skill
6. **Extract results:** "Give me a moments table." → `dynare-postprocess` skill

## Notation

This toolkit uses a standardized convention across all generated files:

- Endogenous level variables: uppercase (`C`, `Y`, `PI`, `R`)
- Steady-state values: uppercase + `ss` (`Css`, `Yss`, `PIss`)
- Parameters: lowercase (`beta`, `alpha`, `sigma`)
- Shocks: `eps_` prefix (`eps_a`, `eps_r`)

See `skills-catalog/dynare-modeling/dynare-write-mod/reference/notation-conventions.md` for the full convention.
