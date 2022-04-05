%
% RunExamples for the main cases
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, save_path = getenv('USERPROFILE'); 
else,    save_path = getenv('HOME'); end       
% Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like  
SAVE_DIR                                     = [save_path, filesep, 'DataAnalyses', filesep, ...
                                                'LearningDynamics'];
VERBOSE                                      = 1;                                                   % indicator to print certain output
time_stamp                                   = datestr(now, 30);
if ~exist('Params','var'), Params = []; end
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
Examples                                     = LoadExampleDefinitions(choice);
ExampleIdx                                   = SelectExample(Params, Examples);

%% Get example parameters
Example                                      = Examples{ExampleIdx};
sys_info                                     = Example.sys_info;
solver_info                                  = Example.solver_info;
obs_info                                     = Example.obs_info;                                    % move n to learn_info
learn_info                                   = Example.learn_info;
plot_info                                    = Example.plot_info;

%% Some fine-tuning of learning parameters
% reuse_rho_T                                = false;
learn_info.sys_info                          = sys_info;
sys_info_Ntransfer                           = [];
learn_info.N_ratio                           = 2;
to_Ntransfer                                 = input('Perform transfer learning? (Y/N): ', 's');
switch to_Ntransfer
  case {'Y', 'y'}
    learn_info.to_predict_LN                 = true;
  case {'N', 'n'}
    learn_info.to_predict_LN                 = false;
  otherwise
    fprintf('\nInvalid input, defult to no transfer learning!!');
    learn_info.to_predict_LN                 = false;
end
if isfield(learn_info, 'to_predict_LN') && learn_info.to_predict_LN
  obs_info.N_ratio                           = learn_info.N_ratio;
  sys_info_Ntransfer                         = restructure_sys_info_for_larger_N(learn_info.N_ratio, ...
                                               sys_info);
end
n_trials                                     = input('Choose the number of learning trials (1 - 10): ');
if fix(n_trials) ~= n_trials || n_trials < 1 || n_trials > 10
  fprintf('\nDefault to 1 learning trial!!');
  n_trials                                   = 1;                                                   % Number of learning rounds
end
learn_info.to_predict_LN                     = false;
learn_info.is_parallel                       = true;                                        
learn_info.VERBOSE                           = VERBOSE;
learn_info.MEMORY_LEAN                       = true;
learn_info.SAVE_DIR                          = SAVE_DIR;
learn_info.time_stamp                        = time_stamp;
obs_info.compute_pICs                        = false;
obs_info.VERBOSE                             = VERBOSE;
obs_info.SAVE_DIR                            = SAVE_DIR;
obs_info.time_stamp                          = time_stamp;
plot_info.time_stamp                         = time_stamp;
plot_info.make_movie                         = false;
plot_info.SAVE_DIR                           = SAVE_DIR;
obs_info.pd_file_form                        = '%s/%s_%s_m%d_PD.mat';
obs_info.obs_noise                           = 0.0;
if obs_info.obs_noise>0
  obs_info.use_derivative                    = true;
end

%% Start parallel pool
if learn_info.is_parallel
  time_out                                   = 60;
  num_workers                                = feature('numcores');                                 % actual physical cores
  if ~isempty(gcp('nocreate')), delete(gcp('nocreate')); end
  pool                                       = parpool('local', num_workers, 'IdleTimeout', time_out);
  fprintf('\nThere are %d workers in the pool.', pool.NumWorkers);
  fprintf('\nThe idel timeout is %d minutes.',   pool.IdleTimeout);
end

%% Generate \rho^L_T if needed
fprintf('\n================================================================================');
fprintf('\nGenerating rhoT......');
rhoLT_timings                                = tic;
if obs_info.M_rhoT < 2 * obs_info.M                                                                 % making sure we have enough samples from generating rhoT
  obs_info.M_rhoT                            = 2 * obs_info.M;
end
[obs_info.rhoLT, obs_info.rhoLT_data]        = generateRhoLT(sys_info, solver_info, obs_info);
rhoLT_timings                                = toc(rhoLT_timings);
fprintf('done (%.2f sec).', rhoLT_timings);

