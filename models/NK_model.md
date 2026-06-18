# The New Keynesian Model

Valerio Nispi Landi[^author]

First version: November 2018

This version: March 2021

## 1 The Model[^model-note]

The New Keynesian model is an extension of the RBC model with two main differences. First,
there is a continuum of intermediate-good firms that produce a differentiated intermediate
good and act under monopolistic competition. The differentiated input is sold to final-good
firms, which operate under perfect competition. Final-good firms use the differentiated goods
as inputs to produce a final good, which is sold to households. Second, intermediate-good firms
pay adjustment costs when they change prices. This nominal rigidity breaks down the classical
dichotomy: unlike the RBC model, real and nominal variables cannot be analyzed separately
in the NK model and monetary policy can affect real variables. I use the same notation of the
lecture notes on the RBC model, new variables are defined when they first show up.[^simplified-model]

## 1.1 Households

The representative household solves the following optimization problem:

$$
\begin{aligned}
\max_{\{c_t,i_t,h_t,k_t,b_t\}_{t=0}^{\infty}}
&\ E_0 \sum_{t=0}^{\infty} \beta^t
\left(
\frac{c_t^{1-\sigma}}{1-\sigma}
- \kappa_L \frac{h_t^{1+\phi}}{1+\phi}
\right) \\
\text{s.t.}\quad
& p_t c_t + p_t i_t + b_t
= rk_t p_t k_{t-1} + r_{t-1} b_{t-1}
+ p_t w_t h_t - p_t t_t + p_t \Gamma_t, \\
& k_t = (1-\delta)k_{t-1}
+ \left[
1 - \frac{\kappa_I}{2}
\left(\frac{i_t}{i_{t-1}} - 1\right)^2
\right] i_t .
\end{aligned}
$$

where $p_t$ is the price level, $b_t$ is the amount of a one-period nominal risk-free bond paying
a nominal gross interest rate $r_t$. Notice that the budget constraint is expressed in nominal
terms. Divide both the left and right-hand side of the budget constraint by $p_t$ and write the
Lagrangian function as follows:

$$
\begin{aligned}
L = E_0 \left\{
\sum_{t=0}^{\infty} \beta^t
\left[
\left(
\frac{c_t^{1-\sigma}}{1-\sigma}
- \kappa_L \frac{h_t^{1+\phi}}{1+\phi}
\right)
- \lambda_t
\left(
c_t + i_t + \frac{b_t}{p_t}
- rk_t k_{t-1}
- r_{t-1}\frac{b_{t-1}}{p_t}
- w_t h_t + t_t - \Gamma_t
\right)
\right.\right. \\
\left.\left.
- q_t \lambda_t
\left(
k_t - (1-\delta)k_{t-1}
- \left[
1 - \frac{\kappa_I}{2}
\left(\frac{i_t}{i_{t-1}} - 1\right)^2
\right] i_t
\right)
\right]
\right\}.
\end{aligned}
$$
First order conditions (foc) with respect to (wrt) consumption:

$$
c_t^{-\sigma} = \lambda_t. \tag{1}
$$

Foc wrt labor:

$$
\kappa_L h_t^{\phi} = \lambda_t w_t. \tag{2}
$$

Foc wrt bonds:

$$
\lambda_t = \beta E_t
\left(
\lambda_{t+1}\frac{r_t}{\pi_{t+1}}
\right), \tag{3}
$$

where $\pi_t \equiv p_t/p_{t-1}$ is the gross inflation rate. Foc wrt capital:

$$
\begin{aligned}
0
&= -q_t\lambda_t
+ \beta E_t
\left[
\lambda_{t+1}rk_{t+1}
+ q_{t+1}\lambda_{t+1}(1-\delta)
\right], \\
q_t
&= \beta E_t
\left\{
\frac{\lambda_{t+1}}{\lambda_t}
\left[
rk_{t+1} + (1-\delta)q_{t+1}
\right]
\right\}.
\end{aligned}
\tag{4}
$$

