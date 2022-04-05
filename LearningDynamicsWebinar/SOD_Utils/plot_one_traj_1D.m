function plot_one_traj_1D(plot_handle, traj, time_vec, sys_info, line_style_ind, plot_info)
% function plot_one_traj_1D(plot_handle, traj, time_vec, sys_info, line_style_ind, plot_info)

% (C) M. Zhong

for k = 1 : sys_info.K
  ind     = sys_info.type_info == k;
  if line_style_ind ~= 3, agents_traj = traj(ind, :); else, agents_traj = [traj(ind, :), NaN * ones(nnz(ind), plot_info.c_len)]; end
  plot(plot_handle, time_vec, agents_traj, 'LineWidth', plot_info.traj_line_width, 'Color', plot_info.type_colors{k}, ...
    'LineStyle', plot_info.line_styles{line_style_ind});
  if k == 1, hold on; end
end
end