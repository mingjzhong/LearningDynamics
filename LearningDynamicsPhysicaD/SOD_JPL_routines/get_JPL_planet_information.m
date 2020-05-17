function [PI, PIhat, test_years] = get_JPL_planet_information(trajs, sys_info, num_years, ...
                                   total_num_years)
% function [PI, PIhat, test_years] = get_JPL_planet_information(trajs, sys_info, num_years, ...
%                                    total_num_years)

% (C) M. Zhong

multiple             = floor(total_num_years/100);
test_years           = (1 : multiple) * 100;
test_years           = union(test_years, [num_years, total_num_years]);
PI                   = zeros(length(test_years), sys_info.N - 1, 4);
PIhat                = zeros(length(test_years), sys_info.N - 1, 4);
PI_info.obs_time_int = 6;                                                                           % time interval to get sample for rel. dist. at t
% Find all related information on the planet
for idx = 1 : length(test_years)
  day_vec            = get_day_vec_from_years(test_years(idx));
  traj               = trajs{1}(:, day_vec + 1);
  trajhat            = trajs{2}(:, day_vec + 1);
  PI(idx, :, :)      = get_JPL_planet_information_over_time(traj,    day_vec, sys_info, PI_info);
  PIhat(idx, :, :)   = get_JPL_planet_information_over_time(trajhat, day_vec, sys_info, PI_info);
end
end