Foc wrt investment:

$$
\begin{aligned}
0
&= -\lambda_t
+ q_t\lambda_t
\left[
1
- \kappa_I
\left(\frac{i_t}{i_{t-1}}\right)
\left(\frac{i_t}{i_{t-1}} - 1\right)
- \frac{\kappa_I}{2}
\left(\frac{i_t}{i_{t-1}} - 1\right)^2
\right] \\
&\quad
+ \beta E_t
\left\{
q_{t+1}\lambda_{t+1}
\left[
\kappa_I
\left(\frac{i_{t+1}}{i_t}\right)^2
\left(\frac{i_{t+1}}{i_t} - 1\right)
\right]
\right\}, \\
1
&= q_t
\left[
1
- \frac{\kappa_I}{2}
\left(\frac{i_t}{i_{t-1}} - 1\right)^2
- \kappa_I
\left(\frac{i_t}{i_{t-1}}\right)
\left(\frac{i_t}{i_{t-1}} - 1\right)
\right] \\
&\quad
+ \kappa_I \beta E_t
\left\{
q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
\left[
\left(\frac{i_{t+1}}{i_t}\right)^2
\left(\frac{i_{t+1}}{i_t} - 1\right)
\right]
\right\}.
\end{aligned}
\tag{5}
$$

The real interest rate $rr_t$ is defined as follows:

$$
rr_t \equiv \frac{r_t}{E_t[\pi_{t+1}]}. \tag{6}
$$

## 1.2 Final-Good Firms[^final-good-note]

The representative final-good firm uses the following CES aggregator to produce $y_t$:

$$
y_t =
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{\varepsilon}{\varepsilon-1}},
$$

where $y_t(i)$ is an intermediate input produced by the intermediate firm $i$, whose price is $p_t(i)$.
The problem of the final-good firm is the following:

$$
\begin{aligned}
\max_{y_t,\{y_t(i)\}_{i\in[0,1]}}
&\ p_t y_t - \int_0^1 p_t(i)y_t(i)\,di \\
\text{s.t.}\quad
& y_t =
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{\varepsilon}{\varepsilon-1}} .
\end{aligned}
$$

Plug the constraint in the objective function:

$$
\max_{\{y_t(i)\}_{i\in[0,1]}}
p_t
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{\varepsilon}{\varepsilon-1}}
- \int_0^1 p_t(i)y_t(i)\,di .
$$

Foc wrt the generic input $i$:

$$
\begin{aligned}
p_t
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{1}{\varepsilon-1}}
y_t(i)^{-\frac{1}{\varepsilon}}
&= p_t(i), \\
p_t y_t^{\frac{1}{\varepsilon}} y_t(i)^{-\frac{1}{\varepsilon}}
&= p_t(i), \\
y_t(i)
&= y_t\left(\frac{p_t(i)}{p_t}\right)^{-\varepsilon}.
\end{aligned}
\tag{7}
$$

Now we derive an expression for the price level as a function of the price of the intermediate
goods. The price level is defined as the price of one unit of the final-good. Hence:

$$
\begin{aligned}
p_t
= \min_{\{y_t(i)\}_{i\in[0,1]}}
&\left[
\int_0^1 p_t(i)y_t(i)\,di
\right] \\
\text{s.t.}\quad & y_t = 1 .
\end{aligned}
$$

The Lagrangian reads:

$$
L^P =
\int_0^1 p_t(i)y_t(i)\,di
- \zeta
\left\{
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{\varepsilon}{\varepsilon-1}}
- 1
\right\},
$$

where $\zeta$ is the lagrangian multiplier. Foc wrt the generic input $i$:

$$
p_t(i)
= \zeta y_t(i)^{-\frac{1}{\varepsilon}}
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{1}{\varepsilon-1}} .
$$

Rearrange:

