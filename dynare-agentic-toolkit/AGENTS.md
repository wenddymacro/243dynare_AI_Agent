## Dynare Agentic Toolkit

This repository provides skills for Dynare DSGE modeling workflows. Use the `dynare-setup` skill first to configure the Dynare environment.

- Setup skill: `skills-catalog/dynare-core/dynare-setup/SKILL.md`
- Debug skill: `skills-catalog/dynare-core/dynare-debug/SKILL.md`
- Modeling skills: `skills-catalog/dynare-modeling/`

Plugin structure:
- `dynare-core` — environment setup and debugging (all users)
- `dynare-modeling` — write .mod files, steady state, IRFs, post-processing (requires dynare-core)

For implementation tasks, read the relevant SKILL.md before writing any Dynare code.
