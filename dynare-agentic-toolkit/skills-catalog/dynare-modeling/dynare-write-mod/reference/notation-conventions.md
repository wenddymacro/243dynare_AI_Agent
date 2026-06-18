# Notation Conventions

All .mod files, _steadystate.m files, and scripts in this toolkit use a standardized notation. This ensures Phase 2 model composition works without renaming conflicts.

## Endogenous Variables

Uppercase letters for level variables:

| Symbol | Variable |
|---|---|
| `C` | Consumption |
| `Y` | Output |
| `PI` | Gross inflation rate (1 + pi) |
| `R` | Gross nominal interest rate |
| `N` | Labor hours |
| `K` | Capital |
| `Q` | Tobin's Q / asset price |
| `MC` | Marginal cost |
| `W` | Real wage |

Sector-specific variables are prefixed by sector tag: `F_` (financial), `X_` (open economy), `G_` (government).

## Steady-State Values

Uppercase + `ss` suffix:

```
Css, Yss, PIss, Rss, Nss, Kss
```

These are used as parameters in the `parameters` block when the steady state is known analytically.

## Parameters

Lowercase, using Greek letter approximations where conventional:

| Symbol | Parameter |
|---|---|
| `beta` | Discount factor |
| `alpha` | Capital share |
| `sigma` | Inverse EIS (consumption) |
| `phi` | Inverse Frisch elasticity |
| `delta` | Depreciation rate |
| `theta` | Calvo price stickiness |
| `epsilon` | Elasticity of substitution |
| `rho_a` | TFP persistence |
| `rho_r` | Taylor rule persistence |
| `phi_pi` | Taylor rule inflation response |
| `phi_y` | Taylor rule output gap response |
| `kappa` | Slope of NKPC |

## Shocks

`eps_` prefix:

| Symbol | Shock |
|---|---|
| `eps_a` | TFP shock |
| `eps_r` | Monetary policy shock |
| `eps_g` | Government spending shock |
| `eps_z` | Preference shock |

## Variable Time Subscripts

Dynare notation:
- Current period: `X` or `X(0)`
- Lead: `X(+1)`, `X(+2)`
- Lag: `X(-1)`, `X(-2)`