$$
\begin{aligned}
p_t(i)^\varepsilon
&= \zeta^\varepsilon y_t(i)^{-1}
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{\varepsilon}{\varepsilon-1}}, \\
p_t(i)^\varepsilon
&= \zeta^\varepsilon y_t(i)^{-1}, \\
y_t(i)
&= \zeta^\varepsilon p_t(i)^{-\varepsilon}.
\end{aligned}
\tag{8}
$$

Use the constraint to find an expression for $\zeta$:

$$
\begin{aligned}
\left[
\int_0^1 y_t(i)^{\frac{\varepsilon-1}{\varepsilon}}\,di
\right]^{\frac{\varepsilon}{\varepsilon-1}}
&= 1, \\
\left[
\int_0^1 \zeta^{\varepsilon-1}p_t(i)^{1-\varepsilon}\,di
\right]^{\frac{\varepsilon}{\varepsilon-1}}
&= 1, \\
\zeta
&=
\left[
\int_0^1 p_t(i)^{1-\varepsilon}\,di
\right]^{\frac{1}{1-\varepsilon}} .
\end{aligned}
\tag{9}
$$

Plug (9) and (8) in the objective function:

$$
\begin{aligned}
p_t
&= \int_0^1 p_t(i)y_t(i)\,di \\
&= \int_0^1 p_t(i)\zeta^\varepsilon p_t(i)^{-\varepsilon}\,di \\
&= \zeta^\varepsilon \int_0^1 p_t(i)^{1-\varepsilon}\,di \\
&=
\left[
\int_0^1 p_t(i)^{1-\varepsilon}\,di
\right]^{\frac{\varepsilon}{1-\varepsilon}}
\left[
\int_0^1 p_t(i)^{1-\varepsilon}\,di
\right] \\
&=
\left[
\int_0^1 p_t(i)^{1-\varepsilon}\,di
\right]^{\frac{1}{1-\varepsilon}},
\end{aligned}
\tag{10}
$$

which is an expression for the price level as a function of the price of intermediate goods. Notice
that by using (7) and (10) one can show that real profits $\Gamma_t^F$ for the final-good firm are zero in equilibrium:

$$
\begin{aligned}
\Gamma_t^F
&= \frac{1}{p_t}
\left[
p_t y_t - \int_0^1 p_t(i)y_t(i)\,di
\right] \\
&= \frac{1}{p_t}
\left[
p_t y_t
- \int_0^1 p_t(i)y_t
\left(\frac{p_t(i)}{p_t}\right)^{-\varepsilon}
\,di
\right] \\
&= \frac{1}{p_t}
\left[
p_t y_t
- p_t^\varepsilon y_t\int_0^1 p_t(i)^{1-\varepsilon}\,di
\right] \\
&= \frac{1}{p_t}
\left(p_t y_t - p_t^\varepsilon y_t p_t^{1-\varepsilon}\right) \\
&= \frac{1}{p_t}(p_t y_t - p_t y_t) = 0 .
\end{aligned}
$$

## 1.3 Intermediate-Good Firms

There is a continuum of firms of measure unity, indexed by $i$, producing a differentiated input
through the following Cobb-Douglas function:

$$
y_t(i) = a_t(k_{t-1}(i))^\alpha(h_t(i))^{1-\alpha}, \tag{11}
$$

where $a_t$ is the total factor productivity, which follows an autoregressive process:

$$
\log(a_t) = (1-\rho_a)\log(a) + \rho_a\log(a_{t-1}) + v_t^a, \tag{12}
$$

and $v_t^a \sim N(0,\sigma_a^2)$ is a technology shock. Firms operate in monopolistic competition, so they
set the price of their own good subject to the demand of the final-good firm (7). In addition,
firms pay quadratic adjustment costs $AC_t(i)$ in nominal terms a la Rotemberg (1982), whenever
they adjust prices with respect to the inflation target $\bar{\pi}$:[^rotemberg-note]

$$
AC_t(i)
= \frac{\kappa_P}{2}
\left(\frac{p_t(i)}{p_{t-1}(i)}-\bar{\pi}\right)^2
p_t y_t .
$$

