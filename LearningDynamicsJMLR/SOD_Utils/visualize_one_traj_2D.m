function visualize_one_traj_2D(traj, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_2D(trajs, time_vec, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

% routine check
if sys_info.d ~= 2, error('SOD_Utils:visualize_traj_2D:exception', 'This routine is for 2D Visualization!!'); end
% prepare the window
scrsz                            = get(groot,'ScreenSize');
if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N
  traj_fig                       = figure('Name', 'Traj: True Vs. Learned, Larger N', 'NumberTitle', 'off', 'Position', ...
  [scrsz(3)*1/8 + scrsz(3) * 1/8, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
else
  traj_fig                       = figure('Name', 'Traj: True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
  [scrsz(3)*1/8 + scrsz(3) * 5/48, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
end
color_output                     = construct_color_items(sys_info.K, obs_info.T_L, time_vec);
cmap                             = color_output.cmap;
c_vecs                           = color_output.c_vecs;
clabels                          = color_output.clabels;
cticks                           = color_output.cticks;
% split the trajectories
X_c1                             = traj(1 : 2 : end - 1, :);
X_c2                             = traj(2 : 2 : end,     :);
x_min                            = min(min(X_c1));
x_max                            = max(max(X_c1));
y_min                            = min(min(X_c2));
y_max                            = max(max(X_c2));
T_loc                            = find(time_vec == obs_info.T_L);
handleAxes                       = gobjects(1);
for k = 1 : sys_info.K
  agents_Ck                  = find(sys_info.type_info == k);
  N_k                        = length(agents_Ck);
  for agent_ind = 1 : N_k
    agent                    = agents_Ck(agent_ind);
    c1_at_t                  = X_c1(agent, :);
    c2_at_t                  = X_c2(agent, :);
    p_handle                 = patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vecs{k}, NaN], 'EdgeColor', ...
    'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
    if strcmp(sys_info.name, 'PredatorPrey1stOrder') || strcmp(sys_info.name, 'PredatorPrey2ndOrder')
      if k == 1, set(p_handle, 'EdgeAlpha', 0.25); end
    end
    if k == 1 && agent_ind == 1, hold on; end
  end
end
plot(X_c1(:, T_loc), X_c2(:, T_loc), 'o', 'MarkerSize', plot_info.T_L_marker_size, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
hold off;
xticks                       = get(gca, 'XTick');
delta                        = xticks(3) - xticks(2);
axis([x_min x_max + delta y_min y_max]);
colormap(cmap);
h                            = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'East');
set(h, 'FontSize', plot_info.colorbar_font_size);
ylabel_name                  = 'Coord. $2$ of $\mathbf{x}_i(t)$';
ylabel(ylabel_name, 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
xlabel_name                  = 'Coord. $1$ of $\mathbf{x}_i(t)$';
xlabel(xlabel_name, 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
handleAxes(1)                = gca;
tightFigaroundAxes(handleAxes);
if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N
  saveas(traj_fig, [plot_info.plot_name '_traj_LN'], 'fig');
else
  saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig');
end

return