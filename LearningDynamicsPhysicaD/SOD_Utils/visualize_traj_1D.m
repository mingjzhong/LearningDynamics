function visualize_traj_1D(traj_fig, trajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)
% function visualize_traj_1D(traj_fig, trajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)

% (c) M. Zhong (JHU)

if sys_info.d ~= 1, error('SOD_Utils:visualize_traj_1D:exception', 'This routine is for 1D Visualization!!'); end
% prepare the y range
y_min                          = zeros(1, length(trajs));
y_max                          = zeros(1, length(trajs));
for ind = 1 : length(trajs)
  traj                         = trajs{ind};
  y_min(ind)                   = min(min(traj));
  y_max(ind)                   = max(max(traj));
end
y_min                          = min(y_min);
y_max                          = max(y_max);
if length(trajs) == 1, handleAxes = gobjects(1); else, handleAxes = gobjects(length(trajs)/2, 2); end
y_range                        = y_max - y_min;
y_min                          = y_min - 0.1 * y_range;
y_max                          = y_max + 0.1 * y_range;
vline_y                        = linspace(y_min, y_max, obs_info.L);
vline_x                        = obs_info.T * ones(size(vline_y));
x_min                          = min(time_vec);
x_max                          = max(time_vec);
for ind = 1 : length(trajs)
  if length(trajs) == 1, sp_handle = subplot(1, 1, ind); else, sp_handle = subplot(length(trajs)/2, 2, ind); end
  traj                         = trajs{ind};
  if 1 <= ind && ind <= 4, the_sys_info = sys_info; else, the_sys_info = sys_info_Ntransfer; end
  plot_one_traj_1D(sp_handle, traj, time_vec, the_sys_info, 1, plot_info);
  plot(vline_x, vline_y, '-.k');
  l_handle                     = plot(NaN, NaN, ['k' plot_info.line_styles{1}]);                    % dummy lines for legend
  hold off;
  axis([x_min, x_max, y_min, y_max]);
  sp_handle.FontSize           = plot_info.tick_font_size;
  sp_handle.FontName           = plot_info.tick_font_name;   
  if mod(ind, 2) == 1
    ylabel('Coord. $1$', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
  end
  if ind == length(trajs) - 1 || ind == length(trajs)
    xlabel('Time $t$', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
  end
  if ind == 1 || ind == 3
    leg_handle                 = legend(l_handle, {'$\mathbf{x}_i(t)$'});
  elseif ind == 2 || ind == 4
    leg_handle                 = legend(l_handle, {'$\hat\mathbf{x}_i(t)$'});
  elseif ind == 5 || ind == 6
    leg_handle                 = legend(l_handle, {'$\mathbf{x}_i^{LN}(t)$'});
  end
  set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
  row_ind                      = floor((ind - 1)/2) + 1;
  col_ind                      = mod(ind - 1, 2) + 1;    
  handleAxes(row_ind, col_ind) = sp_handle;
end
% tighten them up
tightFigaroundAxes(handleAxes);
saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig'); 
end