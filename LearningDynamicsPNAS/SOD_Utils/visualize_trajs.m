function visualize_trajs(learningOutput, sys_info, sys_info_approx, obs_info, ICs, plot_info)
% function visualize_trajs(learningOutput, sys_info, sys_info_approx, obs_info, ICs, plot_info)

% (c) M. Zhong

% go through the Initial Conditions from the training data set
trajs                   = cell(1, 4);
result                  = construct_and_compute_traj(plot_info.solver_info, sys_info, sys_info_approx, obs_info, ICs);
trajs{1}                = result.traj_true;
trajs{2}                = result.traj_hat;
time_vec                = result.time_vec;
if sys_info.d == 2 
  if strcmp(sys_info.name, 'PredatorPrey1stOrder') || strcmp(sys_info.name, 'PredatorPrey1stOrderSplines') ...
      || strcmp(sys_info.name, 'PredatorPrey2ndOrder')
    if isfield(obs_info, 'obs_noise') && obs_info.obs_noise > 0 && ~plot_info.for_larger_N 
      traj_noise        = squeeze(learningOutput{1}.obs_data.x(1 : sys_info.d * sys_info.N, :, result.m));            
      visualize_traj_2D_wnoise(traj_noise, result.traj_true, result.traj_hat, time_vec, sys_info, obs_info, plot_info);
    end
  end
end
fprintf('\n================================================================================');
fprintf('\n------------------- Trajectory Error over One Initial Condition');
if ~isfield(plot_info, 'for_larger_N') || ~plot_info.for_larger_N
  fprintf('\nTraj. Err. with an initial condition taken from training data:');
  chosen_dynamics       = cell(1, 4);
  chosen_dynamics{1}    = result.dynamics;
  chosen_dynamics{2}    = result.dynamicshat;
else
  chosen_dynamics_LN    = cell(1, 4);
  chosen_dynamics_LN{1} = result.dynamics;
  chosen_dynamics_LN{2} = result.dynamicshat;  
  fprintf(' For Larger N');
  fprintf('\nTraj. Err. with an initial condition randomly chosen:');
end
fprintf('\n  sup-norm on [%10.4e,%10.4e] = %10.4e.', obs_info.time_vec(1), obs_info.T_L,                       result.trajErr);
fprintf('\n  sup-norm on [%10.4e,%10.4e] = %10.4e.', obs_info.T_L,         plot_info.solver_info.time_span(2), result.trajErrfut);
% randomly pick another initial data
if plot_info.for_larger_N
  ICs                   = ICs(:, result.m + 1 : end);
else
  if isfield(learningOutput{1}, 'y_init_new')
    ICs                 = learningOutput{1}.y_init_new;
  else
    ICs                 = generateICs(obs_info.M, sys_info);
  end
end
result                  = construct_and_compute_traj(plot_info.solver_info, sys_info, sys_info_approx, obs_info, ICs);
trajs{3}                = result.traj_true;
trajs{4}                = result.traj_hat;
if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N
  chosen_dynamics_LN{3} = result.dynamics;
  chosen_dynamics_LN{4} = result.dynamicshat;   
  fprintf('  For Larger N');
else
  chosen_dynamics{3}    = result.dynamics;
  chosen_dynamics{4}    = result.dynamicshat;  
end
fprintf('\nTraj. Err. with another initial condition randomly chosen:');
fprintf('\n  sup-norm on [%10.4e,%10.4e] = %10.4e.', obs_info.time_vec(1), obs_info.T_L,                       result.trajErr);
fprintf('\n  sup-norm on [%10.4e,%10.4e] = %10.4e.', obs_info.T_L,         plot_info.solver_info.time_span(2), result.trajErrfut);
% put the trajectories on one single window for comparison
switch sys_info.d
  case 1
    visualize_traj_1D(trajs, time_vec, sys_info, obs_info, plot_info);
  case 2
    visualize_traj_2D(trajs, time_vec, sys_info, obs_info, plot_info);
  case 3
    visualize_traj_3D(trajs, time_vec, sys_info, obs_info, plot_info);
  otherwise
end
% save the dynamics
if isfield(plot_info, 'save_file') && ~isempty(plot_info.save_file)
  if isfield(plot_info, 'for_larger_N') && plot_info.for_larger_N
    save(plot_info.save_file, '-append', 'chosen_dynamics_LN');
  else
    save(plot_info.save_file, '-append', 'chosen_dynamics');  
  end
end
