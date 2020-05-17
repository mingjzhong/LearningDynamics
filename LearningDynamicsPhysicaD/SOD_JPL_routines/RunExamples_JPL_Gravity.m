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
total_num_years          = 1;                                                                     % total number of years of data, integer value
num_years                = 1;                                                                     % number of years of data for learning
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
if data_kind < 3
  learn_info.break_L     = false;
end
time_type                = get_JPL_time_type(data_kind);
if learn_info.break_L
  learn_info.M           = get_M_in_breaking_L(length(obs_data.time_vec), time_type);
  learn_info.is_parallel = true;                                                                    % turn on the parallel solve for learning matrix
else
  learn_info.is_parallel = false;
end
num_sub_intervals        = 60;
degree                   = 1;
learn_info.Ebasis_info   = set_JPL_basis_info(learn_info.Ebasis_info, num_sub_intervals, degree);
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
  time_out               = 120;
  if isempty(gcp('nocreate'))
    num_workers          = feature('numcores');                                                     % actual physical cores
    pool                 = parpool('local', num_workers, 'IdleTimeout', time_out, 'SpmdEnabled', true);
  else
    delete(gcp('nocreate'))
    num_workers          = feature('numcores');                                                     % actual physical cores
    pool                 = parpool('local', num_workers, 'IdleTimeout', time_out, 'SpmdEnabled', true);   
  end
  fprintf('\nThere are %d workers in the pool.', pool.NumWorkers);
  fprintf('\nThe idel timeout is %d minutes.',   pool.IdleTimeout);
  fprintf('\nSPMD is enabled?: %s.',             mat2str(pool.SpmdEnabled));
end

%% Perform learning on trajectory data
overall_time             = tic;
fprintf('\n================================================================================');
%% Learn the interactions  
Timings.learn            = tic;
fprintf('\n------------------- Learning Interaction Laws');
learn_info.sys_info      = sys_info;
learn_out                = learningRoutine(solver_info, obs_info, learn_info, obs_data);            % Learning
obs_data.y               = [];
learn_out.obs_data       = [];
obs_info.rhoLT           = learn_out.Estimator.rhoLTM;

%% trajectory errors, precession rates, and errors in estimating masses
displayMassErrs({learn_out}, sys_info);
fprintf('\nCalculating Traj.     Err....');
err_time                 = tic;
[trajs, dtrajs, trajErr] = get_JPL_trajErr(obs_data, sys_info, solver_info, ...
                           learn_out.syshatsmooth_info, num_years, total_num_years);
learn_out.trajErr        = trajErr;
fprintf('\n------------------- Time for traj. err.: %6.2f sec.', toc(err_time));
fprintf('\nCalculating Precession Rates.');
RP_time                  = tic;
[PI, PIhat, test_years]  = get_JPL_planet_information(trajs, sys_info, num_years, total_num_years);
print_JPL_PI(sys_info, PI, PIhat, test_years);
learn_out.PI             = PI;
learn_out.PIhat          = PIhat;
learn_out.test_years     = test_years;
fprintf('\n------------------- Time for Prec. Rat.: %6.2f sec.', toc(RP_time));
learn_out.Timings.learn  = toc(Timings.learn);
fprintf('\n------------------- Time for learning:   %6.2f sec.', learn_out.Timings.learn);
  
%% Visualizing the results
fprintf('\n------------------- Visualizing phis and trajs');
final_visualization_JPL(obs_info, obs_data, sys_info, plot_info, learn_info, learn_out, trajs, dtrajs);

%% save the output
save_file                = sprintf('%s/%s_%s_allOutput.mat', SAVE_DIR, sys_info.name, time_stamp);
save(save_file, '-v7.3', 'sys_info', 'solver_info', 'obs_data', 'obs_info', 'learn_info', 'plot_info', ...
  'sys_info_Ntransfer', 'SAVE_DIR', 'VERBOSE', 'learn_out', 'num_years', 'total_num_years', ...
  'trajs', 'dtrajs');
%% Done
fprintf('\nDone.\n');
return