The profit maximization problem of the generic firm $i$, expressed in terms of the domestic price
index, is the following:

$$
\begin{aligned}
\max_{\{p_t(i),h_t(i),k_{t-1}(i),y_t(i)\}_{t=0}^{\infty}}
E_0
\left\{
\sum_{t=0}^{\infty}\beta^t\frac{\lambda_t}{\lambda_0}
\left[
\frac{p_t(i)}{p_t}y_t(i)
- w_t h_t(i)
- rk_t k_{t-1}(i)
- \frac{\kappa_P}{2}
\left(\frac{p_t(i)}{p_{t-1}(i)}-\bar{\pi}\right)^2y_t
\right]
\right\}
\end{aligned}
$$

subject to

$$
\begin{cases}
y_t(i) = y_t\left(\dfrac{p_t(i)}{p_t}\right)^{-\varepsilon},\\
y_t(i) = a_t(k_{t-1}(i))^\alpha(h_t(i))^{1-\alpha}.
\end{cases}
$$

Eliminate one constraint and write the lagrangian as follows:

$$
\begin{aligned}
L^I = E_0
\left\{
\sum_{t=0}^{\infty}\beta^t\frac{\lambda_t}{\lambda_0}
\left[
\left(\frac{p_t(i)}{p_t}\right)^{1-\varepsilon}y_t
- w_t h_t(i)
- rk_t k_{t-1}(i)
- \frac{\kappa_P}{2}
\left(\frac{p_t(i)}{p_{t-1}(i)}-\bar{\pi}\right)^2y_t
\right.\right. \\
\left.\left.
+ mc_t(i)
\left[
a_t(k_{t-1}(i))^\alpha(h_t(i))^{1-\alpha}
- y_t\left(\frac{p_t(i)}{p_t}\right)^{-\varepsilon}
\right]
\right]
\right\},
\end{aligned}
$$

where $mc_t(i)$ is the lagrangian multiplier, which can be interpreted as the real marginal cost
of producing an additional unit of output. Foc wrt capital:

$$
rk_t = mc_t(i)\alpha a_t(k_{t-1}(i))^{\alpha-1}(h_t(i))^{1-\alpha}.
$$

Foc wrt to labor:

$$
w_t = mc_t(i)(1-\alpha)a_t(k_{t-1}(i))^\alpha(h_t(i))^{-\alpha}.
$$

Foc wrt to $p_t(i)$:

$$
\begin{aligned}
&(1-\varepsilon)
\left(\frac{p_t(i)}{p_t}\right)^{-\varepsilon}
\frac{y_t}{p_t}
- \frac{\kappa_P}{p_{t-1}(i)}
\left(\frac{p_t(i)}{p_{t-1}(i)}-\bar{\pi}\right)y_t
+ \varepsilon mc_t(i)\frac{y_t}{p_t}
\left(\frac{p_t(i)}{p_t}\right)^{-\varepsilon-1} \\
&\quad
+ \beta E_t
\left[
\frac{\lambda_{t+1}}{\lambda_t}
\kappa_P
\frac{p_{t+1}(i)}{p_t(i)^2}
\left(\frac{p_{t+1}(i)}{p_t(i)}-\bar{\pi}\right)
y_{t+1}
\right]
= 0 .
\end{aligned}
$$

In a symmetric equilibrium, firms choose the same price, same inputs and same output. Using the production function it turns out:

$$
rk_t = mc_t\alpha\frac{y_t}{k_{t-1}}, \tag{13}
$$

$$
w_t = mc_t(1-\alpha)\frac{y_t}{h_t}. \tag{14}
$$

Rearrange the pricing condition:

