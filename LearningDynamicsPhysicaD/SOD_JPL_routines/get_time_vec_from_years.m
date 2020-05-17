function time_vec = get_time_vec_from_years(years, type)
% function time_vec = get_time_vec_from_years(years, type)

% (C) M. Zhong

if nargin < 2, type = 'daily'; end
year_range = 1600 : 1999;
days       = get_num_days_from_years(year_range(1 : years));
time_vec   = get_time_vec_from_days(days, type);
end