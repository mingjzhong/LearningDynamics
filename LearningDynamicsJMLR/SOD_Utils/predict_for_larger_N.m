function predict_for_larger_N( learningOutput,sys_info, obs_info, learn_info, plot_info )
% function predict_for_larger_N( learningOutput,sys_info, obs_info, learn_info, plot_info )

% (c) M. Zhong

% predict for larger N
n_trials  = length(learningOutput);
trial_ind = randi(n_trials, 1);
result    = restructure_sys_info_for_larger_N(learn_info.N_ratio, sys_info, learningOutput{trial_ind}.syshatsmooth_info);
sys_info1 = result.sys_info;
sys_info2 = result.syshat_info;
y_init    = sys_info1.mu0();
result    = construct_and_compute_traj(plot_info.solver_info, sys_info1, sys_info2, y_init, obs_info.T_L, obs_info.L_test);
fprintf('------------------- Predict for Larger N = %3d\n', sys_info1.N);
trajs{1}  = result.traj_true;
trajs{2}  = result.traj_hat;
time_vec  = result.time_vec;
fprintf('Randomly Picked Initial Condition 1\n');
fprintf('  sup-norm on [%10.4e,%10.4e] = %10.4e.\n', 0,            obs_info.T_L,                       result.trajErr);
fprintf('  sup-norm on [%10.4e,%10.4e] = %10.4e.\n', obs_info.T_L, plot_info.solver_info.time_span(2), result.trajErrfut);
% pick another initial condition
y_init    = sys_info1.mu0();
result    = construct_and_compute_traj(plot_info.solver_info, sys_info1, sys_info2, y_init, obs_info.T_L, obs_info.L_test);
trajs{3}  = result.traj_true;
trajs{4}  = result.traj_hat;
fprintf('Randomly Picked Initial Condition 2\n');
fprintf('  sup-norm on [%10.4e,%10.4e] = %10.4e.\n', 0,            obs_info.T_L,                       result.trajErr);
fprintf('  sup-norm on [%10.4e,%10.4e] = %10.4e.\n', obs_info.T_L, plot_info.solver_info.time_span(2), result.trajErrfut);
plot_info.for_larger_N = true;
% put the trajectories on one single window for comparison
switch sys_info.d
  case 1
    visualize_traj_1D(trajs, time_vec, sys_info1, obs_info, plot_info);
  case 2
    visualize_traj_2D(trajs, time_vec, sys_info1, obs_info, plot_info);
  case 3
    visualize_traj_3D(trajs, time_vec, sys_info1, obs_info, plot_info);
  otherwise
end
% Measure the performance in terms of errors on trajectories from new initial conditions
y_init_new              = generateICs( obs_info.M_test, sys_info1 );                                              
CTA_result              = computeTrajectoryAccuracy( sys_info1, sys_info2, plot_info.solver_info, obs_info, y_init_new ); 
fprintf(['\n------------------- Trajectory accuracies, Large N data:' ...
  '\n\tsup-norm  on [%10.4e,%10.4e]=%10.4e%c%10.4e' ...
  '\n\tsup-norm  on [%10.4e,%10.4e]=%10.4e%c%10.4e'], ...
  0,            obs_info.T_L,                       mean(cellfun(@(x) mean(CTA_result.trajErr.sup),    learningOutput)), 177, std(cellfun(@(x) mean(CTA_result.trajErr.sup),    learningOutput)), ...
  obs_info.T_L, plot_info.solver_info.time_span(2), mean(cellfun(@(x) mean(CTA_result.trajErr.sup_fut),learningOutput)), 177, std(cellfun(@(x) mean(CTA_result.trajErr.sup_fut),learningOutput)));
end