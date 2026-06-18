function [ys, params, check] = MODEL_steadystate(ys, exo, M_, options_)
% MODEL_steadystate  Dynare steady-state solver for MODEL.
% Replace MODEL with the actual model name (must match .mod filename).
%
% Signature required by Dynare — do not change argument names or order.

check = 0;  % 0 = success; set to 1 if solver fails

%% Extract parameters from M_.params
for i = 1:length(M_.param_names)
    eval([strtrim(M_.param_names(i,:)) ' = M_.params(i);']);
end

%% Solve steady state
% TODO: replace with actual steady-state equations
% Option A: analytical (sequential computation)
%   var1 = expression1;
%   var2 = expression_using_var1;

% Option B: numerical (fsolve) — see steadystate_fsolve.m template

%% Assign results to ys (indexed by M_.endo_names order)
endo_names = cellstr(M_.endo_names);

% Example assignments — replace with actual variables:
% ys(strcmp(endo_names, 'C'))  = C_ss;
% ys(strcmp(endo_names, 'Y'))  = Y_ss;
% ys(strcmp(endo_names, 'N'))  = N_ss;
% ys(strcmp(endo_names, 'A'))  = 1;
% ys(strcmp(endo_names, 'PI')) = PIss;
% ys(strcmp(endo_names, 'R'))  = PIss / beta;

params = M_.params;
end
