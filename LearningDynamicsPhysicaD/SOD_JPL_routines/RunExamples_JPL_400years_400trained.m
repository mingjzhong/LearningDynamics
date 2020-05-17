%
% Run the Example of Learning from NASA JPL's Development Ephemeris
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                         % Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like                           
VERBOSE                  = 1;                                                                       % indicator to print certain output
time_stamp               = datestr(now, 30);
if ~exist('Params','var'), Params = []; end
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
selection_idx            = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                         % index from each AO in the solar system, from 1 = Sun to 9 = Neptune
total_num_years          = 400;                                                                     % total number of years of data, integer value
num_years                = 400;                                                                     % number of years of data for learning
data_kind                = 2;                                                                       % use either daily or houly data
use_v                    = true;                                                                    % use true velocity or not
[Example, obs_data]      = Gravitation_JPL_def(selection_idx, num_years, total_num_years, use_v, ...
                           data_kind);

%% Get example parameters
sys_info                 = Example.sys_info;
solver_info              = Example.solver_info;
obs_info                 = Example.obs_info;                                                         
learn_info               = Example.learn_info;
plot_info                = Example.plot_info;

%% Some fine-tuning of learning parameters
learn_info.VERBOSE       = VERBOSE;
learn_info.SAVE_DIR      = SAVE_DIR;
learn_info.time_stamp    = time_stamp;
learn_info.pd_file_form  = '%s/%s_%s_CPU%d_%d_PD.mat';
learn_info.use_gpu       = false;
learn_info.break_L       = true;                                                                    % indicator to break a very long trajectory into smaller ones
learn_info.keep_obs_data = false;
time_type                = get_JPL_time_type(data_kind);
if learn_info.break_L    
  learn_info.M           = get_M_in_breaking_L(length(obs_data.time_vec), time_type);
  learn_info.is_parallel = true;                                                                    % turn on the parallel solve for learning matrix
else
  learn_info.is_parallel = false;
end
obs_info.compute_pICs    = false;
obs_info.VERBOSE         = VERBOSE;
obs_info.SAVE_DIR        = SAVE_DIR;
obs_info.time_stamp      = time_stamp;
obs_info.pd_file_form    = '%s/%s_%s_CPU%d_%d_PD.mat';
plot_info.time_stamp     = time_stamp;
plot_info.make_movie     = false;
plot_info.SAVE_DIR       = SAVE_DIR;
sys_info_Ntransfer       = [];

%% Start parallel pool
if learn_info.is_parallel
  time_out               = 60;
  num_workers            = feature('numcores');                                                     % actual physical cores
  pool                   = gcp('nocreate');
  if isempty(pool)
    pool                 = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                           'SpmdEnabled', true);
  else
    if pool.NumWorkers ~= num_workers || pool.IdleTimeout ~= time_out || ~pool.SpmdEnabled
      pool               = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                           'SpmdEnabled', true);  
    end
  end
  fprintf('\nThere are %d workers in the pool.', pool.NumWorkers);
  fprintf('\nThe idel timeout is %d minutes.',   pool.IdleTimeout);
  fprintf('\nSPMD is enabled?: %s.',             mat2str(pool.SpmdEnabled));
end

%% Perform learning on trajectory data
overall_time             = tic;
fprintf('\nRunning %3d years of %s data.', num_years, time_type);
degree                   = 3;
num_sub_int              = 50;
learn_info.Ebasis_info   = set_JPL_basis_info(learn_info.Ebasis_info, num_sub_int, degree);
fprintf('\nTesting: p = %d, #sub. ints. = %d', degree, num_sub_int);
fprintf('\n================================================================================');
%% Learn the interactions  
Timings.learn            = tic;
fprintf('\nLearning Interaction Laws......');
learn_info.sys_info      = sys_info;
learn_out                = learningRoutine(solver_info, obs_info, learn_info, obs_data);            % Learning
fprintf('\nThe conditional number is: %10.4e.', learn_out.Estimator.Info.ALMCond);
Timings.learn            = toc(Timings.learn);
fprintf('\n------------------- Time for Learn. Re.: %6.2f sec.', Timings.learn);
%% trajectory errors and other planet information 
fprintf('\nCalculating Trajectory Err......');
Timings.trajErr          = tic;
syshat_info              = learn_out.syshatsmooth_info;
dynamics_type            = 'Smooth estimated Phihats';
[~, ~, trajErr, dynhat]  = get_JPL_trajErr(obs_data, sys_info, solver_info, ...
                           syshat_info, num_years, total_num_years, dynamics_type);                                                    
learn_out.trajErr        = trajErr;
learn_out.dynamicshat    = dynhat;
Timings.trajErr          = toc(Timings.trajErr);
fprintf('\n------------------- Time for traj. err.: %6.2f sec.', Timings.trajErr);
learn_out.Timings        = Timings;
fprintf('\nOverall time is %6.2f sec.', toc(overall_time));
  
%% save the output
save_file                = sprintf('%s/%s_%s_allOutput.mat', SAVE_DIR, sys_info.name, time_stamp);
save(save_file, '-v7.3', 'sys_info', 'solver_info', 'obs_data', 'obs_info', 'learn_info', ...
  'plot_info', 'sys_info_Ntransfer', 'SAVE_DIR', 'VERBOSE', 'learn_out', 'num_years', ...
  'total_num_years');
%% Done
fprintf('\nDone.\n');
return