function compare_irf(irf_mat1, irf_mat2, vars, shock, legend_labels, var_labels)
% COMPARE_IRF  Overlay IRFs from two model runs in a subplot panel.
%
%   compare_irf(irf_mat1, irf_mat2, vars, shock, legend_labels, var_labels)
%
%   Inputs:
%     irf_mat1      - T x N IRF matrix from model 1 (extract_irf output)
%     irf_mat2      - T x N IRF matrix from model 2
%     vars          - cell array of variable names
%     shock         - shock name string
%     legend_labels - 2-element cell array, e.g. {'Baseline','Alternative'}
%     var_labels    - (optional) display labels; defaults to vars

if nargin < 6 || isempty(var_labels)
    var_labels = vars;
end

T = size(irf_mat1, 1);
N = size(irf_mat1, 2);
ncols = min(3, N);
nrows = ceil(N / ncols);

figure('Name', ['IRF Comparison: ' shock], 'NumberTitle', 'off');
sgtitle(['Impulse Response Comparison: ' shock ' Shock'], 'FontSize', 13);

for i = 1:N
    subplot(nrows, ncols, i);
    plot(1:T, irf_mat1(:,i), 'b-',  'LineWidth', 1.5); hold on;
    plot(1:T, irf_mat2(:,i), 'r--', 'LineWidth', 1.5);
    plot(1:T, zeros(T,1),    'k:',  'LineWidth', 0.5);
    hold off;
    xlabel('Periods');
    ylabel('Deviation from ss');
    title(var_labels{i});
    if i == 1
        legend(legend_labels{1}, legend_labels{2}, 'Location', 'best');
    end
    grid on;
    set(gca, 'FontSize', 10);
end
end
