function plot_one_traj_multiD(fig_handle, plot_handle, X_cds, sys_info, line_style_ind, plot_info)
% function plot_one_traj_multiD(fig_handle, plot_handle, X_cds, sys_info, plot_info)

% (C) M. Zhong

set(fig_handle, 'CurrentAxes', plot_handle);
for k = 1 : sys_info.K
  agents_Ck                  = find(sys_info.type_info == k);
  N_k                        = length(agents_Ck);
  for agent_ind = 1 : N_k
    agent                    = agents_Ck(agent_ind);
    if line_style_ind < 3
      c1_at_t                = X_cds{1}(agent, :);
      c2_at_t                = X_cds{2}(agent, :);
      if sys_info.d == 3, c3_at_t = X_cds{3}(agent, :); end
    elseif line_style_ind == 3
      c1_at_t                = [X_cds{1}(agent, :), NaN * ones(1, plot_info.c_len)];
      c2_at_t                = [X_cds{2}(agent, :), NaN * ones(1, plot_info.c_len)];  
      if sys_info.d == 3, c3_at_t = [X_cds{3}(agent, :), NaN * ones(1, plot_info.c_len)]; end 
    end
    if sys_info.d == 2
      p_handle                 = patch([c1_at_t, NaN], [c2_at_t, NaN], [plot_info.c_vecs{k}, NaN], ...
        'EdgeColor', 'interp', 'LineStyle', plot_info.line_styles{line_style_ind}, 'LineWidth', ...
        plot_info.traj_line_width);
    else
      p_handle                 = patch([c1_at_t, NaN], [c2_at_t, NaN], [c3_at_t, NaN], ...
        [plot_info.c_vecs{k}, NaN], 'EdgeColor', 'interp', 'LineStyle', ...
        plot_info.line_styles{line_style_ind}, 'LineWidth', plot_info.traj_line_width);
      view(3);                                                                                      % to view the polygons in 3D
    end
    if strcmp(sys_info.name, 'PredatorPrey1stOrder') || strcmp(sys_info.name, 'PredatorPrey2ndOrder') ...
        || strcmp(sys_info.name, 'PredatorPrey1stOrderSplines')
      if k == 1, set(p_handle, 'EdgeAlpha', 0.4); end                                              % make the preys lighter
    end
    if k == 1 && agent_ind == 1, hold on; end
  end
end
end