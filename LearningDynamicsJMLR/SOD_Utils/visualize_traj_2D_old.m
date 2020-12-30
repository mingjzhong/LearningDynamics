function visualize_traj_2D_old(traj1, traj2, trajhat1, trajhat2, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_2D(win_handler, traj1, traj2, trajhat1, trajhat2, time_vec, sys_info, obs_info, type_colors, plot_info)

% (c) M. Zhong (JHU)

if sys_info.d ~= 2, error('SOD_Utils:visualize_traj_1D:exception', 'This routine is for 2D!!'); end
%
scrsz           = get(groot,'ScreenSize');
traj_fig        = figure('Name', 'Traj: True Vs. Learned', 'NumberTitle', 'off', 'Position', [scrsz(3)*1/8 + scrsz(3) * 1/10, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
% set up two colormap for preys and predators
map1            = colormap('winter');                                                                    
map2            = colormap('autumn');
if sys_info.K == 1
  cmap          = map1;
elseif sys_info.K == 2
  cmap          = [map1; map2];
end
c_vec_1         = time_vec;
c_shift         = time_vec(end) + 0.2;
c_vec_2         = time_vec + c_shift;
% split the trajectories
X1_c1           = traj1(1 : 2 : 2 * sys_info.N - 1, :);
X1_c2           = traj1(2 : 2 : 2 * sys_info.N,     :);
X2_c1           = trajhat1(1 : 2 : 2 * sys_info.N - 1, :);
X2_c2           = trajhat1(2 : 2 : 2 * sys_info.N,     :);
X3_c1           = traj2(1 : 2 : 2 * sys_info.N - 1, :);
X3_c2           = traj2(2 : 2 : 2 * sys_info.N,     :);
X4_c1           = trajhat2(1 : 2 : 2 * sys_info.N - 1, :);
X4_c2           = trajhat2(2 : 2 : 2 * sys_info.N,     :);
x_min           = min([min(min(X1_c1)) min(min(X2_c1)) min(min(X3_c1)) min(min(X4_c1))]) * 1.1;
x_max           = max([max(max(X1_c1)) max(max(X2_c1)) max(max(X3_c1)) max(max(X4_c1))]) * 1.1;
y_min           = min([min(min(X1_c2)) min(min(X2_c2)) min(min(X3_c2)) min(min(X4_c2))]) * 1.1;
y_max           = max([max(max(X1_c2)) max(max(X2_c2)) max(max(X3_c2)) max(max(X4_c2))]) * 1.1;
T_loc           = find(time_vec == obs_info.T_L);
subplot(2, 2, 1);
for k = 1 : sys_info.K
  agents_Ck     = find(sys_info.type_info == k);
  num_agents_Ck = length(agents_Ck);
  for ind = 1 : num_agents_Ck
    agent_ind   = agents_Ck(ind);
    c1_at_t     = X1_c1(agent_ind, :);
    c2_at_t     = X1_c2(agent_ind, :);
    switch sys_info.K
      case 1
        patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
      case 2
        if k == 1
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width, 'EdgeAlpha', 0.3);
        elseif k == 2
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_2, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
        end
      otherwise
    end
    if k == 1 && ind == 1, hold on; end
    plot(c1_at_t(:, T_loc), c2_at_t(:, T_loc), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
  end
end
hold off;
axis([x_min x_max y_min y_max]);
xticks = get(gca, 'XTick');
delta = xticks(3) - xticks(2);
colormap(cmap);
% xlabel('Coord. $1$ of $\mathbf{x}_i(t)$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex');
ylabel('Coord. $2$ of $\mathbf{x}_i(t)$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
% set(gca, 'XTickLabel', []);
handleAxes(1, 1) = gca;
% 
subplot(2, 2, 2);
for k = 1 : sys_info.K
  agents_Ck     = find(sys_info.type_info == k);
  num_agents_Ck = length(agents_Ck);
  for ind = 1 : num_agents_Ck
    agent_ind   = agents_Ck(ind);
    c1_at_t     = X2_c1(agent_ind, :);
    c2_at_t     = X2_c2(agent_ind, :);
    switch sys_info.K
      case 1
        patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);      
      case 2
        if k == 1
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width, 'EdgeAlpha', 0.3);
        elseif k == 2
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_2, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
        end
      otherwise
    end
    if k == 1 && ind == 1, hold on; end
    plot(c1_at_t(:, T_loc), c2_at_t(:, T_loc), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');     
  end
end
hold off;
axis([x_min x_max + delta y_min y_max]);
colormap(cmap);
if sys_info.K == 1
  clabels       = {'0', 'T', '2T'};
  cticks        = 0 : obs_info.T_L : 2 * obs_info.T_L;
elseif sys_info.K == 2
  clabels       = {'0', 'T', '2T', '0', 'T', '2T'};
  cticks        = [0 : obs_info.T_L : 2 * obs_info.T_L, c_shift + (0 : obs_info.T_L : 2 * obs_info.T_L)];
end
cbar            = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'East');
set(get(cbar, 'title'), 'String', 't');
ylabel('Coord. $2$ of $\hat\mathbf{x}_i(t)$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
% set(gca, 'XTickLabel', [], 'YTickLabel', []);
handleAxes(1, 2) = gca;
%
subplot(2, 2, 3);
for k = 1 : sys_info.K
  agents_Ck     = find(sys_info.type_info == k);
  num_agents_Ck = length(agents_Ck);
  for ind = 1 : num_agents_Ck
    agent_ind   = agents_Ck(ind);
    c1_at_t     = X3_c1(agent_ind, :);
    c2_at_t     = X3_c2(agent_ind, :);
    switch sys_info.K
      case 1
        patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
      case 2
        if k == 1
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width, 'EdgeAlpha', 0.3);
        elseif k == 2
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_2, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
        end        
      otherwise
    end
    if k == 1 && ind == 1, hold on; end
    plot(c1_at_t(:, T_loc), c2_at_t(:, T_loc), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');     
  end
end
hold off;
axis([x_min x_max y_min y_max]);
colormap(cmap);
xlabel('Coord. $1$ of $\mathbf{x}_i(t)$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
ylabel('Coord. $2$ of $\mathbf{x}_i(t)$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
handleAxes(2, 1) = gca;
%
subplot(2, 2, 4);
for k = 1 : sys_info.K
  agents_Ck     = find(sys_info.type_info == k);
  num_agents_Ck = length(agents_Ck);
  for ind = 1 : num_agents_Ck
    agent_ind   = agents_Ck(ind);
    c1_at_t     = X4_c1(agent_ind, :);
    c2_at_t     = X4_c2(agent_ind, :);
    switch sys_info.K
      case 1
        patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
      case 2
        if k == 1
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_1, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width, 'EdgeAlpha', 0.3);
        elseif k == 2
          patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vec_2, NaN], 'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
        end        
      otherwise
    end
    if k == 1 && ind == 1, hold on; end
    plot(c1_at_t(:, T_loc), c2_at_t(:, T_loc), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');     
  end
end
hold off;
axis([x_min x_max + delta y_min y_max]);
colormap(cmap);
cbar            = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'East');
set(get(cbar, 'title'), 'String', 't');
xlabel('Coord. $1$ of $\mathbf{x}_i(t)$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
ylabel('Coord. $2$ of $\hat\mathbf{x}_i(t)$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
% set(gca, 'YTickLabel', []);
handleAxes(2, 2) = gca;
tightFigaroundAxes(handleAxes);
saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig'); 
end