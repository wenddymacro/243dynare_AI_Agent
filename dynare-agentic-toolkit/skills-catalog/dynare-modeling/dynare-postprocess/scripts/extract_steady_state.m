function ss_table = extract_steady_state(oo_, M_, vars)
% EXTRACT_STEADY_STATE  Extract named steady-state values into a table.
%
%   ss_table = extract_steady_state(oo_, M_, vars)
%
%   Inputs:
%     oo_   - Dynare results structure
%     M_    - Dynare model structure
%     vars  - cell array of variable names; if empty, returns all variables
%
%   Output:
%     ss_table - table with columns: Variable, SteadyState

endo_names = cellstr(M_.endo_names);

if isempty(vars)
    vars = strtrim(endo_names);
end

varnames = cell(length(vars), 1);
ssvals   = zeros(length(vars), 1);

for i = 1:length(vars)
    idx = find(strcmp(endo_names, vars{i}));
    if isempty(idx)
        warning('extract_steady_state: variable not found: %s', vars{i});
        varnames{i} = vars{i};
        ssvals(i)   = NaN;
    else
        varnames{i} = vars{i};
        ssvals(i)   = oo_.steady_state(idx);
    end
end

ss_table = table(varnames, ssvals, 'VariableNames', {'Variable', 'SteadyState'});
disp(ss_table);
end
