function plot_irf_panel(irf_mat, vars, shock, var_labels)
% PLOT_IRF_PANEL  Subplot panel of IRFs for multiple variables.
%
%   plot_irf_panel(irf_mat, vars, shock, var_labels)
%
%   Inputs:
%     irf_mat    - T x N matrix from extract_irf
%     vars       - cell array of variable names
%     shock      - shock name string (used in figure title)
%     var_labels - (optional) display labels; defaults to vars

if nargin < 4 || isempty(var_labels)
    var_labels = vars;
end

T = size(irf_mat, 1);
N = size(irf_mat, 2);
ncols = min(3, N);
nrows = ceil(N / ncols);

figure('Name', ['IRF to ' shock], 'NumberTitle', 'off');
sgtitle(['Impulse Responses to ' shock ' Shock'], 'FontSize', 13);

for i = 1:N
    subplot(nrows, ncols, i);
    plot(1:T, irf_mat(:,i), 'b-', 'LineWidth', 1.5);
    hold on;
    plot(1:T, zeros(T,1), 'k--', 'LineWidth', 0.5);
    hold off;
    xlabel('Periods');
    ylabel('Deviation from ss');
    title(var_labels{i});
    grid on;
    set(gca, 'FontSize', 10);
end
end