$$
\begin{aligned}
0
&= (1-\varepsilon)\frac{y_t}{p_t}
- \frac{\kappa_P}{p_{t-1}}
\left(\frac{p_t}{p_{t-1}}-\bar{\pi}\right)y_t
+ \varepsilon mc_t\frac{y_t}{p_t} \\
&\quad
+ \beta E_t
\left[
\frac{\lambda_{t+1}}{\lambda_t}
\kappa_P
\frac{p_{t+1}}{p_t^2}
\left(\frac{p_{t+1}}{p_t}-\bar{\pi}\right)
y_{t+1}
\right], \\
0
&= (1-\varepsilon)
- \kappa_P\frac{p_t}{p_{t-1}}
\left(\frac{p_t}{p_{t-1}}-\bar{\pi}\right)
+ \varepsilon mc_t \\
&\quad
+ \beta E_t
\left[
\frac{\lambda_{t+1}}{\lambda_t}
\kappa_P
\frac{p_{t+1}}{p_t}
\left(\frac{p_{t+1}}{p_t}-\bar{\pi}\right)
\frac{y_{t+1}}{y_t}
\right], \\
\pi_t(\pi_t-\bar{\pi})
&= \beta E_t
\left[
\frac{\lambda_{t+1}}{\lambda_t}
\pi_{t+1}(\pi_{t+1}-\bar{\pi})
\frac{y_{t+1}}{y_t}
\right]
+ \frac{\varepsilon}{\kappa_P}
\left(mc_t-\frac{\varepsilon-1}{\varepsilon}\right),
\end{aligned}
\tag{15}
$$

which is the non-linear Phillips curve. Using (13) and (14) one can derive real profits for
intermediate firms in a symmetric equilibrium:

$$
\begin{aligned}
\Gamma_t^I
&= \frac{p_t(i)}{p_t}y_t(i)
- w_t h_t
- rk_t k_{t-1}
- \frac{\kappa_P}{2}
\left(\frac{p_t(i)}{p_{t-1}(i)}-\bar{\pi}\right)^2y_t \\
&= y_t - w_t h_t - rk_t k_{t-1}
- \frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2y_t \\
&= y_t - mc_t(1-\alpha)y_t - mc_t\alpha y_t
- \frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2y_t \\
&= y_t
\left[
1 - mc_t - \frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2
\right].
\end{aligned}
$$

## 1.4 Policy

The government finances public expenditure $g_t$ by raising lump-sum taxes:

$$
g_t = t_t,
$$

where $g_t$ follows an autoregressive process:

$$
\log(g_t) = (1-\rho_g)\log(g) + \rho_g\log(g_{t-1}) + v_t^g, \tag{16}
$$

and $v_t^g \sim N(0,\sigma_g^2)$ is a public spending shock. Moreover, the monetary authority sets the nominal interest rate according to the following Taylor rule:

$$
\frac{r_t}{r}
= \left(\frac{r_{t-1}}{r}\right)^{\rho_r}
\left[
\left(\frac{\pi_t}{\bar{\pi}}\right)^{\phi_\pi}
\times
\left(\frac{y_t}{y}\right)^{\phi_y}
\right]^{1-\rho_r}
\exp(v_t^m), \tag{17}
$$

where $v_t^m \sim N(0,\sigma_m^2)$ is a monetary policy shock.

## 1.5 Market Clearing

Clearing in the good market implies:

$$
y_t = c_t + i_t + g_t + \frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2y_t. \tag{18}
$$

Clearing in the bond market implies:

$$
b_t = 0.
$$

By Walras Law, if $n-1$ markets are in equilibrium, the $n$th market is in equilibrium too. Hence,
if we impose equilibrium in every market of the economy (i.e. bond and good), one equation is
redundant. We can check if this is true by rearranging the budget constraint with the equations
derived above and the expression for total real profits $\Gamma_t = \Gamma_t^F+\Gamma_t^I$:

