function visualize_traj_multiD(traj_fig, trajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)
% function visualize_traj_multiD(traj_fig, trajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info)

% (c) M. Zhong (JHU)

% routine check
if sys_info.d == 1, error('SOD_Utils:visualize_traj_multiD:exception', 'This routine is for 2D/3D Visualization!!'); end
color_output                   = construct_color_items(sys_info.K, obs_info.T, time_vec);
cmap                           = color_output.cmap;
plot_info.c_vecs               = color_output.c_vecs;
clabels                        = color_output.clabels;
cticks                         = color_output.cticks;
% split the trajectories
X_coords                       = cell(length(trajs),  sys_info.d);
the_mins                       = zeros(length(trajs), sys_info.d);
the_maxs                       = zeros(length(trajs), sys_info.d);
for ind = 1 : length(trajs)
  traj                         = trajs{ind};
  for d_ind = 1 : sys_info.d
    X_cd                       = traj(d_ind : sys_info.d : (sys_info.N - 1) * sys_info.d + d_ind, :);
    the_mins(ind, d_ind)       = min(X_cd(:));
    the_maxs(ind, d_ind)       = max(X_cd(:));
    X_coords{ind, d_ind}       = X_cd;
  end
end
x_min                          = min(the_mins(:, 1));
x_max                          = max(the_maxs(:, 1));
y_min                          = min(the_mins(:, 2));
y_max                          = max(the_maxs(:, 2));
if sys_info.d == 3, z_min = min(the_mins(:, 3)); z_max = max(the_maxs(:, 3)); end
if sys_info.d == 3, if z_max < z_min + 10 * eps, z_max = z_min + 1; end, end
if length(trajs) == 1, handleAxes = gobjects(1); else, handleAxes = gobjects(length(trajs)/2, 2); end
T_loc                          = find(time_vec == obs_info.T);
for ind = 1 : length(trajs)
  if length(trajs) == 1, sp_handle = subplot(1, 1, ind); else, sp_handle = subplot(length(trajs)/2, 2, ind); end                        
  if 1 <= ind && ind <= 4, the_sys_info = sys_info; else, the_sys_info = sys_info_Ntransfer; end
  plot_one_traj_multiD(traj_fig, sp_handle, X_coords(ind, :), the_sys_info, 1, plot_info);
  if sys_info.d == 2
    plot(X_coords{ind, 1}(:, T_loc), X_coords{ind, 2}(:, T_loc), 'o', 'MarkerSize', plot_info.T_L_marker_size, ...
      'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
    l_handle                   = plot(NaN, NaN, ['k' plot_info.line_styles{1}]);                    % dummy lines for legend
  else
    plot3(X_coords{ind, 1}(:, T_loc), X_coords{ind, 2}(:, T_loc), X_coords{ind, 3}(:, T_loc), 'o', 'MarkerSize', ...
      plot_info.T_L_marker_size, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
    l_handle                   = plot3(NaN, NaN, NaN, ['k' plot_info.line_styles{1}]);              % dummy lines for legend    
  end
  hold off; 
  if ind == 1
    xticks                     = get(sp_handle, 'XTick');
    delta                      = xticks(2) - xticks(1);
  end
  xtickformat('%.1f'); ytickformat('%.1f'); 
  if sys_info.d == 2, axis([x_min, x_max + delta, y_min, y_max]); else, axis([x_min, x_max, y_min, y_max, z_min, z_max]); end
  sp_handle.FontSize           = plot_info.tick_font_size;
  sp_handle.FontName           = plot_info.tick_font_name;   
  if length(trajs) == 1 || mod(ind, 2) == 0
    colormap(cmap);
    cbh                        = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'East');
    set(cbh, 'FontSize', plot_info.colorbar_font_size);
  end
  if mod(ind, 2) == 1
    if sys_info.d == 2
      ylabel('Coord. $2$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
    else
      zlabel('Coord. $3$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
    end
  end
  if ind == length(trajs) - 1 || ind == length(trajs)
    if sys_info.d == 2
      xlabel('Coord. $1$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
    else
      xlabel('Coord. $1$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
      ylabel('Coord. $2$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
    end
  end
  row_ind                      = floor((ind - 1)/2) + 1;
  col_ind                      = mod(ind - 1, 2) + 1;
  if ind == 1 || ind == 3
    leg_handle                 = legend(l_handle, {'$\mathbf{x}_i(t)$'});
  elseif ind == 2 || ind == 4
    leg_handle                 = legend(l_handle, {'$\hat\mathbf{x}_i(t)$'});
  elseif ind == 5 || ind == 6
    leg_handle                 = legend(l_handle, {'$\mathbf{x}_i^{LN}(t)$'});
  end
  set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
  handleAxes(row_ind, col_ind) = sp_handle;
end
tightFigaroundAxes(handleAxes);
saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig');
end