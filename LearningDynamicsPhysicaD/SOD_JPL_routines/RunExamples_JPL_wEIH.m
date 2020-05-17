%
% Run the Example of learning on JPL's Development Ephemeris with EIH acceleration
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                         % Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like                           
time_stamp                     = datestr(now, 30);
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
selection_idx                  = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                   % index from each AO in the solar system, from 1 = Sun to 9 = Neptune
total_num_years                = 400;                                                               % total number of years of data, integer value
num_years                      = 400;                                                               % number of years of data for learning
data_kind                      = 2;                                                                 % use either daily or houly data
use_v                          = true;                                                              % use true velocity or not
load_data_time                 = tic;
fprintf('\nLoading data......');
[Example, obs_data]            = Gravitation_JPL_def(selection_idx, num_years, total_num_years, ...
                                 use_v, data_kind);
fprintf('\nIt takes %6.2f secs to load the data', toc(load_data_time));

%% Get example parameters
sys_info                       = Example.sys_info;
solver_info                    = Example.solver_info;
obs_info                       = Example.obs_info;                                                         
learn_info                     = Example.learn_info;
plot_info                      = Example.plot_info;

%% Perform learning on trajectory data
overall_time                   = tic;
fprintf('\n================================================================================');

% find the EIH acceleration
option.method                  = 2;
dy_EIH                         = get_JPL_EIH_acceleration(solver_info, obs_data, option);
obs_data.dy                    = dy_EIH;                                                            % use the EIH acceleration
fprintf('\nIt takes %6.2f secs to find the daily points.', toc(EIH_eval_time));
learn_time                     = tic;
fprintf('\nLearning over 400 years with EIH acceleration');
VERBOSE                        = 1;
learn_info.VERBOSE             = VERBOSE;
learn_info.SAVE_DIR            = SAVE_DIR;
learn_info.time_stamp          = time_stamp;
learn_info.pd_file_form        = '%s/%s_%s_CPU%d_%d_PD.mat';
learn_info.use_gpu             = false;
learn_info.break_L             = true;                                                              % indicator to break a very long trajectory into smaller ones
learn_info.keep_obs_data       = false;
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

if learn_info.is_parallel
  time_out                     = 60;
  num_workers                  = feature('numcores');                                               % actual physical cores
  pool                         = gcp('nocreate');
  if isempty(pool)
    pool                       = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                                 'SpmdEnabled', true);
  else
    if pool.NumWorkers ~= num_workers || pool.IdleTimeout ~= time_out || ~pool.SpmdEnabled
      pool                     = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                                 'SpmdEnabled', true);  
    end
  end
  fprintf('\nThere are %d workers in the pool.', pool.NumWorkers);
  fprintf('\nThe idel timeout is %d minutes.',   pool.IdleTimeout);
  fprintf('\nSPMD is enabled?: %s.',             mat2str(pool.SpmdEnabled));
end
learn_info.sys_info            = sys_info;

num_sub_int                    = 50;
degree                         = 3;
learn_info.Ebasis_info         = set_JPL_basis_info(learn_info.Ebasis_info, num_sub_int, degree);
learn_out                      = learningRoutine(solver_info, obs_info, learn_info, obs_data);      % Learning
fprintf('\nIt takes %6.2f secs to learn.', toc(learn_time));
trajErr_time                   = tic;
fprintf('\nComputing Traj. Err.');
syshat_info                    = learn_out.syshatsmooth_info;
solver_info.rel_tol            = 1e-8;
solver_info.abs_tol            = 1e-11;
dynamics_type                  = 'Smoothed Phihats';
[trajhat, ~, trajErr, dyn_hat] = get_JPL_trajErr(obs_data, sys_info, solver_info, syshat_info, ...
                                 num_years, total_num_years, dynamics_type);
oneBlock                       = sys_info.N * sys_info.d;    
PI                             = get_JPL_planet_information_over_time(trajhat(1 : oneBlock, :), ...
                                 obs_data.time_vec, sys_info);                            
fprintf('\nIt takes %6.2f secs to calculate traj. err.', toc(trajErr_time));
%% save the output
save_file                      = sprintf('%s/%s_%s_EIHAcce.mat', SAVE_DIR, sys_info.name, ...
                                 time_stamp);
save(save_file, '-v7.3', 'sys_info', 'solver_info', 'obs_data', 'SAVE_DIR', 'syshat_info', ...
  'num_years', 'total_num_years', 'learn_out', 'dyn_hat', 'dyn_EIH', 'trajhat', 'PI');
%% Done
fprintf('\nDone.\n');
return
