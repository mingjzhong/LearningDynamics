function RunExamples_dynamics()
% RunExamples for the main cases
%
% (c) M. Zhong (JHU)

%% Set parameters
if ispc, SAVE_DIR       = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else, SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                                                      
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
Examples                = LoadExampleDefinitions('Dynamics');
ExampleIdx              = SelectExample([], Examples);

%% Get example parameters
Example                 = Examples{ExampleIdx};
sys_info                = Example.sys_info;
solver_info             = Example.solver_info;
plot_info               = Example.plot_info;
obs_info                = Example.obs_info;
plot_info.time_stamp    = datestr(now, 30);
plot_info.SAVE_DIR      = SAVE_DIR;
VERBOSE                 = 1;                                                                           % indicator to print certain output
plot_info.VERBOSE       = VERBOSE;                                                                    
plot_info.make_movie    = true;

%% Generate the dynamics
fprintf('\n================================================================================');
fprintf('\nGenerating the dynamics......');
timing                 = tic;
y_init                 = sys_info.mu0();
dynamics               = self_organized_dynamics(y_init, sys_info, solver_info);
fprintf('done (%.2f sec).', toc(timing));

%% Save
plot_info.save_file    = sprintf('%s/%s_learningOutput%s.mat', SAVE_DIR, sys_info.name, plot_info.time_stamp);
save(plot_info.save_file, '-v7.3', 'sys_info', 'solver_info', 'plot_info', 'dynamics');
%% Display & figures
if VERBOSE >= 1
  if plot_info.make_movie, plot_info.movie_name = sprintf('%s/%s_movie_%s', SAVE_DIR, sys_info.name, plot_info.time_stamp); end
  visualize_dynamics(dynamics, sys_info, solver_info, obs_info, plot_info);
end

%% Done
fprintf('\ndone.\n');
end