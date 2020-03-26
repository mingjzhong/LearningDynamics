% Run Examples for Model Selection
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; else, SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end % Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like                           
VERBOSE                         = 1;                                                                % indicator to print certain output
if ~exist('Params','var'), Params = [];     end
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
Examples                        = LoadExampleDefinitions('ModelSelection');
ExampleIdx                      = SelectExample(Params, Examples);

%% Get example parameters
Example                         = Examples{ExampleIdx};
sys_info                        = Example.sys_info;
solver_info                     = Example.solver_info;
obs_info                        = Example.obs_info;                                                 % move n to learn_info
learn_info                      = Example.learn_info;
plot_info                       = Example.plot_info;
learn_info.is_parallel          = false;                                                            % Some fine-tuning of learning parameters
learn_info.keep_obs_data        = true;
learn_info.VERBOSE              = VERBOSE;
learn_info.SAVE_DIR             = SAVE_DIR;
learn_info.MEMORY_LEAN          = true;
obs_info.compute_pICs           = false;
obs_info.VERBOSE                = VERBOSE;
obs_info.SAVE_DIR               = SAVE_DIR;
n_trials                        = 1;
learningOutput                  = cell(1, n_trials);
%% Start parallel pool
gcp
time_stamp                      = datestr(now, 30);
learn_tic = tic;
if ExampleIdx == 1 || ExampleIdx == 2
  for idx = 1 : n_trials
    fprintf('\n=========================Trial ID: %3d', idx);
    fprintf('\nGenerating %d trajectories with %d observations each...',obs_info.M,obs_info.L);
    obs_data                    =  generateObservations(sys_info, solver_info, obs_info, obs_info.M, []);
    fprintf('done (%.2f sec).',obs_data.Timings.total);
    fprintf('\n=========================Trial ID: %3d', idx);
    fprintf('\nLearning...');
    learn_time                  = tic;
    learn_out                   = learn_from_dynamics(sys_info, obs_info, learn_info, obs_data);   
    learn_out.rhoLTemp          = estimateRhoLT( obs_data, sys_info, obs_info);
    fprintf('done (%.2f sec).', toc(learn_time));
    fprintf('\nThe empirical error from learning phis on x/v is: %10.4e.', learn_out.Estimator.emp_err);  
    obs_info.rhoLT              = learn_out.rhoLTemp;  
    fprintf('\n=========================Trial ID: %3d', idx);
    fprintf('\nComputing corresponding L^2(rho^L_T) norms of estimators...');
    learn_out.L2rhoTE           = L2_rho_T_energy(learn_out.Estimator.phiEhat,    sys_info, obs_info, learn_out.Estimator.Ebasis);
    learn_out.L2rhoTA           = L2_rho_T_alignment(learn_out.Estimator.phiAhat, sys_info, obs_info, learn_out.Estimator.Abasis);
    fprintf('\nThe L^2(rho^L_T) of the learned estimator for phi^E is: %12.6e.', learn_out.L2rhoTE(1, 1));
    fprintf('\nThe L^2(rho^L_T) of the learned estimator for phi^A is: %12.6e.', learn_out.L2rhoTA(1, 1));
    learningOutput{idx}         = learn_out;
  end
  fprintf('\n=========================After %d trials', n_trials);
  fprintf('\nThe L^2(rho^L_T) of the learned estimator for phi^E is: %12.6e%c%12.6e.', mean(cellfun(@(x) x.L2rhoTE(1, 1), learningOutput)), 177, std(cellfun(@(x) x.L2rhoTE(1, 1), learningOutput)));
  fprintf('\nThe L^2(rho^L_T) of the learned estimator for phi^A is: %12.6e%c%12.6e.', mean(cellfun(@(x) x.L2rhoTA(1, 1), learningOutput)), 177, std(cellfun(@(x) x.L2rhoTA(1, 1), learningOutput)));
  plot_info.plot_name           = sprintf('%s/%s_learningOutput_%s',SAVE_DIR, sys_info.name, time_stamp);
  displayMSLearningResults(learningOutput, sys_info, plot_info);
