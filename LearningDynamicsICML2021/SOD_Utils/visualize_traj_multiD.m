function handleAxes = visualize_traj_multiD(traj_fig, trajs, time_vec, sys_info, ...
                      sys_info_Ntransfer, obs_info, plot_info)
% function handleAxes = visualize_traj_multiD(traj_fig, trajs, time_vec, sys_info, ...
%                      sys_info_Ntransfer, obs_info, plot_info)

% (c) M. Zhong (JHU)

% routine check
if sys_info.d == 1, error('SOD_Utils:visualize_traj_multiD:exception', 'This routine is for 2D/3D Visualization!!'); end
cOutput                        = construct_color_items(sys_info.K, time_vec);
plot_info.c_vecs               = cOutput.c_vecs;
% split the trajectories
[X_coords, the_mins, the_maxs] = split_trajectories(trajs, sys_info, sys_info_Ntransfer);
x_min                          = min(the_mins(:, 1));
x_max                          = max(the_maxs(:, 1));
y_min                          = min(the_mins(:, 2));
y_max                          = max(the_maxs(:, 2));
if sys_info.d == 3, z_min = min(the_mins(:, 3)); z_max = max(the_maxs(:, 3)); end
if sys_info.d == 3, if z_max < z_min + 10 * eps, z_max = z_min + 1; end, end
if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold) && sys_info.on_manifold
  [manifold_min, manifold_max] = get_component_range_from_manifold(sys_info);
  if ~isempty(manifold_min)
    x_min                      = min([x_min, manifold_min(1)]);
    x_max                      = max([x_max, manifold_max(1)]);
    y_min                      = min([y_min, manifold_min(2)]);
    y_max                      = max([y_max, manifold_max(2)]);
    if sys_info.d == 3
      z_min                    = min([z_min, manifold_min(3)]);
      z_max                    = max([z_max, manifold_max(3)]);
    end
  end
end
[x_min, x_max]                 = get_adjusted_traj_range(x_min, x_max);
[y_min, y_max]                 = get_adjusted_traj_range(y_min, y_max);
if sys_info.d == 3
  [z_min, z_max]               = get_adjusted_traj_range(z_min, z_max);
end
if length(trajs) == 1, handleAxes = gobjects(1); else, handleAxes = gobjects(length(trajs)/2, 2); end
T_loc                          = find(time_vec == obs_info.T);
if isfield(plot_info, 'use_new_ICs') && ~isempty(plot_info.use_new_ICs) && plot_info.use_new_ICs
  traj_ind_start               = 3;
  handleAxes                   = gobjects(2, 2);
  num_rows                     = 2;
  ind_gap                      = -2;
else
  traj_ind_start               = 1;
  num_rows                     = length(trajs)/2;
  ind_gap                      = 0;
end
for ind = traj_ind_start : length(trajs)
  if length(trajs) == 1
    sp_handle                  = subplot(1, 1, ind); 
  else
    sp_handle                  = subplot(num_rows, 2, ind + ind_gap); 
  end
  if 1 <= ind && ind <= 4, the_sys_info = sys_info; else, the_sys_info = sys_info_Ntransfer; end
  plot_one_traj_multiD(traj_fig, sp_handle, X_coords(ind, :), the_sys_info, 1, plot_info);
  if sys_info.d == 2
    plot(X_coords{ind, 1}(:, T_loc), X_coords{ind, 2}(:, T_loc), 'o', 'MarkerSize', ...
      plot_info.T_L_marker_size, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
    l_handle                   = plot(NaN, NaN, ['k' plot_info.line_styles{1}]);                    % dummy lines for legend
  else
    plot3(X_coords{ind, 1}(:, T_loc), X_coords{ind, 2}(:, T_loc), X_coords{ind, 3}(:, T_loc), ...
      'o', 'MarkerSize', plot_info.T_L_marker_size, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
    l_handle                   = plot3(NaN, NaN, NaN, ['k' plot_info.line_styles{1}]);              % dummy lines for legend    
  end
  if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold) && sys_info.on_manifold
    if strcmp(sys_info.manifold_type, 'H2')
      plot_info.y_range        = [y_min, y_max];
      plot_info.z_range        = [z_min, z_max];
    end
    plot_manifold(traj_fig, sp_handle, sys_info, plot_info);
  end
  hold off; 
  if ind == traj_ind_start
    the_xticks                 = get(sp_handle, 'XTick');
    delta                      = the_xticks(2) - the_xticks(1);
  end
  xtickformat('%.1f'); ytickformat('%.1f'); 
  sp_handle.FontSize           = plot_info.tick_font_size;
  sp_handle.FontName           = plot_info.tick_font_name;   
  if length(trajs) == 1 || mod(ind, 2) == 0
    if sys_info.d == 2
      axis([x_min, x_max + delta, y_min, y_max]);
    else
      axis([x_min, x_max + delta, y_min, y_max, z_min, z_max]); 
    end    
    colormap(cOutput.cmap);
    cbh                        = colorbar('Location', 'East');
    cb_items                   = get_color_bar_labels(cbh, sys_info.K, obs_info.T, time_vec, ...
                                 cOutput.color_ind);
    set(cbh, 'FontSize', plot_info.colorbar_font_size, 'YTickLabel', cb_items.labels, ...
      'YTick', cb_items.ticks);
  else
    if sys_info.d == 2
      axis([x_min, x_max, y_min, y_max]);
    else
      axis([x_min, x_max, y_min, y_max, z_min, z_max]); 
    end    
  end
  if mod(ind, 2) == 1
    if sys_info.d == 2
      ylabel('Coord. $2$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', ...
        'FontName', plot_info.axis_font_name);
    else
      zlabel('Coord. $3$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', ...
        'FontName', plot_info.axis_font_name);
    end
  end
  if ind == length(trajs) - 1 || ind == length(trajs)
    xlabel('Coord. $1$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', ...
        'FontName', plot_info.axis_font_name);
    if sys_info.d == 3
      ylabel('Coord. $2$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', ...
        'FontName', plot_info.axis_font_name);
    end
  end
  row_ind                      = floor((ind + ind_gap - 1)/2) + 1;
  col_ind                      = mod(ind + ind_gap - 1, 2) + 1;
  if mod(ind, 2) ~= 0
    leg_handle                 = legend(l_handle, {'$\mathbf{x}_i(t)$'});
  else
    leg_handle                 = legend(l_handle, {'$\hat\mathbf{x}_i(t)$'});
  end
  set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', ...
    plot_info.legend_font_size);
  if isfield(plot_info, 'traj_titles') && ~isempty(plot_info.traj_titles)
    title(plot_info.traj_titles{ind}, 'FontSize', plot_info.axis_font_size, 'Interpreter', ...
      'latex', 'FontName', plot_info.axis_font_name);
  end
  handleAxes(row_ind, col_ind) = sp_handle;
end
tightFigaroundAxes(handleAxes);
[nRows, nCols]                 = size(handleAxes);
for idx1 = 1 : nRows
  for idx2 = 1 : nCols
    set_num_of_ticks(handleAxes(idx1, idx2), sys_info.d); 
  end
end
  
saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig');
end