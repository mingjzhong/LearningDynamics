function plot_one_line_1D(fig_handle, plot_handle, traj, time_vec, time_ind, sys_info, plot_info)
% function plot_one_line_1D(fig_handle, plot_handle, traj, time_vec, time_ind, sys_info, plot_info)

% (C) M. Zhong

set(fig_handle, 'CurrentAxes', plot_handle);
for agent = 1 : sys_info.N
  ph       = plot(time_vec(1 : time_ind), traj(agent, 1 : time_ind), '-', 'LineWidth', ...
             plot_info.traj_line_width );
  ph.Color = [128/256, 128/256, 128/256, 0.1];
end
end