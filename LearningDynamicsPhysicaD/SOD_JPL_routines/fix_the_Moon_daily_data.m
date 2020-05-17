function fix_the_Moon_daily_data()
% function fix_the_Moon_daily_data()

% (C) M. Zhong

path        =  'D:\planet_data\1600_to_1999_hourly\'; 
days        = get_num_days_from_years(1600 : 1999);
time_vec    = get_time_vec_from_days(days, 'hourly');
t_daily     = get_time_vec_from_days(days, 'daily');
L           = length(time_vec);
daily_ind   = 1 : 24 : L;
matFile     = [path, 'Moon.mat'];
load(matFile, 'x', 'v', 'a_hourly', 'a_minutely', 'ax_minutely');
x           = x(:,           daily_ind);
v           = v(:,           daily_ind);
a_minutely  = a_minutely(:,  daily_ind);
ax_minutely = ax_minutely(:, daily_ind);
a_hourly    = a_hourly(:,    daily_ind);
a_daily     = approximate_derivative(v, t_daily, 1);
save('D:\planet_data\1600_to_1999_daily\Moon.mat', '-v7.3', 'x', 'v', 'a_daily', 'a_hourly', ...
  'a_minutely', 'ax_minutely');
end