%% Perform learning on trajectory data
overall_time                                 = tic;
learningOutput                               = cell(1, n_trials);
fprintf('\n================================================================================');
for k = 1 : n_trials
%% Learn the interactions  
  Timings.learn                              = tic;
  fprintf('\n------------------- Learning Interaction Laws with trial ID#: %3d', k);
  [obs_data, obs_data_new]                   = get_training_data_from_rhoLT(obs_info.rhoLT_data, ...
                                               obs_info.M);                                         % split the rhoLT data
  learn_out                                  = learningRoutine(solver_info, obs_info, learn_info, ...
                                               obs_data);                                           % Learning
  learn_out.Timings.learn                    = toc(Timings.learn);
  fprintf('\n------------------- Time for learning: %.2f', learn_out.Timings.learn);

%% Test the performance on phi_hats (and regularized phi_hats)
  fprintf('\n================================================================================');
  fprintf('\n------------------- L2(rho_T) Error with trial ID#: %3d', k);
  learn_out.Timings.L2rhoTErr                = tic;
  learn_out.L2rhoTErr                        = computeL2rhoTErr(learn_out.Estimator, ...
                                               sys_info, obs_info);
  learn_out.Timings.L2rhoTErr                = toc(learn_out.Timings.L2rhoTErr);
  fprintf('\n------------------- Time for L2(rho_T) Error: %.2f', learn_out.Timings.L2rhoTErr)
  
%% Test performance on trajectories
  fprintf('\n================================================================================');
  fprintf('\n------------------- Trajectory Error with trial ID#: %3d', k);  
  learn_out.Timings.estimateTrajAccuracies   = tic;
  if isfield(sys_info, 'LC_type') && ~isempty(sys_info.LC_type)
    find_LC                                  = true; 
  else
    find_LC                                  = false; 
  end
  [learn_out.trajErr, learn_out.trajErr_new, learn_out.trajErr_Ntransfer, ...
    learn_out.syshat_info_Ntransfer]         = estimateTrajAccuracies(sys_info, ...
                                               learn_out.syshatsmooth_info, sys_info_Ntransfer, ...
                                               obs_data.y, obs_data_new.y, ...
                                               obs_info, solver_info, find_LC);                     % Testing performance on trajectories
  learn_out.Timings.estimateTrajAccuracies   = toc(learn_out.Timings.estimateTrajAccuracies);
  fprintf('\n------------------- Time for Trajectory Error: %.2f', ...
    learn_out.Timings.estimateTrajAccuracies);
  
%% Test pattern indicators
  if isfield(sys_info, 'LC_type') && ~isempty(sys_info.LC_type)
    fprintf('\n================================================================================');
    fprintf('\n------------------- Confusion Matrix and Pattern Indicator Scores with trial ID#: %3d', k);
    learn_out.Timings.estimatePattIndicators = tic;
    learn_out.patternIndicatorScores         = computePatternIndicatorScores(learn_out, ...
                                               sys_info, sys_info_Ntransfer);                       % Testing performance on predicting limit cycles
    learn_out.Timings.estimatePattIndicators = toc(learn_out.Timings.estimatePattIndicators);
    fprintf('\n------------------- Time for Pattern Indicators: %.2f', ...
      learn_out.Timings.estimatePattIndicators);
  end
  
%% save the learning output and obs_data separate
  save_file                                  = sprintf('%s/%s_%s_%dth_trial_learningOutput.mat', ...
                                               SAVE_DIR, sys_info.name, time_stamp, k);
  save(save_file, '-v7.3', 'learn_out');
  save_file                                  = sprintf('%s/%s_%s_%dth_trial_traj.mat', ...
                                               SAVE_DIR, sys_info.name, time_stamp, k);
  save(save_file, '-v7.3', 'obs_data');                                          
  learningOutput{k}                          = learn_out;
end
fprintf('\n------------------- Overall Learning Time is: %.2f', toc(overall_time));

%% save the shared quantitives
save_file                                    = sprintf('%s/%s_%s_sharedVars.mat', SAVE_DIR, ...
                                               sys_info.name, time_stamp);
save(save_file, '-v7.3', 'sys_info', 'solver_info', 'obs_info', 'learn_info', 'plot_info', ...
  'sys_info_Ntransfer', 'SAVE_DIR', 'VERBOSE');

%% Display & figures
if VERBOSE >= 1
  final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, ...
    learn_info, plot_info);
end

%% Done
fprintf('\ndone.\n');
return
