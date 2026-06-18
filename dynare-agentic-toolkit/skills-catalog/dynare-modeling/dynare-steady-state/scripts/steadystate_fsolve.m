function [ys, params, check] = rbc_steadystate(ys, exo, M_, options_)
% rbc_steadystate  fsolve-based steady-state solver for a standard RBC model.
%
% Variables: C, Y, N, K, I, W, R_real, A
% This file is a template — rename and adapt for your model.

check = 0;

%% Extract parameters
for i = 1:length(M_.param_names)
    eval([strtrim(M_.param_names(i,:)) ' = M_.params(i);']);
end
% Expected params: beta, alpha, sigma, phi, delta

%% Analytical steady state (where possible)
A_ss  = 1;
R_ss  = 1/beta;
KN_ss = (alpha / (R_ss - 1 + delta))^(1/(1-alpha));

%% Solve (N_ss, C_ss) numerically
p.alpha = alpha; p.sigma = sigma; p.phi = phi; p.delta = delta;
p.KN_ss = KN_ss;

x0 = [0.33; 0.5];
opts = optimset('Display','off','TolFun',1e-12,'TolX',1e-12);
[x, ~, exitflag] = fsolve(@(x) ss_res(x, p), x0, opts);

if exitflag <= 0
    check = 1;
    return;
end

N_ss = x(1);
C_ss = x(2);
K_ss = KN_ss * N_ss;
Y_ss = A_ss * K_ss^alpha * N_ss^(1-alpha);
I_ss = delta * K_ss;
W_ss = (1-alpha) * Y_ss / N_ss;

%% Assign to ys
endo_names = cellstr(M_.endo_names);
ys(strcmp(endo_names, 'C'))      = C_ss;
ys(strcmp(endo_names, 'Y'))      = Y_ss;
ys(strcmp(endo_names, 'N'))      = N_ss;
ys(strcmp(endo_names, 'K'))      = K_ss;
ys(strcmp(endo_names, 'I'))      = I_ss;
ys(strcmp(endo_names, 'W'))      = W_ss;
ys(strcmp(endo_names, 'R_real')) = R_ss;
ys(strcmp(endo_names, 'A'))      = A_ss;

params = M_.params;
end

function res = ss_res(x, p)
N = x(1); C = x(2);
K = p.KN_ss * N;
Y = K^p.alpha * N^(1-p.alpha);
res(1) = Y - C - p.delta * K;
res(2) = p.phi * N^p.sigma - (1-p.alpha)*Y/N / C^p.sigma;
end
