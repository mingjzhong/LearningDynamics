function visualize_traj_3D(trajs, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_3D(trajs, time_vec, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

% routine check
if sys_info.d ~= 3, error('SOD_Utils:visualize_traj_3D:exception', 'This routine is for 3D Visualization!!'); end
% prepare the window size
if isfield(plot_info, 'scrsz') && ~isempty(plot_info.scrsz), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
% prepare the figure window
if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N
  traj_fig                     = figure('Name', 'Traj (3D): True Vs. Learned, Larger N', 'NumberTitle', 'off', 'Position', ...
  [scrsz(3)*1/8 + scrsz(3) * 1/8, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
else
  traj_fig                     = figure('Name', 'Traj (3D): True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
  [scrsz(3)*1/8 + scrsz(3) * 5/48, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
end
color_output                   = construct_color_items(sys_info.K, obs_info.T_L, time_vec);
cmap                           = color_output.cmap;
c_vecs                         = color_output.c_vecs;
clabels                        = color_output.clabels;
cticks                         = color_output.cticks;
% split the trajectories
X_c1s                          = cell(1, 4);
X_c2s                          = cell(1, 4);
X_c3s                          = cell(1, 4);
x_min                          = zeros(1, 4);
x_max                          = zeros(1, 4);
y_min                          = zeros(1, 4);
y_max                          = zeros(1, 4);
z_min                          = zeros(1, 4);
z_max                          = zeros(1, 4);
for ind = 1 : 4
  traj                         = trajs{ind};
  X_c1                         = traj(1 : 3 : end - 2, :);
  X_c2                         = traj(2 : 3 : end - 1, :);
  X_c3                         = traj(3 : 3 : end,     :);
  x_min(ind)                   = min(min(X_c1));
  x_max(ind)                   = max(max(X_c1));
  y_min(ind)                   = min(min(X_c2));
  y_max(ind)                   = max(max(X_c2));
  z_min(ind)                   = min(min(X_c3));
  z_max(ind)                   = max(max(X_c3));  
  X_c1s{ind}                   = X_c1;
  X_c2s{ind}                   = X_c2;
  X_c3s{ind}                   = X_c3;
end
x_min                          = min(x_min);
x_max                          = max(x_max);
y_min                          = min(y_min);
y_max                          = max(y_max);
z_min                          = min(z_min);
z_max                          = max(z_max);
T_loc                          = find(time_vec == obs_info.T_L);
handleAxes                     = gobjects(2);
for ind = 1 : 4
  subplot(2, 2, ind);  
  X_c1                         = X_c1s{ind};
  X_c2                         = X_c2s{ind};
  X_c3                         = X_c3s{ind};
  for k = 1 : sys_info.K
    agents_Ck                  = find(sys_info.type_info == k);
    N_k                        = length(agents_Ck);
    for agent_ind = 1 : N_k
      agent                    = agents_Ck(agent_ind);
      c1_at_t                  = X_c1(agent, :);
      c2_at_t                  = X_c2(agent, :);
      c3_at_t                  = X_c3(agent, :);
      p_handle                 = patch([c1_at_t, NaN], [c2_at_t, NaN], [c3_at_t, NaN], [c_vecs{k}, NaN], ...
      'EdgeColor', 'interp', 'LineStyle', '-', 'LineWidth', plot_info.traj_line_width);
%       if strcmp(sys_info.name, 'PredatorPrey1stOrder3D') 
%         if k == 1, set(p_handle, 'EdgeAlpha', 0.25); end
%       end
      if k == 1 && agent_ind == 1, hold on; end
    end
  end
  plot3(X_c1(:, T_loc), X_c2(:, T_loc), X_c3(:, T_loc), 'o', 'MarkerSize', plot_info.T_L_marker_size, ...
  'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k'); hold off;
  axesHandle                   = gca;
  if ind == 1
    xticks                     = get(axesHandle, 'XTick');
    delta                      = xticks(3) - xticks(2);
    axis([x_min x_max y_min y_max z_min z_max]);
  else
    if ind == 2 || ind == 4
      axis([x_min x_max + delta y_min y_max z_min z_max]);
    else
      axis([x_min x_max y_min y_max z_min z_max]);
    end
  end
  axesHandle.FontSize          = plot_info.tick_font_size;
  axesHandle.FontName          = plot_info.tick_font_name;   
  colormap(cmap);
  if ind == 2 || ind == 4
    h                          = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'East');
    set(h, 'FontSize', plot_info.colorbar_font_size);
  end
  if ind == 1 || ind == 3
    zlabel_name                = 'Coord. $3$ of $\mathbf{x}_i(t)$';
  else
    zlabel_name                = 'Coord. $3$ of $\hat\mathbf{x}_i(t)$';
  end  
  zlabel(zlabel_name, 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', ...
  plot_info.axis_font_name);
  if ind == 3 || ind == 4
    if ind == 3
      xlabel_name              = 'Coord. $1$ of $\mathbf{x}_i(t)$';
      ylabel_name              = 'Coord. $2$ of $\mathbf{x}_i(t)$';
    elseif ind == 4 
      xlabel_name              = 'Coord. $1$ of $\hat\mathbf{x}_i(t)$';
      ylabel_name              = 'Coord. $2$ of $\hat\mathbf{x}_i(t)$';
    end
    xlabel(xlabel_name, 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', ...
    plot_info.axis_font_name);
    ylabel(ylabel_name, 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', ...
    plot_info.axis_font_name);
  end
  row_ind                      = floor((ind - 1)/2) + 1;
  col_ind                      = mod(ind - 1, 2) + 1;
  handleAxes(row_ind, col_ind) = axesHandle;
  if ind == 3 || ind == 4, align_axes(gca); end
end
tightFigaroundAxes(handleAxes);
if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N
  saveas(traj_fig, [plot_info.plot_name '_traj_LN'], 'fig');
else
  saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig');
end
end