function export_results(oo_, M_, vars, output_file)
% EXPORT_RESULTS  Export steady state and moments to CSV.
%
%   export_results(oo_, M_, vars, output_file)
%
%   Inputs:
%     oo_         - Dynare results structure
%     M_          - Dynare model structure
%     vars        - cell array of variable names to export
%     output_file - output path, e.g. 'results/model_output.csv'

endo_names = cellstr(M_.endo_names);
n = length(vars);

varnames_col = cell(n, 1);
ss_col       = zeros(n, 1);
std_col      = zeros(n, 1);
ac1_col      = zeros(n, 1);

for i = 1:n
    idx = find(strcmp(endo_names, vars{i}));
    varnames_col{i} = vars{i};
    if isempty(idx)
        ss_col(i) = NaN; std_col(i) = NaN; ac1_col(i) = NaN;
    else
        ss_col(i) = oo_.steady_state(idx);
        if isfield(oo_, 'var') && ~isempty(oo_.var)
            std_col(i) = sqrt(oo_.var(idx,idx));
        else
            std_col(i) = NaN;
        end
        if isfield(oo_, 'autocorr') && ~isempty(oo_.autocorr)
            ac1_col(i) = oo_.autocorr{1}(idx,idx);
        else
            ac1_col(i) = NaN;
        end
    end
end

T = table(varnames_col, ss_col, std_col, ac1_col, ...
    'VariableNames', {'Variable','SteadyState','StdDev','AutoCorr1'});

[out_dir, ~, ~] = fileparts(output_file);
if ~isempty(out_dir) && ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

writetable(T, output_file);
fprintf('Results exported to: %s\n', output_file);
end
