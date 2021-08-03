%
% RunExamples for the main cases
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, save_path = getenv('USERPROFILE'); 
else,    save_path = getenv('HOME'); end        
SAVE_DIR                                       = [save_path, filesep, 'DataAnalyses', filesep, ...
                                                  'LearningDynamics'];
fprintf('\nSaved data files will be read from this folder:');
fprintf('\n%s', SAVE_DIR);
if ~exist(SAVE_DIR,'dir')
  error('SOD_Utils:RunExamples_generateFigs:exception', 'File Folder not found!!'); 
end
fprintf('\n');
is_JPL                                         = input('Is the learning result generated from JPL data? [Y/N]: ', 's');
is_JPL                                         = char2bool(is_JPL);
fprintf('\nThe data files will have the following format in their names:');
if is_JPL
  fprintf('\n(dynamics name)_(time stamp)_allOutput.mat');
else
  fprintf('\n(dynamics name)_(time stamp)_sharedVars.mat');
  fprintf('\n(dynamics name)_(time stamp)_(trial id)th_trial_learningOutput.mat');
end
fprintf('\n');
dyn_name                                       = input('Enter or copy/paste the name of the dynamics: ', 's');
time_stamp                                     = input('Enter or copy/paste the time stamp:           ', 's');
make_movie                                     = input('Generate movie for trajectories? [Y/N]:       ', 's');
make_movie                                     = char2bool(make_movie);
if is_JPL
  save_file                                    = sprintf('%s/%s_%s_allOutput.mat', SAVE_DIR, dyn_name, time_stamp);
  load(save_file, 'sys_info', 'solver_info', 'obs_data', 'obs_info', 'learn_info', ...
    'learn_out', 'num_years', 'total_num_years', 'trajs', 'dtrajs', 'caseInd');    
else
  n_trials                                     = input('Enter the number of learning trials:          ');
  save_file                                    = sprintf('%s/%s_%s_sharedVars.mat', SAVE_DIR, dyn_name, time_stamp);
  load(save_file, 'obs_info', 'solver_info', 'sys_info', 'sys_info_Ntransfer', 'learn_info');
  learningOutput = cell(1, n_trials);
  for idx = 1 : n_trials
    save_file                                  = sprintf('%s/%s_%s_%dth_trial_learningOutput.mat', ...
                                                 SAVE_DIR, dyn_name, time_stamp, idx);
    load(save_file, 'learn_out');
    learningOutput{idx}                        = learn_out;
  end
end
learn_info.SAVE_DIR                            = SAVE_DIR;
obs_info.SAVE_DIR                              = SAVE_DIR;
plot_info                                      = get_plot_info(is_JPL);
plot_info.SAVE_DIR                             = SAVE_DIR;
plot_info.make_movie                           = make_movie;
plot_info.time_stamp                           = time_stamp;
if isempty(sys_info_Ntransfer)
  ratio                                        = 2;
  sys_info_Ntransfer                           = restructure_sys_info_for_larger_N(ratio, sys_info);
  learningOutput{1}.trajErr_Ntransfer.time_vec = learningOutput{1}.trajErr.time_vec;
  learningOutput{1}.trajErr_Ntransfer.y_init   = sys_info_Ntransfer.mu0();
  learningOutput{1}.syshat_info_Ntransfer      = restructure_sys_info_for_larger_N(ratio, ...
                                                 learningOutput{1}.syshatsmooth_info);
  if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold) && sys_info.on_manifold
    plot_info.use_new_ICs                      = false;
  end
end 
if is_JPL
  dynKind                                      = 'LDnp1DwJPL';
  final_visualization_JPL(obs_info, obs_data, sys_info, plot_info, learn_out, trajs, ...
    dtrajs, dynKind);  
else  
  traj_file                                    = sprintf('%s/%s_%s_trajPlot.mat', SAVE_DIR, ...
                                                 dyn_name, time_stamp);
  if exist(traj_file, 'file') == 2
    plot_info.saved_traj                       = true;
    load(traj_file, 'dtrajs', 'phases', 'time_vec', 'trajs');
    plot_info.traj_data                        = set_coarse_traj(trajs, dtrajs, phases, time_vec);
  else
    plot_info.saved_traj                       = false;
  end  
  final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, ...
    learn_info, plot_info);
end
%% Done
fprintf('\ndone.\n');
return