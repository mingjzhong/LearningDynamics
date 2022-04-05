function line_handles = plot_one_point_1D(fig_handle, plot_handle, X_pt, t_pt, dX_pt, arrow_len, is_at_T, sys_info, plot_info)
% function plot_one_point_multiD(fig_handle, plot_handle, X_pt, t_pt, dX_pt, arrow_len, is_at_T, sys_info, plot_info)
% (C) M. Zhong

set(fig_handle, 'CurrentAxes', plot_handle);
line_handles                 = gobjects(1, sys_info.K);
for k = 1 : sys_info.K
  agents_Ck                  = find(sys_info.type_info == k);
  N_k                        = length(agents_Ck);
  for agent_ind = 1 : N_k
    agent                    = agents_Ck(agent_ind);
    if ~is_at_T
      ph = plot(t_pt, X_pt(agent), plot_info.marker_style{k}, 'MarkerSize', plot_info.marker_size, ...
        'MarkerEdgeColor', plot_info.marker_edge_color{k}, 'MarkerFaceColor', plot_info.marker_face_color{k});
    else
      ph = plot(t_pt, X_pt(agent), 'o', 'MarkerSize', plot_info.marker_size, ...
        'MarkerEdgeColor', plot_info.marker_edge_color{k}, 'MarkerFaceColor', plot_info.marker_face_color{k});
    end
    if agent_ind == 1, line_handles(k) = ph; end
    if k == 1 && agent_ind == 1, hold on; end
    quiver(t_pt, X_pt(agent), arrow_len(agent), arrow_len(agent) * dX_pt(agent), 'LineWidth', plot_info.arrow_thickness, ...
      'Color', plot_info.marker_face_color{k}, 'ShowArrowHead', 'on', 'MaxHeadSize', plot_info.arrow_head_size, ...
      'AutoScale', 'off');
  end
end
end