function vd_table = extract_variance_decomp(oo_, M_, vars)
% EXTRACT_VARIANCE_DECOMP  Variance decomposition by shock for selected variables.
%
%   vd_table = extract_variance_decomp(oo_, M_, vars)
%
%   Output:
%     vd_table - table with variable names as rows and shock names as columns

if ~isfield(oo_, 'variance_decomposition') || isempty(oo_.variance_decomposition)
    error('extract_variance_decomp: oo_.variance_decomposition not found.');
end

endo_names = cellstr(M_.endo_names);
exo_names  = strtrim(cellstr(M_.exo_names));

varnames = cell(length(vars), 1);
vd_mat   = zeros(length(vars), length(exo_names));

for i = 1:length(vars)
    idx = find(strcmp(endo_names, vars{i}));
    if isempty(idx)
        warning('extract_variance_decomp: variable not found: %s', vars{i});
        varnames{i} = vars{i};
        vd_mat(i,:) = NaN;
    else
        varnames{i} = vars{i};
        vd_mat(i,:) = oo_.variance_decomposition(idx, :);
    end
end

vd_table = array2table(vd_mat, 'RowNames', varnames, 'VariableNames', exo_names);
disp(vd_table);
end
