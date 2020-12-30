function visualize_traj_1D(traj1, traj2, trajhat1, trajhat2, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_1D(win_handler, traj1, traj2, trajhat1, trajhat2, time_vec, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

if sys_info.d ~= 1, error('SOD_Utils:visualize_traj_1D:exception', 'This routine is for 1D!!'); end
%
scrsz        = get(groot,'ScreenSize');
traj_fig     = figure('Name', 'Traj: True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
               [scrsz(3)*1/8 + scrsz(3) * 1/10, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
%
type_colors  = {'b', 'g', 'r', 'c', 'm', 'y', 'k'};
% split the true trajectories (1)
ind         = find(time_vec <= obs_info.T_L);
first_time  = time_vec(ind);
first_traj  = traj1(:, ind);
ind         = find(time_vec >= obs_info.T_L);
second_time = time_vec(ind);
second_traj = traj1(:, ind);
y_min       = min([min(min(traj1)) min(min(traj2)) min(min(trajhat1)) min(min(trajhat2))]) * 1.1;
y_max       = max([max(max(traj1)) max(max(traj2)) max(max(trajhat1)) max(max(trajhat2))]) * 1.1;
vline_y     = linspace(y_min, y_max, obs_info.L);
vline_x     = obs_info.T_L * ones(size(vline_y));
x_min       = min(time_vec);
x_max       = max(time_vec);
subplot(2, 2, 1);
for k = 1 : sys_info.K
  agents_traj = first_traj(sys_info.type_info == k, :);
  plot(first_time, agents_traj, 'LineWidth', plot_info.traj_line_width, 'color', type_colors{k});
  if k == 1, hold on; end
end
plot(vline_x, vline_y, '-.k');
for k = 1 : sys_info.K
  agents_traj = second_traj(sys_info.type_info == k, :);
  plot(second_time, agents_traj, 'LineWidth', plot_info.traj_line_width, 'color', type_colors{k});
end
axis([x_min, x_max, y_min, y_max]);
ylabel( '$\mathbf{x}_i$', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name );
% set(gca, 'XTickLabel', []);
% titleHandle = title( '$\mathbf{X}(t)$', 'FontSize', plot_info.title_font_size );
% set( titleHandle, 'Position', get(titleHandle, 'Position') - [0,0.05,0] );
% set( titleHandle, 'Interpreter', 'latex', 'FontSize', plot_info.title_font_size, 'FontWeight', 'bold' );
handleAxes(1, 1) = gca;
% split the learned trajectories (1)
ind         = find(time_vec <= obs_info.T_L);
first_time  = time_vec(ind);
first_traj  = trajhat1(:, ind);
ind         = find(time_vec >= obs_info.T_L);
second_time = time_vec(ind);
second_traj = trajhat1(:, ind);
subplot(2, 2, 2);
for k = 1 : sys_info.K
  agents_traj = first_traj(sys_info.type_info == k, :);
  plot(first_time, agents_traj, 'LineWidth', plot_info.traj_line_width, 'color', type_colors{k});
  if k == 1, hold on; end
end
plot(vline_x, vline_y, '-.k');
for k = 1 : sys_info.K
  agents_traj = second_traj(sys_info.type_info == k, :);
  plot(second_time, agents_traj, 'LineWidth', plot_info.traj_line_width, 'color', type_colors{k});
end
axis([x_min, x_max, y_min, y_max]);
ylabel( '$\hat\mathbf{x}_i$', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name );
% set(gca, 'XTickLabel', [], 'YTickLabel', []);
% titleHandle = title('$\hat\mathbf{X}(t)$', 'FontSize', plot_info.title_font_size );
% set( titleHandle, 'Position', get(titleHandle, 'Position') - [0,0.05,0] );
% set( titleHandle, 'Interpreter', 'latex', 'FontSize', plot_info.title_font_size, 'FontWeight', 'bold' );
handleAxes(1, 2) = gca;
% split the true trajectories (2)
ind         = find(time_vec <= obs_info.T_L);
first_time  = time_vec(ind);
first_traj  = traj2(:, ind);
ind         = find(time_vec >= obs_info.T_L);
second_time = time_vec(ind);
second_traj = traj2(:, ind);
subplot(2, 2, 3);
for k = 1 : sys_info.K
  agents_traj = first_traj(sys_info.type_info == k, :);
  plot(first_time, agents_traj, 'LineWidth', 1.2, 'color', type_colors{k});
  if k == 1, hold on; end
end
plot(vline_x, vline_y, '-.k');
for k = 1 : sys_info.K
  agents_traj = second_traj(sys_info.type_info == k, :);
  plot(second_time, agents_traj, 'LineWidth', 1.2, 'color', type_colors{k});
end
axis([x_min, x_max, y_min, y_max]);
xlabel( '$t$, time',      'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name );
ylabel( '$\mathbf{x}_i$', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name );
handleAxes(2, 1) = gca;
% split the learned trajectories (1)
ind         = find(time_vec <= obs_info.T_L);
first_time  = time_vec(ind);
first_traj  = trajhat2(:, ind);
ind         = find(time_vec >= obs_info.T_L);
second_time = time_vec(ind);
second_traj = trajhat2(:, ind);
subplot(2, 2, 4);
for k = 1 : sys_info.K
  agents_traj = first_traj(sys_info.type_info == k, :);
  plot(first_time, agents_traj, 'LineWidth', 1.2, 'color', type_colors{k});
  if k == 1, hold on; end
end
plot(vline_x, vline_y, '-.k');
for k = 1 : sys_info.K
  agents_traj = second_traj(sys_info.type_info == k, :);
  plot(second_time, agents_traj, 'LineWidth', 1.2, 'color', type_colors{k});
end
axis([x_min, x_max, y_min, y_max]);
xlabel( '$t$, time',          'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name );
ylabel( '$\hat\mathbf{x}_i$', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name );
% set(gca, 'YTickLabel', []);
handleAxes(2, 2) = gca;
tightFigaroundAxes(handleAxes);
saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig'); 
end