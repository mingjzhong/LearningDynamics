function traj_ind = get_JPL_traj_ind_from_preset_data(preset_time_type, days, time_type)
% function traj_ind = get_JPL_traj_ind_from_preset_data(preset_time_type, days, time_type)

% (C) M. Zhong

switch preset_time_type
  case 2
    num_samples = sum(days);
    num_skips   = {1,      [],  []};
  case 3
    num_samples = sum(days) * 24;
    num_skips   = {24,      1,  []};
  case 4 
    num_samples = sum(days) * 24 * 60;
    num_skips   = {60 * 24, 60, 1};
  otherwise
    error('');
end 
switch time_type
  case 'daily'
    traj_ind = 1 : num_skips{1} : num_samples;
  case 'hourly'
    traj_ind = 1 : num_skips{2} : num_samples;
  case 'minutely'
    traj_ind = 1 : num_skips{3} : num_samples;
  otherwise
    error('');
end
end