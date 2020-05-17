function rework_the_planet_data_hourly()
% function rework_the_planet_data_hourly()

% (C) M. Zhong

path          =  'D:\planet_data\1600_to_1999_hourly\'; 
AO_names      = {'Moon', 'Mercury', 'Venus', 'Earth', 'Mars', 'Sun', 'Jupiter', 'Saturn', 'Uranus', ...
                 'Neptune'};
days          = get_num_days_from_years(1600 : 1999);
time_vec      = get_time_vec_from_days(days, 'hourly');
for idx = 1 : length(AO_names)
  matFile = [path, AO_names{idx}, '.mat'];
  load(matFile, 'x_i', 'v_i', 'a1_i', 'a2_i');
  x           = x_i;
  v           = v_i;
  a_minutely  = a1_i;
  ax_minutely = a2_i;
  a_hourly    = approximate_derivative(v, time_vec, 1);
  a_daily     = [];
  save(matFile, '-v7.3', 'x', 'v', 'a_daily', 'a_hourly', 'a_minutely', 'ax_minutely');
end
end