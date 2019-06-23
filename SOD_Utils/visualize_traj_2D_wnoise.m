function visualize_traj_2D_wnoise(traj_noise, traj_true, traj_hat, time_vec, sys_info, obs_info, plot_info)
% function visualize_traj_2D(trajs, time_vec, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

% routine check
if sys_info.d    ~= 2, error('SOD_Utils:visualize_traj_2D:exception', 'This routine is for 2D Visualization!!'); end
% prepare the window
if isfield(plot_info, 'scrsz')
  scrsz        = plot_info.scrsz;
else
  scrsz        = get(groot,'ScreenSize');
end
traj_fig         = figure('Name', 'Traj: True Vs. Learned', 'NumberTitle', 'off', 'Position', [scrsz(3)*1/8 + scrsz(3) * 0.13, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
% prepare the trajectories
trajs{1}         = traj_true;
trajs{2}         = traj_hat;
trajs{3}         = traj_noise;
% prepare the color items
if plot_info.for_PNAS
  color_output   = construct_color_items(sys_info.K, obs_info.T_L, plot_info.coarse_time_vec);
else
  color_output   = construct_color_items(sys_info.K, obs_info.T_L, time_vec);
end
cmap             = color_output.cmap;
c_vecs           = color_output.c_vecs;
clabels          = color_output.clabels;
cticks           = color_output.cticks;
% split the trajectories
X_c1s            = cell(1, 3);
X_c2s            = cell(1, 3);
x_min            = zeros(1, 3);
x_max            = zeros(1, 3);
y_min            = zeros(1, 3);
y_max            = zeros(1, 3);
for ind = 1 : 3
  traj           = trajs{ind};
  X_c1           = traj(1 : 2 : end - 1, :);
  X_c2           = traj(2 : 2 : end,     :);
  x_min(ind)     = min(X_c1(:));
  x_max(ind)     = max(X_c1(:));
  y_min(ind)     = min(X_c2(:));
  y_max(ind)     = max(X_c2(:));
  X_c1s{ind}     = X_c1;
  X_c2s{ind}     = X_c2;
end
x_min            = min(x_min);
x_max            = max(x_max);
y_min            = min(y_min);
y_max            = max(y_max);
handleAxes       = gobjects(1);
l_handles        = gobjects(1, 3);
line_styles      = {'-', '-.', '--'};
T_loc            = find(time_vec == obs_info.T_L);
missing_len      = length(time_vec) - T_loc;
for ind = 1 : 3
  X_c1           = X_c1s{ind};
  X_c2           = X_c2s{ind};
  if plot_info.for_PNAS && ind < 3
    dyn_markers  = plot_info.dyn_markers{ind};
    m_C1         = dyn_markers(1 : 2 : end - 1, :);
    m_C2         = dyn_markers(2 : 2 : end,     :);
  end  
  for k = 1 : sys_info.K
    agents_Ck    = find(sys_info.type_info == k);
    N_k          = length(agents_Ck);
    for agent_ind = 1 : N_k
      agent      = agents_Ck(agent_ind);
      if ind == 3
        c1_at_t  = [X_c1(agent, :), NaN * ones(1, missing_len)];
        c2_at_t  = [X_c2(agent, :), NaN * ones(1, missing_len)];
      else
        c1_at_t    = X_c1(agent, :);
        c2_at_t    = X_c2(agent, :);       
      end
      if plot_info.for_PNAS
        if ind < 3
          plot(c1_at_t, c2_at_t, 'LineWidth', plot_info.traj_line_width, 'Color', 'k', ...
            'LineStyle', plot_info.line_styles{ind});
          if k == 1 && agent_ind == 1, hold on; end
          mC1_at_t               = m_C1(agent, :);
          mC2_at_t               = m_C2(agent, :);
          scatter(mC1_at_t, mC2_at_t, plot_info.marker_size, c_vecs{k}', 'filled', plot_info.marker_style{k});        
        else
          s_handle = scatter(c1_at_t, c2_at_t, plot_info.marker_size, 'k', 'filled', 's');
          s_handle.MarkerFaceAlpha = 0.2;
        end
      else
        p_handle   = patch([c1_at_t, NaN], [c2_at_t, NaN], [c_vecs{k}, NaN], 'EdgeColor', 'interp', 'LineStyle', line_styles{ind}, 'LineWidth', plot_info.traj_line_width);
        if ind == 3, set(p_handle, 'EdgeAlpha', 0.2); end
        if k == 1 && agent_ind == 1, hold on; end       
      end
    end
  end
  if ind ~= 3
     scatter(X_c1(:, T_loc), X_c2(:, T_loc), plot_info.T_L_marker_size, 'k', 'filled', 'o');
  end
  if ind < 3
    l_handles(ind)   = plot(NaN, NaN, ['k' line_styles{ind}]);                                      % dummy lines for legend
  else
    l_handles(ind)   = s_handle;
  end
end
axesHandle           = gca;
axis([x_min x_max y_min y_max]);
axesHandle.FontSize  = plot_info.tick_font_size;
axesHandle.FontName  = plot_info.tick_font_name;  
xticks               = get(axesHandle, 'XTick');
delta                = xticks(3) - xticks(2);
axis([x_min x_max + delta y_min y_max]);
colormap(cmap);
h                = colorbar('YTickLabel', clabels, 'YTick', cticks, 'Location', 'East');
set(h, 'FontSize', plot_info.colorbar_font_size);
ylabel('Coord. $2$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
xlabel('Coord. $1$', 'FontSize', plot_info.axis_font_size, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name);
leg_handle       = legend(l_handles, {'$\mathbf{x}_i(t)$', '$\hat\mathbf{x}_i(t)$', '$\mathbf{x}_i^\epsilon(t)$'});
set(leg_handle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
handleAxes(1)    = gca;
tightFigaroundAxes(handleAxes);
saveas(traj_fig, [plot_info.plot_name '_traj_noise'], 'fig');
end