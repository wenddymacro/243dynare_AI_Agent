# The Real Business Cycle Model

Valerio Nispi Landi  
November 2018

## 1. The Model

The model presented in these lecture notes is a version of the real business cycle framework first developed by Kydland and Prescott (1982). In this model households consume a consumption good, work in firms, invest in a risk-free real bond and in physical capital. Firms produce the consumption good using capital and labor. Government collects taxes in order to consume a public good.

### 1.1 Households

The representative household solves:

$$
\max_{\{c_t,i_t,h_t,k_t,b_t^r\}_{t=0}^{\infty}} E_0\sum_{t=0}^{\infty}\beta^t\left(\frac{c_t^{1-\sigma}}{1-\sigma}-\kappa\frac{h_t^{1+\phi}}{1+\phi}\right)
$$

subject to

$$
c_t+i_t+b_t^r=r_t^k k_{t-1}+r_{t-1}^r b_{t-1}^r+w_t h_t-t_t+\Gamma_t,
$$

$$
k_t=(1-\delta)k_{t-1}+\left[1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2\right]i_t.
$$

where $c_t$ is consumption, $h_t$ is labor, $i_t$ is investment, $k_t$ is capital, $r_t^k$ is the rental rate of capital, $b_t^r$ is the one-period real bond paying gross return $r_t^r$, $\Gamma_t$ are profits, and $t_t$ are lump-sum taxes.

The Lagrangian can be written as:

$$
\mathcal L = E_0\sum_{t=0}^{\infty}\beta^t\Bigg\{\frac{c_t^{1-\sigma}}{1-\sigma}-\kappa\frac{h_t^{1+\phi}}{1+\phi}
-\lambda_t\big(c_t+i_t+b_t^r-r_t^k k_{t-1}-r_{t-1}^r b_{t-1}^r-w_t h_t+t_t-\Gamma_t\big)
- q_t\lambda_t\Big[k_t-(1-\delta)k_{t-1}-\Big(1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2\Big)i_t\Big]\Bigg\}.
$$

First-order conditions:

$$
\lambda_t=c_t^{-\sigma}, \tag{1}
$$

$$
\kappa h_t^{\phi}=\lambda_t w_t, \tag{2}
$$

$$
\lambda_t=\beta E_t\left(\lambda_{t+1}r_t^r\right), \tag{3}
$$

$$
q_t=\beta E_t\left[\frac{\lambda_{t+1}}{\lambda_t}\left(r_{t+1}^k+(1-\delta)q_{t+1}\right)\right], \tag{4}
$$

$$
\begin{aligned}
1={}&q_t\left[1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2-\kappa_I\left(\frac{i_t}{i_{t-1}}-1\right)\frac{i_t}{i_{t-1}}\right] \\
&+\beta E_t\left[\frac{\lambda_{t+1}}{\lambda_t}q_{t+1}\kappa_I\left(\frac{i_{t+1}}{i_t}-1\right)\left(\frac{i_{t+1}}{i_t}\right)^2\right].
\end{aligned}
\tag{5}
$$

### 1.2 Firms

A representative firm produces the consumption/investment good with Cobb-Douglas technology:

$$
y_t=a_t k_{t-1}^{\alpha}h_t^{1-\alpha}. \tag{6}
$$

Productivity follows:

$$
\log a_t=(1-\rho_a)\log a+\rho_a\log a_{t-1}+v_t^a,
\quad v_t^a\sim\mathcal N(0,\sigma_a^2). \tag{7}
$$

The firm solves the static problem

$$
\max_{h_t,k_{t-1}}\; a_tk_{t-1}^{\alpha}h_t^{1-\alpha}-w_t h_t-r_t^k k_{t-1},
$$

which implies

$$
\alpha y_t=r_t^k k_{t-1}, \tag{8}
$$

$$
(1-\alpha)y_t=w_t h_t. \tag{9}
$$

### 1.3 Government

Government finances public expenditure with lump-sum taxes:

$$
g_t=t_t.
$$

Public spending follows:

$$
\log g_t=(1-\rho_g)\log g+\rho_g\log g_{t-1}+v_t^g,
\quad v_t^g\sim\mathcal N(0,\sigma_g^2). \tag{10}
$$

### 1.4 Market Clearing

Goods market:

$$
y_t=c_t+i_t+g_t. \tag{11}
$$

Bond market:

$$
b_t^r=0.
$$

Using household and firm budget relations, one can verify the goods market clearing condition is consistent (Walras' law).

## 2. Equilibrium

The equilibrium conditions are (1)-(11) plus bond-market clearing:

$$
\lambda_t=c_t^{-\sigma}
$$
$$
1=\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}r_t^r\right)
$$
$$
1=\beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\frac{r_{t+1}^k+(1-\delta)q_{t+1}}{q_t}\right)
$$
$$
\kappa h_t^{\phi}=\lambda_t w_t
$$
$$
k_t=(1-\delta)k_{t-1}+\left[1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2\right]i_t
$$
$$
\begin{aligned}
1={}&q_t\left[1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2-\kappa_I\left(\frac{i_t}{i_{t-1}}-1\right)\frac{i_t}{i_{t-1}}\right]\\
&+\beta E_t\left[\frac{\lambda_{t+1}}{\lambda_t}q_{t+1}\kappa_I\left(\frac{i_{t+1}}{i_t}-1\right)\left(\frac{i_{t+1}}{i_t}\right)^2\right]
\end{aligned}
$$
$$
y_t=a_tk_{t-1}^{\alpha}h_t^{1-\alpha}
$$
$$
(1-\alpha)y_t=w_t h_t
$$
$$
\alpha y_t=r_t^k k_{t-1}
$$
$$
y_t=c_t+i_t+g_t
$$
$$
\log a_t=(1-\rho_a)\log a+\rho_a\log a_{t-1}+v_t^a
$$
$$
\log g_t=(1-\rho_g)\log g+\rho_g\log g_{t-1}+v_t^g
$$

There are 12 endogenous variables:

$$
X_t\equiv(\lambda_t,c_t,r_t^r,r_t^k,w_t,h_t,y_t,k_t,q_t,i_t,g_t,a_t),
$$

and 2 exogenous shocks:

$$
v_t\equiv(v_t^a,v_t^g).
$$

## 3. Steady State

Variables without time index denote steady-state values.

From (7) and (10):

$$
a=\bar a,\qquad g=\bar g.
$$

In the calibration script, normalization choices are $y=1$ and $h=1/3$.

From (3):

$$
r^r=\frac{1}{\beta}.
$$

In steady state, (4) implies $q=1$, and then from (5):

$$
r^k=\frac{1}{\beta}-(1-\delta).
$$

From (8):

$$
k=\frac{\alpha y}{r^k}.
$$

From capital accumulation:

$$
i=\delta k.
$$

From (9):

$$
w=\frac{(1-\alpha)y}{h}.
$$

From (11):

$$
c=y-i-g.
$$

Marginal utility:

$$
\lambda=c^{-\sigma}.
$$

From (2):

$$
\kappa_L=\frac{w}{h^{\phi}c^{\sigma}}.
$$

From (6):

$$
a=\frac{y}{k^{\alpha}h^{1-\alpha}}.
$$

### 3.1 Calibration Values

| Symbol | Calibration | Meaning |
| --- | --- | --- |
| $\beta$ | $\beta=0.99$ | Discount factor |
| $\alpha$ | $\alpha=0.33$ | Capital share in production |
| $\delta$ | $\delta=0.025$ | Depreciation rate |
| $\sigma$ | $\sigma=2$ | Relative risk aversion |
| $\phi$ | $\phi=1$ | Inverse Frisch elasticity |
| $g_{ss}$ | $g_{ss}=0.2$ | Steady-state value of $g$ |
| $a_{ss}$ | $a_{ss}=\dfrac{y}{k^{\alpha}h^{1-\alpha}}$ | Steady-state value of $a$ |
| $\kappa_L$ | $\kappa_L=\dfrac{w}{h^{\phi}c^{\sigma}}$ | Labor disutility weight |
| $\kappa_I$ | $\kappa_I=0$ | Investment adjustment cost parameter |
| $\rho_a$ | $\rho_a=0.9$ | TFP shock persistence |
| $\rho_g$ | $\rho_g=0.9$ | Government spending shock persistence |


## References

- King, R. G. and Rebelo, S. T. (1999). *Resuscitating Real Business Cycles*. Handbook of Macroeconomics, 1:927-1007.
- Kydland, F. E. and Prescott, E. C. (1982). *Time to Build and Aggregate Fluctuations*. Econometrica, 50(6):1345-1370.
