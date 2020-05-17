function plot_one_line_multiD(fig_handle, plot_handle, X_coords, time_ind, sys_info, plot_info)
% function plot_one_line_multiD(fig_handle, plot_handle, X_coords, time_ind, sys_info, plot_info)

% (C) M. Zhong

set(fig_handle, 'CurrentAxes', plot_handle);
if sys_info.d == 2
  for agent = 1 : sys_info.N
    ph          = plot(X_coords{1}(agent, 1 : time_ind), X_coords{2}(agent, 1 : time_ind), '-', ...
                  'LineWidth', plot_info.traj_line_width );
    ph.Color    = [128/256, 128/256, 128/256, 0.1];
  end
else
  for agent = 1 : sys_info.N
    ph          = plot3(X_coords{1}(agent, 1 : time_ind), X_coords{2}(agent, 1 : time_ind), ...
                  X_coords{3}(agent, 1 : time_ind), '-', 'LineWidth', plot_info.traj_line_width );
    ph.Color    = [128/256, 128/256, 128/256, 0.1];
  end
end
end