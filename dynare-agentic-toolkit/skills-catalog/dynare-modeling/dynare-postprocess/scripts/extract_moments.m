function mom_table = extract_moments(oo_, M_, vars)
% EXTRACT_MOMENTS  Second moments for selected variables.
%
%   mom_table = extract_moments(oo_, M_, vars)
%
%   Output:
%     mom_table - table: Variable, StdDev, RelToY, AutoCorr1

endo_names = cellstr(M_.endo_names);

if ~isfield(oo_, 'var') || isempty(oo_.var)
    error('extract_moments: oo_.var not found. Run stoch_simul without nocorr.');
end

idx_Y = find(strcmp(endo_names, 'Y'));
if isempty(idx_Y)
    std_Y = NaN;
else
    std_Y = sqrt(oo_.var(idx_Y, idx_Y));
end

varnames = cell(length(vars), 1);
stddevs  = zeros(length(vars), 1);
rel_to_Y = zeros(length(vars), 1);
ac1      = zeros(length(vars), 1);

for i = 1:length(vars)
    idx = find(strcmp(endo_names, vars{i}));
    if isempty(idx)
        warning('extract_moments: variable not found: %s', vars{i});
        varnames{i} = vars{i};
        stddevs(i) = NaN; rel_to_Y(i) = NaN; ac1(i) = NaN;
    else
        varnames{i} = vars{i};
        stddevs(i)  = sqrt(oo_.var(idx, idx));
        rel_to_Y(i) = stddevs(i) / std_Y;
        if isfield(oo_, 'autocorr') && ~isempty(oo_.autocorr)
            ac1(i) = oo_.autocorr{1}(idx, idx);
        else
            ac1(i) = NaN;
        end
    end
end

mom_table = table(varnames, stddevs, rel_to_Y, ac1, ...
    'VariableNames', {'Variable', 'StdDev', 'RelToY', 'AutoCorr1'});
disp(mom_table);
end
