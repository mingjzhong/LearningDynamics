% function show_orbit_information()
% function show_orbit_information()

% (C) M. Zhong

if ispc
  SAVE_DIR                   = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
  dir_div                    = '\';
else
  SAVE_DIR                   = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; 
  dir_div                    = '/';
end
file_names                   = cell(1, 3);
learningOutput               = cell(1, 3);
trajs                        = cell(1, 4);
dyn_files                    = {'EIH', 'CubicLD', 'Newton'};
for idx = 1 : length(dyn_files)
  file_names{idx}            = [SAVE_DIR, dir_div, dyn_files{idx}, '_400years.mat'];
end
load(file_names{1}, 'sys_info', 'obs_data', 'learn_out');
learningOutput{1}            = learn_out;
for idx = 2 : length(dyn_files)
  load(file_names{idx}, 'learn_out');
  learningOutput{idx}        = learn_out;
end
block                        = sys_info.N * sys_info.d;
trajs{1}                     = obs_data.y_fut(1 : block, :);
for idx = 1 : length(dyn_files)
  traj                       = dense_output(learningOutput{idx}.dynamicshat, obs_data.day_vec_fut);
  trajs{idx + 1}             = traj(1 : block, :);
end
t_day                        = obs_data.day_vec_fut;
clear obs_data
N                            = 10;
day_vec                      = get_time_vec_from_years(400);
r_days                       = cell(9, 4);      
thetas_s                     = cell(9, 4);
ts_s                         = cell(9, 4);
PIs                          = cell(9, 4);
dyn_names                    = {'Observed', 'EIH', 'CubicLD', 'Newton'};
num_minutes                  = (t_day(end) + 1) * 24 * 60;
t_min                        = (0 : (num_minutes - 1))/(24 * 60);
for idx1 = 2 : N 
  ind1                       = (idx1 - 1) * sys_info.d + 1;
  ind2                       = idx1       * sys_info.d;
  for idx2 = 1 : 4
    fprintf('\nFor %8s dynamics on %8s:', dyn_names{idx2}, sys_info.AO_names{idx1});
    if ~strcmp(sys_info.AO_names{idx1}, 'Moon')
      rvec_day               = trajs{idx2}(ind1 : ind2, :) - trajs{idx2}(1 : sys_info.d, :);
    else
      rvec_day               = trajs{idx2}(ind1 : ind2, :) - trajs{idx2}((3 * sys_info.d + 1) : ...
                               (4 * sys_info.d), :);
    end 
    r_day                    = sum(rvec_day.^2).^(0.5);
    r_spline                 = spline(t_day, rvec_day);
    rvec_min                 = ppval(r_spline, t_min);
    r_min                    = sum(rvec_min.^2).^(0.5);
    if strcmp(sys_info.AO_names{idx1}, 'Neptune'), is_Neptune = true; else, is_Neptune = false; end
    [PI, ts, thetas]         = get_JPL_PI_from_findpeaks(t_min, r_min, r_spline, is_Neptune);
    fprintf('\n\tAphelion   is: %10.4e%c%10.4e.', PI(1, 1), 177, PI(1, 2));
    fprintf('\n\tPerihelion is: %10.4e%c%10.4e.', PI(2, 1), 177, PI(2, 2));
    fprintf('\n\tPeriod     is: %10.4e%c%10.4e.', PI(3, 1), 177, PI(3, 2));
    PIs{idx1 - 1, idx2}      = PI;
    ts_s{idx1 - 1, idx2}     = ts;
    thetas_s{idx1 - 1, idx2} = thetas;
    r_days{idx1 - 1, idx2}   = r_day;
  end
end
return