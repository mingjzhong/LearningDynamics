function visualize_traj_multiD_wnoise(traj_fig, traj_noise, traj_true, traj_hat, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_multiD_wnoise(traj_fig, trajs, time_vec, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

% routine check
if sys_info.d == 1, error('SOD_Utils:visualize_traj_multiD_wnoise:exception', 'This routine is for 2D/3D Visualization!!'); end
% prepare the trajectories
trajs{1} = traj_true; trajs{2} = traj_hat; trajs{3} = traj_noise;
% prepare the color items
color_output             = construct_color_items(sys_info.K, obs_info.T_L, time_vec);
cmap = color_output.cmap; plot_info.c_vecs = color_output.c_vecs; clabels = color_output.clabels; cticks = color_output.cticks;
% split the trajectories
X_coords                 = cell(3, sys_info.d);
the_mins                 = zeros(length(trajs), sys_info.d);
the_maxs                 = zeros(length(trajs), sys_info.d);
for ind = 1 : length(trajs)
  traj                   = trajs{ind};
  for d_ind = 1 : sys_info.d
    X_cd                 = traj(d_ind : sys_info.d : end - (sys_info.d - d_ind), :);
    the_mins(ind, d_ind) = min(X_cd(:));
    the_maxs(ind, d_ind) = max(X_cd(:));
    X_coords{ind, d_ind} = X_cd;
  end
end
x_min                    = min(the_mins(:, 1));
x_max                    = max(the_maxs(:, 1));
y_min                    = min(the_mins(:, 2));
y_max                    = max(the_maxs(:, 2));
if sys_info.d == 3, z_min = min(the_mins(:, 3)); z_max = max(the_maxs(:, 3)); end
handleAxes               = gobjects(1);
l_handles                = gobjects(1, 3);
T_loc                    = find(time_vec == obs_info.T_L);
plot_info.c_len          = length(time_vec) - T_loc;
for ind = 1 : 3
  plot_one_traj_multiD(traj_fig, gca, X_coords(ind, :), sys_info, ind, plot_info);
  if ind ~= 3
    if sys_info.d == 2
      plot(X_coords{ind, 1}(:, T_loc), X_coords{ind, 2}(:, T_loc), 'o', 'MarkerSize', plot_info.T_L_marker_size, ...
        'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
    else
      plot3(X_coords{ind, 1}(:, T_loc), X_coords{ind, 2}(:, T_loc), X_coords{ind, 3}(:, T_loc), 'o', 'MarkerSize', ...
        plot_info.T_L_marker_size, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');      
    end
  end
  if sys_info.d == 2, l_handles(ind) = plot(NaN, NaN, ['k' plot_info.line_styles{ind}]);
  else,l_handles(ind) = plot3(NaN, NaN, NaN, ['k' plot_info.line_styles{ind}]); end                 % dummy lines for legend
  hold off;
end
axesHandle               = gca;
axesHandle.FontSize      = plot_info.tick_font_size;
axesHandle.FontName      = plot_info.tick_font_name;  
xticks                   = get(axesHandle, 'XTick');
delta                    = xticks(3) - xticks(2);
if sys_info.d == 2, axis([x_min, x_max + delta, y_min, y_max]); else, axis([x_min, x_max + delta, y_min, y_max, z_min, z_max]); end
colormap(cmap);
h                        = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'East');
set(h, 'FontSize', plot_info.colorbar_font_size);
xlabel('Coord. $1$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
ylabel('Coord. $2$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
if sys_info.d == 3, zlabel('Coord. $3$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name); end
leg_handle               = legend(l_handles, {'$\mathbf{x}_i(t)$', '$\hat\mathbf{x}_i(t)$', '$\mathbf{x}_i^\epsilon(t)$'});
set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
handleAxes(1)            = gca;
tightFigaroundAxes(handleAxes);
saveas(traj_fig, [plot_info.plot_name '_traj_noise'], 'fig');
end