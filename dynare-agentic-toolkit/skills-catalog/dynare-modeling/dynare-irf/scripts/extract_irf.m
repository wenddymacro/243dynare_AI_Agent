function irf_mat = extract_irf(oo_, options_, vars, shock)
% EXTRACT_IRF  Extract IRF matrix from oo_.irfs for given variables and shock.
%
%   irf_mat = extract_irf(oo_, options_, vars, shock)
%
%   Inputs:
%     oo_     - Dynare results structure
%     options_- Dynare options structure
%     vars    - cell array of variable names, e.g. {'C','Y','PI','R'}
%     shock   - shock name string, e.g. 'eps_a'
%
%   Output:
%     irf_mat - T x length(vars) matrix; rows=periods, cols=variables in vars order

T = options_.irf;
if T == 0
    error('extract_irf: stoch_simul was run with irf=0. Re-run with irf>0.');
end

irf_mat = NaN(T, length(vars));
for i = 1:length(vars)
    field = [vars{i} '_' shock];
    if isfield(oo_.irfs, field)
        irf_mat(:, i) = oo_.irfs.(field)(:);
    else
        warning('extract_irf: field not found in oo_.irfs: %s', field);
    end
end
end
