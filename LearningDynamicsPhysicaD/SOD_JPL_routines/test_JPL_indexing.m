function test_JPL_indexing()
% function test_JPL_indexing()

% (C) M. Zhong

years           = 1600 : 1999;
days            = get_num_days_from_years(years);
time_vec        = get_time_vec_from_days(days, 'minutely');
num_minutes     = sum(days) * 24 * 60;
time_vec_daily  = get_time_vec_from_days(days, 'daily');
time_vec_hourly = get_time_vec_from_days(days, 'hourly');
err_daily       = norm(time_vec(1 : (60 * 24) : num_minutes) - time_vec_daily, Inf);
fprintf('\nError on finding index for daily data is: %10.4e.', err_daily);
err_hourly      = norm(time_vec(1 : 60 : num_minutes) - time_vec_hourly, Inf);
fprintf('\nError on finding index for daily data is: %10.4e.', err_hourly);
end