$$
\begin{aligned}
c_t+i_t+\frac{b_t}{p_t}
&= rk_tk_{t-1}+r_{t-1}\frac{b_{t-1}}{p_t}
+w_th_t-t_t+\Gamma_t, \\
c_t+i_t
&= mc_t(1-\alpha)y_t+mc_t\alpha y_t-g_t+\Gamma_t^F+\Gamma_t^I, \\
c_t+i_t
&= mc_t(1-\alpha)y_t+mc_t\alpha y_t-g_t
+y_t\left[
1-mc_t-\frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2
\right], \\
c_t+i_t+g_t+\frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2y_t
&= y_t,
\end{aligned}
$$

which is the good market clearing condition.

## 2 Equilibrium

The equilibrium conditions of the model are the following:

$$
\begin{aligned}
\lambda_t &= c_t^{-\sigma}, \\
1 &= \beta E_t\left(\frac{\lambda_{t+1}}{\lambda_t}\frac{r_t}{\pi_{t+1}}\right), \\
1 &= \beta E_t\left\{
\frac{\lambda_{t+1}}{\lambda_t}
\frac{rk_{t+1}+(1-\delta)q_{t+1}}{q_t}
\right\}, \\
\kappa_L h_t^\phi &= \lambda_t w_t, \\
k_t &= (1-\delta)k_{t-1}
+\left[
1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2
\right]i_t, \\
1 &= q_t
\left[
1-\frac{\kappa_I}{2}\left(\frac{i_t}{i_{t-1}}-1\right)^2
-\kappa_I\left(\frac{i_t}{i_{t-1}}\right)
\left(\frac{i_t}{i_{t-1}}-1\right)
\right] \\
&\quad
+\kappa_I\beta E_t
\left\{
q_{t+1}\frac{\lambda_{t+1}}{\lambda_t}
\left[
\left(\frac{i_{t+1}}{i_t}\right)^2
\left(\frac{i_{t+1}}{i_t}-1\right)
\right]
\right\}, \\
rr_t &= \frac{r_t}{E_t[\pi_{t+1}]}, \\
y_t &= a_t k_{t-1}^{\alpha}h_t^{1-\alpha}, \\
(1-\alpha)mc_t y_t &= w_t h_t, \\
\alpha mc_t y_t &= rk_t k_{t-1}, \\
\pi_t(\pi_t-\bar{\pi})
&= \beta E_t
\left[
\frac{\lambda_{t+1}}{\lambda_t}
\pi_{t+1}(\pi_{t+1}-\bar{\pi})\frac{y_{t+1}}{y_t}
\right]
+\frac{\varepsilon}{\kappa_P}
\left(mc_t-\frac{\varepsilon-1}{\varepsilon}\right), \\
y_t &= c_t+i_t+g_t+\frac{\kappa_P}{2}(\pi_t-\bar{\pi})^2y_t, \\
\frac{r_t}{r}
&= \left(\frac{r_{t-1}}{r}\right)^{\rho_r}
\left[
\left(\frac{\pi_t}{\bar{\pi}}\right)^{\phi_\pi}
\times
\left(\frac{y_t}{y}\right)^{\phi_y}
\right]^{1-\rho_r}\exp(v_t^m), \\
\log(a_t) &= (1-\rho_a)\log(a)+\rho_a\log(a_{t-1})+v_t^a, \\
\log(g_t) &= (1-\rho_g)\log(g)+\rho_g\log(g_{t-1})+v_t^g .
\end{aligned}
$$

There are 15 equations for 15 endogenous variables:

$$
X_t \equiv
\left[
\lambda_t,c_t,rr_t,rk_t,w_t,h_t,y_t,k_t,q_t,i_t,r_t,mc_t,\pi_t,g_t,a_t
\right].
$$

The model features 3 exogenous shocks: $v_t \equiv [v_t^a,v_t^g,v_t^m]$. Compared to the RBC model
described in the lecture notes, there are 3 additional equations: the definition of the real interest
rate (6), the Phillips curve (15) and the Taylor rule (17). The 3 additional variables are $r_t$,
$mc_t$ and $\pi_t$. Notice that the price level $p_t$ (together with the definition of inflation
$\pi_t \equiv p_t/p_{t-1}$) is not included in the set of equilibrium conditions because it would introduce a unit root in the model.

