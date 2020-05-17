function rework_the_planet_data_daily()
% function rework_the_planet_data_daily()

% (C) M. Zhong

path          =  'D:\planet_data\1600_to_1999_hourly\'; 
AO_names      = {'Moon', 'Mercury', 'Venus', 'Earth', 'Mars', 'Sun', 'Jupiter', 'Saturn', 'Uranus', ...
                 'Neptune'};
days          = get_num_days_from_years(1600 : 1999);
time_vec      = get_time_vec_from_days(days, 'hourly');
t_daily       = get_time_vec_from_days(days, 'daily');
L             = length(time_vec);
daily_ind     = 1 : 24 : L;
for idx = 1 : length(AO_names)
  matFile = [path, AO_names{idx}, '.mat'];
  load(matFile, 'x_i', 'v_i', 'a1_i', 'a2_i');
  x           = x_i(:,  daily_ind);
  v           = v_i(:,  daily_ind);
  a_minutely  = a1_i(:, daily_ind);
  ax_minutely = a2_i(:, daily_ind);
  a_daily     = approximate_derivative(v, t_daily, 1);
  a_hourly    = approximate_derivative(v_i, time_vec, 1);
  a_hourly    = a_hourly(:, daily_ind);
  save(['D:\planet_data\1600_to_1999_daily\', AO_names{idx}, '.mat'], '-v7.3', 'x', 'v', ...
    'a_daily', 'a_hourly', 'a_minutely', 'ax_minutely');
end
end