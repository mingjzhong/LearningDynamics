function visualize_traj_1D_wnoise(traj_fig, traj_noise, traj_true, traj_hat, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_1D_wnoise(traj_fig, traj_noise, traj_true, traj_hat, time_vec, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

if sys_info.d ~= 1, error('SOD_Utils:visualize_traj_1D:exception', 'This routine is for 1D Visualization!!'); end
% prepare the trajectories
trajs{1} = traj_true; trajs{2} = traj_hat; trajs{3} = traj_noise;
% prepare the y range
y_min              = zeros(1, length(trajs));
y_max              = zeros(1, length(trajs));
for ind = 1 : length(trajs)
  traj             = trajs{ind};
  y_min(ind)       = min(min(traj));
  y_max(ind)       = max(max(traj));
end
y_min              = min(y_min);
y_max              = max(y_max);
handleAxes         = gobjects(1);
l_handles          = gobjects(1, 3);
y_range            = y_max - y_min;
y_min              = y_min - 0.1 * y_range;
y_max              = y_max + 0.1 * y_range;
vline_y            = linspace(y_min, y_max, obs_info.L);
vline_x            = obs_info.T_L * ones(size(vline_y));
x_min              = min(time_vec);
x_max              = max(time_vec);
T_loc              = find(time_vec == obs_info.T_L);
plot_info.c_len    = length(time_vec) - T_loc;
sp_handle          = subplot(1, 1, 1);
for ind = 1 : 3
  plot_one_traj_1D(sp_handle, trajs{ind}, time_vec, sys_info, ind, plot_info);
  plot(vline_x, vline_y, '-.k');
  l_handles(ind)   = plot(NaN, NaN, ['k' plot_info.line_styles{1}]);                    % dummy lines for legend
  axis([x_min, x_max, y_min, y_max]);
end
hold off;
sp_handle.FontSize = plot_info.tick_font_size;
sp_handle.FontName = plot_info.tick_font_name;     
xlabel('Time $t$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
ylabel('Coord. $1$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
leg_handle         = legend(l_handles, {'$\mathbf{x}_i(t)$', '$\hat\mathbf{x}_i(t)$', '$\mathbf{x}_i^\epsilon(t)$'});
set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
handleAxes(1)      = sp_handle;
tightFigaroundAxes(handleAxes);
saveas(traj_fig, [plot_info.plot_name '_traj_noise'], 'fig');
end