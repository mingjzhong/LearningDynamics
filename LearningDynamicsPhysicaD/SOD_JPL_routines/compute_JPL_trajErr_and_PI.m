% function compute_JPL_trajErr_and_PI()
% function compute_JPL_trajErr_and_PI()

% (C) M. Zhong

kind  = 2;
switch kind
  case 1
    if ispc
      SAVE_DIR              = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\main_tests']; 
      dir_div               = '\';
    else
      SAVE_DIR              = [getenv('HOME'), '/DataAnalyses/LearningDynamics/main_tests']; 
      dir_div               = '/';
    end
    dyn_files               = {'EIH', 'Newton', 'CubicLD100trained', 'CubicLD200trained', ...
                               'CubicLD300trained', 'CubicLD400trained'};
  case 2
    if ispc
      SAVE_DIR              = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\optimal_n_tests']; 
      dir_div               = '\';
    else
      SAVE_DIR              = [getenv('HOME'), '/DataAnalyses/LearningDynamics/optimal_n_tests']; 
      dir_div               = '/';
    end
    dyn_files               = {'LD_d130', 'LD_d140', 'LD_d150', 'LD_d230', 'LD_d240', 'LD_d250', ...
                               'LD_d330', 'LD_d340', 'LD_d350'};    
  otherwise
end
mat_files                   = cell(size(dyn_files));
learningOutput              = cell(size(dyn_files));
trajhats                    = cell(size(dyn_files));
for idx = 1 : length(dyn_files)
  mat_files{idx}            = [SAVE_DIR, dir_div, dyn_files{idx}, '_400years.mat'];
end
load_time                   = tic;
selection_idx               = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                       
total_num_years             = 400;                                                                      
num_years                   = 400;                                                                      
data_kind                   = 2;                                                                        
use_v                       = true; 
[Example, obs_data]         = Gravitation_JPL_def(selection_idx, num_years, total_num_years, ...
                              use_v, data_kind);
sys_info                    = Example.sys_info;
for idx = 1 : length(dyn_files)
  load(mat_files{idx}, 'learn_out');  
  learningOutput{idx}       = learn_out;
end
fprintf('\nIt takes %.2f secs to load.', toc(load_time));
block                       = sys_info.N * sys_info.d;
t_day                       = obs_data.day_vec_fut;
traj                        = obs_data.y_fut;
clear obs_data Example
dyn_eval_time               = tic;
for idx = 1 : length(dyn_files)
  trajhats{idx}             = dense_output(learningOutput{idx}.dynamicshat, t_day);
end
clear learningOutput
fprintf('\nIt takes %.2f secs to evaluate the dynamics.', toc(dyn_eval_time));
test_years                  = [100, 200, 300, 400];
total_years                 = 1600 : 1999;
PIs                         = cell(length(dyn_files), length(test_years));
PRErr                       = cell(length(dyn_files), length(test_years));
trajErr                     = cell(length(dyn_files), length(test_years));
trajErr_JPL                 = cell(length(dyn_files), length(test_years));
agent_info                  = getAgentInfo(sys_info);
for idx1 = 8 : length(dyn_files)
  for idx2 = 1 : length(test_years)
    fprintf('\nWorking on %17s with %3d years of data.', dyn_files{idx1}, test_years(idx2));
    years                   = total_years(1 : test_years(idx2));
    days                    = get_num_days_from_years(years);
    time_vec                = get_time_vec_from_days(days, 'daily');    
    trajhat                 = trajhats{idx1}(:, time_vec + 1);
    trajErr{idx1, idx2}     = traj_norm(traj(:, time_vec + 1),     trajhat, sys_info, agent_info);
    trajErr_JPL{idx1, idx2} = traj_norm_JPL(traj(:, time_vec + 1), trajhat, sys_info);
    PIs{idx1, idx2}         = get_JPL_planet_information_over_time(trajhat(1 : block, :), ...
                              time_vec, sys_info);
    PRErr{idx1, idx2}       = get_precession_rate_error(sys_info.PI, PIs{idx1, idx2});
  end
end
return