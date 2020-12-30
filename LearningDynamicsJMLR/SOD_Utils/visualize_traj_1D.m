function visualize_traj_1D(trajs, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_1D(trajs, time_vec, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)


% changing plot_info
% plot_info.scrsz                 = [1, 1, 1920, 1080];                                        
% plot_info.legend_font_size      = 33;
% plot_info.legend_font_name      = 'Helvetica';
% plot_info.colorbar_font_size    = 33;
% plot_info.title_font_size       = 44;
% plot_info.title_font_name       = 'Helvetica';
% plot_info.axis_font_size        = 44;
% plot_info.axis_font_name        = 'Helvetica';
% plot_info.tick_font_size        = 39;
% plot_info.tick_font_name        = 'Helvetica';
% plot_info.traj_line_width       = 1.0;
% plot_info.phi_line_width        = 1.5;
% plot_info.phihat_line_width     = 1.5;
% plot_info.rhotscalingdownfactor = 1;
% plot_info.showplottitles        = false;
% plot_info.display_phihat        = false;
% plot_info.display_interpolant   = true;
% plot_info.T_L_marker_size       = 40;
% plot_info.line_styles           = {'-', '-.', '--', ':'};                                        % traj. line styles
% plot_info.type_colors           = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
% plot_info.marker_style          = {'s', 'd', 'p', 'h', 'x', '+', 'v', '^', '<', '>'};            
% plot_info.marker_size           = plot_info.T_L_marker_size;                                                   
% plot_info.marker_edge_color     = {'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k'};
% plot_info.marker_face_color     = {'b', 'r', 'c', 'g', 'm', 'y', 'k', 'k', 'k', 'k'};
 plot_info.plot_name = sys_info.name;



if sys_info.d ~= 1, error('SOD_Utils:visualize_traj_1D:exception', 'This routine is for 1D Visualization!!'); end
% prepare the window size
if isfield(plot_info, 'scrsz') && ~isempty(plot_info.scrsz), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
% prepare the figure window
if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N && isfield(plot_info, 'plot_noise') && plot_info.plot_noise
  traj_fig                     = figure('Name', 'Traj (1D): True Vs. Learned, Larger N', 'NumberTitle', 'off', 'Position', ...
  [scrsz(3)*1/8 + scrsz(3) * 1/6, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
else
  traj_fig                     = figure('Name', 'Traj (1D): True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
  [scrsz(3)*1/8 + scrsz(3) * 5/48, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
end

% prepare the color for each type
type_colors    = {'b', 'g', 'r', 'c', 'm', 'y', 'k'};
if sys_info.K > 7
  error('SOD_Utils:visualize_traj_1D:exception', 'The Coloring Scheme of trajectories only work for upto 7 types of agents!!');
end
% split the true trajectories (1)
ind_1                          = find(time_vec <= obs_info.T_L);
ind_2                          = find(time_vec >= obs_info.T_L);
traj_1s                        = cell(1, length(trajs));
traj_2s                        = cell(1, length(trajs));
time_1                         = time_vec(ind_1);
time_2                         = time_vec(ind_2);
y_min                          = zeros(1, length(trajs));
y_max                          = zeros(1, length(trajs));
for ind = 1 : length(trajs)
  traj                         = trajs{ind};
  traj_1                       = traj(:, ind_1);
  traj_2                       = traj(:, ind_2);
  traj_1s{ind}                 = traj_1;
  traj_2s{ind}                 = traj_2;
  y_min(ind)                   = min(min(traj));
  y_max(ind)                   = max(max(traj));
end
y_min                          = min(y_min);
y_max                          = max(y_max);
handleAxes                     = gobjects(2);
y_range                        = y_max - y_min;
y_min                          = y_min - 0.1 * y_range;
y_max                          = y_max + 0.1 * y_range;
vline_y                        = linspace(y_min, y_max, obs_info.L);
vline_x                        = obs_info.T_L * ones(size(vline_y));
x_min                          = min(time_vec);
x_max                          = max(time_vec);
for ind = 1 : 4
  subplot(2, 2, ind); 
  traj_1                       = traj_1s{ind};
  traj_2                       = traj_2s{ind};
  for k = 1 : sys_info.K
    agents_traj                = traj_1(sys_info.type_info == k, :);
    plot(time_1, agents_traj, 'LineWidth', plot_info.traj_line_width, 'color', type_colors{k});
    if k == 1, hold on; end
  end
  plot(vline_x, vline_y, '-.k');
  for k = 1 : sys_info.K
    agents_traj = traj_2(sys_info.type_info == k, :);
    plot(time_2, agents_traj, 'LineWidth', plot_info.traj_line_width, 'color', type_colors{k});
  end
  hold off;
  axis([x_min, x_max, y_min, y_max]);
  axesHandle                   = gca;
  axesHandle.FontSize          = plot_info.tick_font_size;
  axesHandle.FontName          = plot_info.tick_font_name;   
  if ind == 1 || ind == 3
    ylabel_name                = '$\mathbf{x}_i$';
  else
    ylabel_name                = '$\hat\mathbf{x}_i$';
  end
  ylabel(ylabel_name,   'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
  if ind == 3 || ind == 4
    xlabel('$t$, time', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
  end
  hold off;
  row_ind                      = floor((ind - 1)/2) + 1;
  col_ind                      = mod(ind - 1, 2) + 1;    
  handleAxes(row_ind, col_ind) = axesHandle;
end
% tighten them up
tightFigaroundAxes(handleAxes);
if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N
  saveas(traj_fig, [plot_info.plot_name '_traj_LN'], 'fig'); 
else
  saveas(traj_fig, [plot_info.plot_name '_traj'], 'fig'); 
end
end