## Parameter Calibration

The Dynare implementation loads the parameters saved by `console.m`. The structural quarterly calibration is:

| Parameter | Value | Description |
| --- | ---: | --- |
| $\beta$ | 0.99 | Discount factor |
| $\alpha$ | 0.33 | Elasticity of production with respect to capital |
| $\varepsilon$ | 6 | Elasticity of substitution between differentiated goods |
| $\delta$ | 0.025 | Depreciation rate |
| $\sigma$ | 2 | Relative risk aversion |
| $\phi$ | 1 | Inverse Frisch elasticity |
| $g$ | 0.2 | Share of public spending in steady state |

The steady-state normalizations and values computed in `console.m` are:

| Variable or parameter | Value | Code expression |
| --- | ---: | --- |
| $\pi$ | 1 | `pi=1` |
| $y$ | 1 | `y=1` |
| $h$ | $1/3$ | `h=1/3` |
| $rr$ | 1.010101 | `rr=1/beta` |
| $r$ | 1.010101 | `r=pi/beta` |
| $q$ | 1 | `q=1` |
| $rk$ | 0.035101 | `rk=1/beta-(1-delta)` |
| $mc$ | 0.833333 | `mc=(epsilon-1)/epsilon` |
| $k$ | 7.834532 | `k=alpha*mc*y/rk` |
| $w$ | 1.675000 | `w=(1-alpha)*mc*y/h` |
| $i$ | 0.195863 | `i=delta*k` |
| $c$ | 0.604137 | `c=y-i-g` |
| $\lambda$ | 2.739868 | `lambda=c^(-sigma)` |
| $a$ | 1.058393 | `a=y/(k^alpha h^(1-alpha))` |
| $\kappa_L$ | 13.767835 | `kappaL=w/(h^phi c^sigma)` |

The saved steady-state parameter aliases are $g_{ss}=g$, $a_{ss}=a$, $\pi_{ss}=\pi$, and $r_{ss}=r$. Parameters that do not affect the deterministic steady state are calibrated as:

| Parameter | Value | Description |
| --- | ---: | --- |
| $\phi_\pi$ | 1.5 | Monetary policy response to inflation |
| $\phi_y$ | 0.125 | Monetary policy response to output |
| $\kappa_I$ | 2.48 | Investment adjustment cost |
| $\rho_a$ | 0.9 | TFP persistence |
| $\rho_g$ | 0.9 | Public spending persistence |
| $\rho_m$ | 0.8 | Monetary policy inertia |
| Calvo parameter | 0.66 | Price rigidity in the Calvo framework |
| $\kappa_P$ | 28.003123 | Rotemberg adjustment cost implied by the Calvo parameter |

## 3 Steady State

Variables without time index denote the steady state level. Equation (12) and (16) in steady
state imply:

$$
a = a,\qquad g = g.
$$

Parameter $a$ just affects the scale of the economy: I will calibrate it in order to normalize $y=1$.
Moreover, I set $h=1/3$ and I will compute $\kappa_L$ ex post. In steady state (17) implies:

$$
\pi = \bar{\pi}.
$$

So by (3) one can find the steady-state nominal rate:

$$
r = \frac{\pi}{\beta},
$$

and by using (6) the real rate reads:

$$
rr = \frac{1}{\beta}.
$$

In steady state (5) implies:

$$
q = 1,
$$

which gives according to (4):

$$
rk = \frac{1}{\beta}-(1-\delta).
$$

By (15), in the steady state marginal costs are the following:

$$
mc = \frac{\varepsilon-1}{\varepsilon}.
$$

Once we have $rk$ and $mc$, we can get the steady state of $k$ by (13):

$$
k = \frac{\alpha y}{rk}\frac{\varepsilon-1}{\varepsilon},
$$

and in turn we get $i$ from the law of motion of capital:

$$
i = \delta k.
$$

