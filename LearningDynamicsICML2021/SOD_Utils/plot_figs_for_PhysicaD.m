function plot_figs_for_PhysicaD()
% function plot_figs_for_PhysicaD()

% (C) M. Zhong

DynNames                      = {'OpinionDynamicsDisc', 'CuckerSmaleDynamics', ...
                                 'FishSchoolDynamics3D', 'FishSchoolDynamics2D', ...
                                 'Gravitation'};
timeStamps                    = {'20200309T140957', '20200309T161158', ...
                                 '20200310T110912', '20200310T224042', ...
                                 '20200311T213838'};
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                                               
for idx = 5 : length(DynNames)
  total_time                  = tic;
  name                        = DynNames{idx};
  fprintf('\nLoading %s...', name);
  time                        = timeStamps{idx};
  file_name                   = sprintf('%s/%s_%s_sharedVars.mat', SAVE_DIR, name, time);
  load(file_name, 'learn_info', 'obs_info', 'plot_info', 'solver_info', 'sys_info', ...
    'sys_info_Ntransfer');
  learn_info.SAVE_DIR         = SAVE_DIR;
  obs_info.SAVE_DIR           = SAVE_DIR;
  plot_info.SAVE_DIR          = SAVE_DIR;
  n_trials                    = 10;
  learningOutput              = cell(1, n_trials);
  for trial_idx = 1 : n_trials
    load_time                 = tic;
    fprintf('\n\tLoading %2d-th learn out...', trial_idx);
    file_name                 = sprintf('%s/%s_%s_%dth_trial_learningOutput.mat', SAVE_DIR, name, ...
                                time, trial_idx);
    load(file_name, 'learn_out');
    learningOutput{trial_idx} = learn_out;
    fprintf('done (%6.2f seconds)', toc(load_time));
  end
  final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, ...
    learn_info, plot_info);  
  fprintf('\nDone (%6.2f seconds)', toc(total_time));
%  pause;
end
end