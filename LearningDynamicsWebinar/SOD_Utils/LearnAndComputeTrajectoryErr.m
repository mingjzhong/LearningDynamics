function output = LearnAndComputeTrajectoryErr(obs_info, solver_info, learn_info, obs_data)
% function output = LearnAndComputeTrajectoryErr(obs_info, solver_info, learn_info, obs_data)

% (c) M. Zhong

% learn an estimator and regularize it
learn_time                 = tic;
if learn_info.sys_info.ode_order == 1
  ode_sym                  = '1st order';
elseif learn_info.sys_info.ode_order == 2
  ode_sym                  = '2nd order';
end
fprintf(['\nLearning Interactions as if ' ode_sym ' system......']);
learn_out                  = learn_from_dynamics(learn_info.sys_info, obs_info, learn_info, ...
                             obs_data);   
learn_out.Estimator        = simplifyPhihats(learn_out.Estimator);
fprintf('done (%.2f secs).', toc(learn_time));
fprintf('\nThe empirical error from learning phis on x/v is: %10.4e.', learn_out.Estimator.emp_err);
fprintf('\nComputing trajectory errors...');
run_time                   = tic;
syshatsmooth_info          = learn_info.sys_info;
syshatsmooth_info.phiE     = learn_out.Estimator.phiEhatsmooth;
traj                       = obs_data.x;
M                          = size(traj, 3);
trajhat                    = zeros(size(traj));
failtrajest                = zeros(1,M,'logical');
ICs                        = obs_data.ICs;
parfor m = 1 : M
  dynamicshat              = self_organized_dynamics(ICs(:, m), syshatsmooth_info, solver_info);
  failtrajest(m)           = dynamicshat.flag;
  if failtrajest(m), continue; end
  trajhat(:, :, m)         = observe_dynamics(dynamicshat, obs_info);
end
if sum(failtrajest) > 0
  fprintf('\n\t Failed simulations with estimated system: %d/%d',sum(failtrajest),M);
end
% erase the failed trajectories
traj(:, :,    failtrajest) = [];
trajhat(:, :, failtrajest) = [];
M                          = size(traj, 3);

sys_info_guess             = learn_info.sys_info;
agent_info                 = getAgentInfo(sys_info_guess);
num_states                 = calculate_sys_states(sys_info_guess);
trajErr                    = zeros(num_states, M);
parfor m = 1 : M
  trajErr(:, m)            = traj_norm(traj(:,:,m), trajhat(:,:,m), sys_info_guess, agent_info);
end
fprintf('done (%.2f secs).', toc(run_time));
% package the data
output.learn_out           = learn_out;
output.trajErr             = trajErr(end, :);
end