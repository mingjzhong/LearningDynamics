%
% RunExamples for the main cases
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                         % Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like                           
VERBOSE                        = 1;                                                                 % indicator to print certain output
time_stamp                     = datestr(now, 30);
if ~exist('Params','var'), Params = []; end
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
selection_idx                  = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                   % index from each AO in the solar system, from 1 = Sun to 9 = Neptune
total_num_years                = 100;                                                               % total number of years of data, integer value
num_years                      = 100;                                                               % number of years of data for learning
data_kind                      = 4;                                                                 % use either daily or houly data
use_v                          = true;                                                              % use true velocity or not
[Example, obs_data]            = Gravitation_JPL_def(selection_idx, num_years, total_num_years, ...
                                 use_v, data_kind);

%% Get example parameters
sys_info                       = Example.sys_info;
solver_info                    = Example.solver_info;
obs_info                       = Example.obs_info;                                                         
learn_info                     = Example.learn_info;
plot_info                      = Example.plot_info;
Example                        = [];                     

%% Some fine-tuning of learning parameters
learn_info.VERBOSE             = VERBOSE;
learn_info.SAVE_DIR            = SAVE_DIR;
learn_info.pd_file_form        = '%s/%s_%s_CPU%d_%d_PD.mat';
learn_info.time_stamp          = time_stamp;
learn_info.use_gpu             = false;
learn_info.break_L             = true;                                                              % indicator to break a very long trajectory into smaller ones
time_type                      = get_JPL_time_type(data_kind);
if learn_info.break_L
  learn_info.M                 = get_M_in_breaking_L(length(obs_data.time_vec), time_type);
  learn_info.is_parallel       = true;                                                              % turn on the parallel solve for learning matrix
else
  learn_info.is_parallel       = false;
end
obs_info.compute_pICs          = false;
obs_info.VERBOSE               = VERBOSE;
obs_info.SAVE_DIR              = SAVE_DIR;
obs_info.time_stamp            = time_stamp;
obs_info.pd_file_form          = '%s/%s_%s_CPU%d_%d_PD.mat';
plot_info.time_stamp           = time_stamp;
plot_info.make_movie           = false;
plot_info.SAVE_DIR             = SAVE_DIR;
sys_info_Ntransfer             = [];
% use at least 50 basis functions, due to the amount of data and accuracy of approximated derivative
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    learn_info.Ebasis_info{k1, k2}.n = 52;
  end
end

%% Start parallel pool
if learn_info.is_parallel
  time_out                             = 90;
  num_workers                          = feature('numcores');                                       % actual physical cores
  pool                                 = gcp('nocreate');
  if isempty(pool)
    pool                               = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                                         'SpmdEnabled', true);
  else
    if pool.NumWorkers ~= num_workers || pool.IdleTimeout ~= time_out || ~pool.SpmdEnabled
      pool                             = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                                         'SpmdEnabled', true);  
    end
  end
  fprintf('\nThere are %d workers in the pool.', pool.NumWorkers);
  fprintf('\nThe idel timeout is %d minutes.',   pool.IdleTimeout);
  fprintf('\nSPMD is enabled?: %s.',             mat2str(pool.SpmdEnabled));
end

% split the data into short trajectories of one day
test_time                      = tic;
fprintf('\nTesting partial observation');
Ns                             = [8, 9];
[all_x, all_v, ~, all_dot_xv]  = split_observation(obs_data, obs_info, sys_info, false);
obs_data.y                     = [];
[x_train, v_train, dot_xv_train, time_vec_train, x_test, v_test, dot_xv_test, time_vec_test] ...
                               = get_cross_validation_data(all_x, all_v, all_dot_xv, num_years, ...
                                 time_type);
