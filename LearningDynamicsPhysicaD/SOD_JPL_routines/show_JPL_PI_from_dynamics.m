% function show_PI_from_dynamics(sys_info, obs_data, learn_out)
% function show_PI_from_dynamics(sys_info, obs_data, learn_out)

% (C) M. Zhong

if ispc
  SAVE_DIR            = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
  dir_div             = '\';
else
  SAVE_DIR            = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; 
  dir_div             = '/';
end
file_names            = cell(1, 3);
learningOutput        = cell(1, 3);
trajhatfut            = cell(1, 3);
dyn_files             = {'EIH', 'CubicLD', 'Newton'};
for idx = 1 : length(dyn_files)
  file_names{idx}     = [SAVE_DIR, dir_div, dyn_files{idx}, '_400years.mat'];
end
load(file_names{1}, 'sys_info', 'obs_data', 'learn_out');
learningOutput{1}     = learn_out;
for idx = 2 : length(dyn_files)
  load(file_names{idx}, 'learn_out');
  learningOutput{idx} = learn_out;
end
block                 = sys_info.N * sys_info.d;
trajfut               = obs_data.y_fut;
for idx = 1 : length(dyn_files)
  trajhatfut{idx}     = dense_output(learningOutput{idx}.dynamicshat, obs_data.day_vec_fut);
end
test_years            = [100, 200, 300, 400];
PIs                   = zeros(4, length(test_years), sys_info.N - 1, 4);
for idx1 = 1 : length(test_years)
  day_vec             = get_time_vec_from_years(test_years(idx1));
  traj_ind            = day_vec + 1;
  traj                = trajfut(1 : block, traj_ind);
  PI                  = get_JPL_planet_information_over_time(traj, day_vec, sys_info);
  PIs(1, idx1, :, :)  = PI;
  print_msg           = sprintf('From %8s trajectory over %d years.',  'NASA JPL', test_years(idx1));  
  print_JPL_PI(print_msg, sys_info.AO_names(2 : end), PI)
  for idx2 = 1 : length(dyn_files)
    traj              = trajhatfut{idx2}(1 : block, traj_ind);
    PI                = get_JPL_planet_information_over_time(traj, day_vec, sys_info);
    PIs(idx2 + 1, idx1, :, :) = PI;
    print_msg         = sprintf('From %7s trajectory over %d years.',  dyn_files{idx2}, ...
                        test_years(idx1));
    print_JPL_PI(print_msg, sys_info.AO_names(2 : end), PI) 
  end
end
% end