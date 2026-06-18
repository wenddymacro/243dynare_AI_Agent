function [ys, params, check] = nk_steadystate(ys, exo, M_, options_)
% nk_steadystate  Closed-form steady-state for a standard NK model.
%
% Variables: C, Y, N, PI, R, A, MC
% Steady state at zero inflation: PI=PIss, R=PIss/beta, A=1

check = 0;

%% Extract parameters
for i = 1:length(M_.param_names)
    eval([strtrim(M_.param_names(i,:)) ' = M_.params(i);']);
end
% Expected: beta, alpha, sigma, phi, PIss, epsilon

%% Closed-form solutions (sequential)
A_ss  = 1;
PI_ss = PIss;
R_ss  = PIss / beta;
MC_ss = (epsilon - 1) / epsilon;
N_ss  = ((1-alpha) * MC_ss / phi)^(1/(sigma + alpha));
Y_ss  = A_ss * N_ss^(1-alpha);
C_ss  = Y_ss;

%% Assign to ys
endo_names = cellstr(M_.endo_names);
ys(strcmp(endo_names, 'C'))  = C_ss;
ys(strcmp(endo_names, 'Y'))  = Y_ss;
ys(strcmp(endo_names, 'N'))  = N_ss;
ys(strcmp(endo_names, 'PI')) = PI_ss;
ys(strcmp(endo_names, 'R'))  = R_ss;
ys(strcmp(endo_names, 'A'))  = A_ss;
ys(strcmp(endo_names, 'MC')) = MC_ss;

params = M_.params;
end