M1                             = get_M_in_breaking_L(length(time_vec_train), time_type);   
M2                             = get_M_in_breaking_L(length(time_vec_test),  time_type); 
all_x                          = [];
all_v                          = [];
all_dot_xv                     = [];
trajErr                        = cell(1, length(Ns));
empiErr                        = cell(1, length(Ns));
L2rhoTErr                      = cell(1, length(Ns));
Estimator                      = cell(1, length(Ns));
% theta                          = cell(1, length(Ns));
% IndicErr                       = cell(1, length(Ns));
base_num                       = 2;
learn_info                     = set_n_in_learn_info_JPL(M1, time_type, base_num, learn_info);
for idx = 1 : length(Ns)
  theN                         = Ns(idx);
  ind                          = 1 : theN * sys_info.d;
  fprintf('\nTesting with %2d agents.', theN);
  [sys_info_PO, learn_info_PO] = get_partial_info(sys_info, learn_info, theN);
  learn_info_PO.M              = M1;
  [x_l, v_l, ~, dot_xv_l, ~, ts_l] ...
                               = split_observation_in_L(x_train(ind, :), v_train(ind, :), [], ...
                                 dot_xv_train(ind, :), [], time_vec_train, learn_info_PO);
  learn_info_PO.M              = M2;                            
  [x_t, v_t, ~, ~, ~, ts_t]    = split_observation_in_L(x_test(ind, :), v_test(ind, :), [], [], [], ...
                                 time_vec_test, learn_info_PO);
  M_max                        = size(x_l, 3);
  num_trials                   = floor(log(M_max)/log(base_num)) + 1;
  if num_trials > 14
    num_trials                 = 14;
  end
  end_ind                      = num_trials - 1;
  start_ind                    = end_ind - 5;
  if start_ind < 0, start_ind = 0; end
  Ms                           = base_num.^(start_ind : end_ind);
  num_digit                    = floor(log(Ms(end))/log(10)) + 1;
  trajErrs                     = cell(num_trials, 2);
  empiErrs                     = cell(num_trials, 2);
  L2rhoTErrs                   = cell(num_trials, 2);
  Estimators                   = cell(num_trials, 2);
  fprintf('\nTesting with increasing number of days');
  for trial_idx = 1 : length(Ms)
    M                          = Ms(trial_idx);
    fprintf(['\n\tTesting with %' num2str(num_digit) 'd days'], M);
    for idx2 = 1 : 2
      if idx2 == 1
        ind                    = 1 : M;                                                             % continuous samples
        test_type              = 'continuous';
      else
        ind                    = randi(M_max, 1, M);                                                % randomly chosen samples
        test_type              = 'random';
      end
      fprintf('\n\tTeseting with %10s kind of days', test_type);
      [Estimators{idx2, trial_idx}, empiErrs{idx2, trial_idx}, L2rhoTErrs{idx2, trial_idx}, trajErrs{idx2, trial_idx}] ...
                               = get_JPL_PO_errors(solver_info, sys_info_PO, learn_info_PO, ...
                                 x_l(:, :, ind), v_l(:, :, ind), dot_xv_l(:, :, ind), ts_l, ...
                                 x_t(:, :, ind), v_t(:, :, ind), ts_t);    
    end
  end
  trajErr{idx}                 = trajErrs;
  empiErr{idx}                 = empiErrs;
  L2rhoTErr{idx}               = L2rhoTErrs;
  Estimator{idx}               = Estimators; 
%   fprintf('\nCalculating prediction error');
%   dasy                         = 365 * 2;
%   day_vec                      = 0 : (days - 1);
%   xNs_ind                      = 1 : theN * sys_info.d;
%   xNp1_ind                     = theN * sys_info.d + 1 : (theN + 1) * sys_info.d;
%   dot_vNs_trajind              = get_JPL_dot_xv_ind_in_traj(days, time_type);
%   thetas{idx}                  = get_JPL_PO_error(obs_data.y_fut(xNs_ind, day_vec + 1), ...
%                                  dot_xv_train(xNs_ind, dot_vNs_trajind), ...
%                                  obs_data.y_fut(xNp1_ind, day_vec + 1), Estimator.phiEhatsmooth);   
%   ind                          = [1 : theN * sys_info.d, sys_info.N * sys_info.d + 1 : ...
%                                  sys_info.N * sys_info.d + theN * sys_info.d];
%   IndicErrs{idx}               = get_JPL_PO_indicator_error(solver_info, sys_info_PO, day_vec, ...
%                                  obs_data.y_fut(ind, day_vec + 1), Estimator.phiEhatsmooth);
end
fprintf('\nIt takes %6.2f seconds.', toc(test_time));
return
