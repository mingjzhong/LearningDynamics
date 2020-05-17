function make_traj_1D_animation(traj_fig, trajs, dtrajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)
% function make_traj_1D_animation(trajs, dtrajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)

% (c) M. Zhong (JHU)

if sys_info.d ~= 1, error('SOD_Utils:make_traj_1D_animation:exception', 'This routine is for 1D Visualization!!'); end
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
y_span                         = y_max - y_min;
x_min                          = min(time_vec);
x_max                          = max(time_vec);
x_span                         = x_max - x_min;
sp_handles                     = gobjects(1, length(trajs));
lg_handles                     = gobjects(length(trajs), sys_info.K);
lg_names                       = cell(length(trajs), sys_info.K);
arrow_lens                     = cell(size(trajs));
type_names                     = get_type_names(sys_info);
T_loc                          = find(time_vec == obs_info.T);
for ind = 1 : length(trajs)
  arrow_lens{ind}              = plot_info.arrow_scale ./ sqrt((dtrajs{ind}/x_span).^2 + (1/y_span)^2); % arrow length relative to fig. window size
  if length(trajs) == 1, sp_handles(ind) = subplot(1, 1, ind); else, sp_handles(ind) = subplot(length(trajs)/2, 2, ind); end
  if mod(ind, 2) == 1, name = 'True '; else, name = 'Learned '; end
  for k = 1 : sys_info.K
    if length(trajs) == 1, lg_names{ind, k} = type_names{k}; else, lg_names{ind, k} = [name type_names{k}]; end
  end
  row_ind                      = floor((ind - 1)/2) + 1;
  col_ind                      = mod(ind - 1, 2) + 1;  
  handleAxes(row_ind, col_ind) = sp_handles(ind);
end
set(traj_fig, 'visible', 'on');
movie_file                     = VideoWriter([plot_info.plot_name '_mov'], 'MPEG-4');
open(movie_file);
for time_ind = 1 : length(time_vec)
  for ind = 1 : length(trajs)
    sp_handle                    = sp_handles(ind);
    if 1 <= ind && ind <= 4, the_sys_info = sys_info; else, the_sys_info = sys_info_Ntransfer; end
    lg_handles(ind, :)           = plot_one_point_1D(traj_fig, sp_handle, trajs{ind}(:, time_ind), time_vec(time_ind), ...
      dtrajs{ind}(:, time_ind), arrow_lens{ind}(:, time_ind), T_loc == time_ind, the_sys_info, plot_info);
    plot_one_line_1D(traj_fig, sp_handle, trajs{ind}, time_vec, time_ind, the_sys_info, plot_info); 
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
    leg_handle                 = legend(lg_handles(ind, :), lg_names(ind, :));
    set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
  end
  tightFigaroundAxes(handleAxes);
  writeVideo(movie_file, getframe(gcf));
  if time_ind == 1, pause(0.01); end  
end
close(movie_file);
end