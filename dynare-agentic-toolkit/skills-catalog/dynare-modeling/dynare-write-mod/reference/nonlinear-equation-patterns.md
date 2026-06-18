# Nonlinear Equation Patterns for Dynare

Common FOC patterns in original nonlinear form. All notation follows `notation-conventions.md`.

## Household

**Euler equation (CRRA utility, separable):**
```dynare
C^(-sigma) = beta * C(+1)^(-sigma) * R / PI(+1);
```

**Labor-leisure FOC (separable utility):**
```dynare
phi * N^sigma = W * C^(-sigma);
```

**Bond Euler (real bond, no inflation):**
```dynare
C^(-sigma) = beta * C(+1)^(-sigma) * R_real;
```

## Firm

**Production function (Cobb-Douglas, no capital):**
```dynare
Y = A * N^(1-alpha);
```

**Production function (with capital):**
```dynare
Y = A * K(-1)^alpha * N^(1-alpha);
```

**Capital accumulation:**
```dynare
K = (1-delta) * K(-1) + I;
```

**Marginal product of labor = real wage:**
```dynare
W = (1-alpha) * A * (K(-1)/N)^alpha;
```

**Simplified NKPC (log-linear form as equation in levels):**
```dynare
log(PI) = beta * log(PI(+1)) + kappa * log(MC);
```

## Monetary Policy

**Taylor rule (gross rates, level form):**
```dynare
R = Rss * (PI/PIss)^phi_pi * (Y/Yss)^phi_y * exp(eps_r);
```

**Taylor rule with interest rate smoothing:**
```dynare
R = R(-1)^rho_r * (Rss * (PI/PIss)^phi_pi * (Y/Yss)^phi_y)^(1-rho_r) * exp(eps_r);
```

## Market Clearing

**Goods market (no investment, no government):**
```dynare
Y = C;
```

**Goods market (with investment):**
```dynare
Y = C + I;
```

**Goods market (with government spending):**
```dynare
Y = C + G;
```

## Technology

**TFP process (AR(1) in logs):**
```dynare
log(A) = rho_a * log(A(-1)) + eps_a;
```

## Fisher Equation

**Linking nominal rate, real rate, and inflation:**
```dynare
R = R_real * PI(+1);
```