Using (14) we can find $w$:

$$
w = \frac{(1-\alpha)y}{h}\frac{\varepsilon-1}{\varepsilon}.
$$

Using (18), the steady-state level of consumption is:

$$
c = y-i-g.
$$

Marginal utility of consumption:

$$
\lambda = c^{-\sigma}.
$$

Using (2) one can recover the value for $\kappa_L$:

$$
\kappa_L = \frac{w}{c^\sigma h^\phi}.
$$

Finally, using (11), we can get the value for the calibration of $a$ consistent with $y=1$:

$$
a = \frac{y}{k^\alpha h^{1-\alpha}}.
$$

Notice that adjustment costs are zero in the steady state, hence in the steady state the unique distortion is the presence of monopolistic competition. Eliminating monopolistic competition, I could get:

$$
\varepsilon\to\infty,\qquad mc_t\to 1,
$$

and I could obtain the same steady state of the RBC model.[^steady-state-note]

## Bibliography

- Ascari, G. and Rossi, L. (2012). Trend Inflation and Firms Price-Setting: Rotemberg Versus Calvo. *The Economic Journal*, 122(563):1115-1141.
- Calvo, G. A. (1983). Staggered Prices in a Utility-Maximizing Framework. *Journal of Monetary Economics*, 12(3):383-398.
- Christiano, L. J., Eichenbaum, M., and Evans, C. L. (2005). Nominal Rigidities and the Dynamic Effects of a Shock to Monetary Policy. *Journal of Political Economy*, 113(1):1-45.
- Gali, J. (2015). *Monetary Policy, Inflation, and the Business Cycle: an Introduction to the New Keynesian Framework and its Applications*.
- Rotemberg, J. J. (1982). Monopolistic Price Adjustment and Aggregate Output. *The Review of Economic Studies*, 49(4):517-531.
- Smets, F. and Wouters, R. (2003). An Estimated Dynamic Stochastic General Equilibrium Model of the Euro Area. *Journal of the European Economic Association*, 1(5):1123-1175.
- Woodford, M. (2003). *Interest and Prices: Foundations of a Theory of Monetary Policy*. Princeton University Press.

[^author]: Bank of Italy, International Relations and Economics Directorate. Email: valerio.nispilandi@bancaditalia.it

[^model-note]: In these lecture notes I derive the equations used to simulate the model in the Dynare file `nk.mod` and I explain how to compute the steady state. The notes are preliminary, if you find any error or inaccuracies, feel free to contact me. The views expressed in these notes are those of the author and do not necessarily reflect those of the Bank of Italy.

[^simplified-model]: This model is a simplified version of Smets and Wouters (2003) and Christiano et al. (2005). In particular, compared to Smets and Wouters (2003), this model does not feature habits in consumption, wage rigidity, and capital utilization. For a textbook treatment, the interested reader can refer to Woodford (2003) and Gali (2015).

[^final-good-note]: One can also assume that there is only a final-good sector, characterized by monopolistic competition and price rigidity. In this case, the choice between differentiated goods is up to households, as in Gali (2015).

[^rotemberg-note]: The pricing framework a la Calvo (1983) is another way to introduce a nominal rigidity, whereby only a fraction of firms are allowed to reset the price in every period. The Calvo framework is often found in the optimal monetary policy literature. In these lecture notes I prefer to use the Rotemberg framework, which is easier to implement in Dynare. Under some conditions, up to a linear approximation the two frameworks yield identical expressions. For a thorough analysis of the differences between the Calvo and the Rotemberg framework, the reader can refer to Ascari and Rossi (2012).

[^steady-state-note]: In general, the presence of monopolistic competition generates an inefficient low level of output in the steady state of the New Keynesian model. In these lecture notes and in the lecture notes on the RBC model, I normalize ex ante the steady-state level output to be equal to one. It turns out the parameter $a$ in the NK model of this lecture notes is lower than its counterpart in the lecture notes on the RBC model.