%% Save
  save(sprintf('%s/%s_learningOutput%s.mat', SAVE_DIR, sys_info.name, time_stamp), '-v7.3', 'sys_info', 'solver_info', 'obs_info', 'learn_info', 'obs_data', 'learningOutput', 'plot_info');  
elseif ExampleIdx == 3 || ExampleIdx == 4
  for idx = 1 : n_trials
    fprintf('\n=========================Trial ID: %3d', idx);
    fprintf('\nGenerating %d trajectories with %d observations each...',obs_info.M,obs_info.L);
    if ExampleIdx == 3
      obs_info.use_derivative     = true;
    end
    obs_data                      = generateObservations(sys_info, solver_info, obs_info, obs_info.M, []);
    if ExampleIdx == 3
      xs                          = obs_data.x;
      vs                          = obs_data.xp;   
    elseif ExampleIdx == 4
      block                       = sys_info.d * sys_info.N;
      xs                          = obs_data.x(1 : block, :, :);
      vs                          = obs_data.x(block + 1 : 2 * block, :, :);
    end
    fprintf('done (%.2f sec).',obs_data.Timings.total);
  % Learn the dynamics from observations
    fprintf('\n=========================Trial ID: %3d', idx);
    fprintf('\nLearn and Compute the Trajectory Errors.');
    learn_info.sys_info           = sys_info;
    learn_info.sys_info.ode_order = 1;
    if ExampleIdx == 3
      obs_data.x                  = xs;
      obs_info.use_derivative     = false;
      obs_data.xp                 = [];
    elseif ExampleIdx == 4
      obs_data.x                  = xs;
      obs_data.ICs                = squeeze(xs(:, 1, :));
    end
    output1                       = LearnAndComputeTrajectoryErr(obs_info, solver_info, learn_info, obs_data);
    fprintf('\nLearn and Compute the Trajectory Errors.');
    learn_info.sys_info.ode_order = 2;
    obs_data.x                    = [xs; vs];
    obs_data.ICs                  = [squeeze(xs(:, 1, :)); squeeze(vs(:, 1, :))];
    output2                       = LearnAndComputeTrajectoryErr(obs_info, solver_info, learn_info, obs_data);
    learningOutput{idx}.output1st = output1;
    learningOutput{idx}.output2nd = output2;
  end
  fprintf('\n=========================After %d trials', n_trials);
  fprintf('\nTrajectory accuracies, (1st order), sup-norm on [%10.4e,%10.4e], mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e', ...
  0, obs_info.T_L, mean(cellfun(@(x) mean(x.output1st.trajErr), learningOutput)), 177, std(cellfun(@(x) mean(x.output1st.trajErr), learningOutput)), ...
  mean(cellfun(@(x) std(x.output1st.trajErr), learningOutput)), 177, std(cellfun(@(x) std(x.output1st.trajErr), learningOutput)));
  fprintf('\nTrajectory accuracies, (2nd order), sup-norm on [%10.4e,%10.4e], mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e', ...
  0, obs_info.T_L, mean(cellfun(@(x) mean(x.output2nd.trajErr), learningOutput)), 177, std(cellfun(@(x) mean(x.output2nd.trajErr), learningOutput)), ...
  mean(cellfun(@(x) std(x.output2nd.trajErr), learningOutput)), 177, std(cellfun(@(x) std(x.output2nd.trajErr), learningOutput)));
%% Save
  save(sprintf('%s/%s_learningOutput%s.mat', SAVE_DIR, sys_info.name, time_stamp), '-v7.3', 'sys_info', 'solver_info', 'obs_info', 'learn_info', 'learningOutput');
end
fprintf('\nOverall time for conducting Model Selection: %.2f',toc(learn_tic));

%% Done
fprintf('\ndone.\n');