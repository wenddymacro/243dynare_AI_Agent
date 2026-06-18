# Dynare Debug Knowledge Base

Accumulated error-solution pairs from real debugging sessions. The agent reads this file at **Step 0** of every debug workflow. After resolving any error, the agent appends a new entry to the appropriate section.

## How to Read

Each section corresponds to one error class. Each entry contains:
- **Error message:** the exact or representative error message pattern
- **Root cause:** root cause in one line
- **Solution:** numbered fix steps
- **Source:** "local diagnosis" or full forum URL
- **Date:** date added (YYYY-MM-DD)

## Matching Rule

Compare the current error message against each **Error message:** field in the relevant section. Partial match is sufficient — the error message may contain model-specific variable names. If matched, apply the solution steps directly. Scan entries linearly within the relevant section; no need to search other sections unless the error class is ambiguous.

## Write-Back Rule

After resolving an error:
1. Identify the error category and locate the corresponding section
2. Check whether an identical **Error message:** already exists in that section → if yes, skip
3. If not, append a new entry at the end of the section
4. Auto-increment the entry number (find the highest existing number in the section + 1)
5. If the error does not belong to any existing category, append under **Other / New Categories** with prefix OTH-XXX

**Entry format** (use exactly this structure when appending):

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

---

## BK Failure (Blanchard-Kahn conditions not satisfied)

*Prefix: BK-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## Collinearity / Jacobian Problems

*Prefix: COL-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## NaN in Steady State

*Prefix: NAN-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## Equation Count Mismatch

*Prefix: EQN-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## MEX Errors

*Prefix: MEX-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## Runtime Errors

*Prefix: RUN-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## Perturbation Order Issues

*Prefix: PRT-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## Version Errors

*Prefix: VER-XXX*

<!-- Append new entries below (see Write-Back Rule for format) -->

---

## Other / New Categories

*Prefix: OTH-XXX*

<!-- Append entries here when the error does not fit any category above. Create a named sub-section if multiple entries share a new class. -->
