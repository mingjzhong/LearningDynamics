function output = LearnAndComputeTrajectoryErr(obs_info, solver_info, learn_info, obs_data)
% function output = LearnAndComputeTrajectoryErr(obs_info, solver_info, learn_info, obs_data)

% (c) M. Zhong

% learn an estimator and regularize it
learn_time             = tic;
if learn_info.sys_info.ode_order == 1
  ode_sym              = '1st order';
elseif learn_info.sys_info.ode_order == 2
  ode_sym              = '2nd order';
end
fprintf(['\nLearning Interactions as if ' ode_sym ' system......']);
learn_out              = learn_from_dynamics(learn_info.sys_info, obs_info, learn_info, obs_data);   
[learn_out.Estimator.phiEhatsmooth, learn_out.Estimator.Ebasissmooth] ...
= regularizeInfluenceFunction(learn_out.Estimator.phiEhat, learn_out.Estimator.Ebasis);
fprintf('done (%.2f secs).', toc(learn_time));
fprintf('\nThe empirical error from learning phis on x/v is: %10.4e.', learn_out.Estimator.emp_err);
fprintf('\nComputing trajectory errors...');
run_time               = tic;
syshatsmooth_info      = learn_info.sys_info;
syshatsmooth_info.phiE = learn_out.Estimator.phiEhatsmooth;
traj                   = obs_data.x;
M                      = size(traj, 3);
trajhat                = zeros(size(traj));
failtrajest            = zeros(1,M,'logical');
parfor m = 1 : M
  dynamicshat          = self_organized_dynamics(obs_data.ICs(:, m), syshatsmooth_info, solver_info);
  failtrajest(m)       = dynamicshat.flag;
  if failtrajest(m), continue; end
  trajhat(:, :, m)     = observe_dynamics(dynamicshat, obs_info);
end
if sum(failtrajest) > 0
  fprintf('\n\t Failed simulations with estimated system: %d/%d',sum(failtrajest),M);
end
% erase the failed trajectories
traj(:, :,    failtrajest) = [];
trajhat(:, :, failtrajest) = [];
M                          = size(traj, 3);
trajErr                    = zeros(M, 1);
parfor m = 1 : M
  trajErr(m)               = traj_norm(traj(:,:,m), trajhat(:,:,m), 'Time-Maxed', learn_info.sys_info);
end
fprintf('done (%.2f secs).', toc(run_time));
fprintf(['\n------------------- Trajectory accuracies, same IC''s as training data, (%s):' ...
'\n\tsup-norm  on [%10.4e,%10.4e]=%10.4e%c%10.4e'], ode_sym, 0, obs_info.T_L, mean(trajErr), 177, std(trajErr));
% package the data
output.learn_out       = learn_out;
output.trajErr         = trajErr;
end