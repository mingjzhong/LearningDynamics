function visualize_trajs_for_PNAS(learningOutput, sys_info, chosen_dynamics, obs_info, plot_info)
% function visualize_trajs_for_PNAS(learningOutput, sys_info, sys_info_Ntransfer, obs_info, plot_info)

% (c) M. Zhong (JHU)


trajs                     = cell(1, length(chosen_dynamics));
dyn_markers               = cell(1, length(chosen_dynamics));
fine_time_vec             = linspace(obs_info.time_vec(1), plot_info.solver_info.time_span(2), 100);
fine_time_vec             = insert_time_vec(fine_time_vec, obs_info.T_L);
coarse_time_vec           = linspace(fine_time_vec(1), fine_time_vec(end), 20);
coarse_time_vec           = insert_time_vec(coarse_time_vec, obs_info.T_L);
for ind = 1 : length(chosen_dynamics)
  traj                    = deval(chosen_dynamics{ind}, fine_time_vec);
  if sys_info.ode_order == 1,     block_size = size(traj, 1);
  elseif sys_info.ode_order == 2, block_size = size(traj, 1)/2; end
  if ind == 1, y_init = traj(:, 1); end
  trajs{ind}              = traj(1 : block_size, :);
  traj                    = deval(chosen_dynamics{ind}, coarse_time_vec); 
  dyn_markers{ind}        = traj(1 : block_size, :);
end
plot_info.dyn_markers     = dyn_markers;
plot_info.coarse_time_vec = coarse_time_vec;
% put the trajectories on one single window for comparison
if sys_info.d == 1
  visualize_traj_1D(trajs, fine_time_vec, sys_info, obs_info, plot_info);  
elseif sys_info.d == 2
  plot_info.for_PNAS      = true;
  if isfield(obs_info, 'obs_noise') && obs_info.obs_noise > 0
    for m_ind = 1 : size(learningOutput{1}.obs_data.ICs, 2)
      another_y_init      = squeeze(learningOutput{1}.obs_data.ICs(:, m_ind));
      if norm(y_init - another_y_init, Inf) == 0, break; end
    end
    traj_noise             = squeeze(learningOutput{1}.obs_data.x(1 : block_size, :, m_ind));   
    visualize_traj_2D_wnoise(traj_noise, trajs{1}, trajs{2}, fine_time_vec, sys_info, obs_info, plot_info);
  else
    visualize_traj_2D(trajs, fine_time_vec, sys_info, obs_info, plot_info); 
  end
end
end