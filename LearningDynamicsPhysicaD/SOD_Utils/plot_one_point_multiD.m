function line_handles = plot_one_point_multiD(fig_handle, plot_handle, X_cds, dX_cds, time_ind, arrow_len, is_at_T, sys_info, plot_info)
% function plot_one_point_multiD(fig_handle, plot_handle, X_cds, dX_cds, time_ind, arrow_len, is_at_T, sys_info, plot_info)

% (C) M. Zhong

set(fig_handle, 'CurrentAxes', plot_handle);
line_handles                 = gobjects(1, sys_info.K);
for k = 1 : sys_info.K
  agents_Ck                  = find(sys_info.type_info == k);
  N_k                        = length(agents_Ck);
  marker_edge_color          = plot_info.marker_edge_color{k};
  marker_face_color          = plot_info.marker_face_color{k};
  for agent_ind = 1 : N_k
    agent                    = agents_Ck(agent_ind);
    if isfield(plot_info, 'color_on_phase') && ~isempty(plot_info.color_on_phase)
      marker_edge_color      = plot_info.color_on_phase(agent, :);
      marker_face_color      = plot_info.color_on_phase(agent, :); 
    end
    if ~is_at_T
      if sys_info.d == 2
        ph = plot(X_cds{1}(agent, time_ind), X_cds{2}(agent, time_ind), plot_info.marker_style{k}, 'MarkerSize', plot_info.marker_size, ...
          'MarkerEdgeColor', marker_edge_color, 'MarkerFaceColor', marker_face_color);
      else
        ph = plot3(X_cds{1}(agent, time_ind), X_cds{2}(agent, time_ind), X_cds{3}(agent, time_ind), plot_info.marker_style{k}, 'MarkerSize', ...
          plot_info.marker_size, 'MarkerEdgeColor', marker_edge_color, 'MarkerFaceColor', marker_face_color);        
      end
    else
      if sys_info.d == 2
        ph = plot(X_cds{1}(agent, time_ind), X_cds{2}(agent, time_ind), 'o', 'MarkerSize', plot_info.marker_size, ...
          'MarkerEdgeColor', marker_edge_color, 'MarkerFaceColor', marker_face_color);
      else
        ph = plot3(X_cds{1}(agent, time_ind), X_cds{2}(agent, time_ind), X_cds{3}(agent, time_ind), 'o', 'MarkerSize', ...
          plot_info.marker_size, 'MarkerEdgeColor', marker_edge_color, 'MarkerFaceColor', marker_face_color);        
      end
    end
    if agent_ind == 1, line_handles(k) = ph; end
    if k == 1 && agent_ind == 1, hold on; end
    if sys_info.d == 2
      quiver(X_cds{1}(agent, time_ind), X_cds{2}(agent, time_ind), arrow_len(agent) * dX_cds{1}(agent, time_ind), arrow_len(agent) * dX_cds{2}(agent, time_ind), ...
        'LineWidth', plot_info.arrow_thickness, 'Color', marker_face_color, 'ShowArrowHead', 'on', 'MaxHeadSize', plot_info.arrow_head_size, ...
        'AutoScale', 'off');
    else
      quiver3(X_cds{1}(agent, time_ind), X_cds{2}(agent, time_ind), X_cds{3}(agent, time_ind), arrow_len(agent) * dX_cds{1}(agent, time_ind), ...
        arrow_len(agent) * dX_cds{2}(agent, time_ind), arrow_len(agent) * dX_cds{3}(agent, time_ind), 'LineWidth', plot_info.arrow_thickness, ...
        'Color', marker_face_color, 'ShowArrowHead', 'on', 'MaxHeadSize', plot_info.arrow_head_size, 'AutoScale', 'off');      
    end
  end
end
end