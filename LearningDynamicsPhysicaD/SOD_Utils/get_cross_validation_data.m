function [x1, v1, dot_xv1, time1, x2, v2, dot_xv2, time2] = get_cross_validation_data(x, v, dot_xv, ...
         num_years, type)
% function [x1, v1, dot_xv1, time1, x2, v2, dot_xv2, time2] = get_cross_validation_data(x, v, dot_xv, ...
%          num_years, type)

% (C) M. Zhong

total_years = 1600 : 1999;
num_years1  = ceil(num_years * 0.5);
% num_years2  = num_years - num_years1;
years1      = total_years(1 : num_years1);
years2      = total_years(num_years1 + 1 : num_years);
days1       = get_num_days_from_years(years1);
days2       = get_num_days_from_years(years2);
time1       = get_time_vec_from_days(days1, type);
L1          = length(time1);
x1          = x(:,      1 : L1);
v1          = v(:,      1 : L1);
dot_xv1     = dot_xv(:, 1 : L1);
time2       = get_time_vec_from_days(days2, type);
L2          = length(time2);
x2          = x(:,      L1 + 1 : L1 + L2);
v2          = v(:,      L1 + 1 : L1 + L2);
dot_xv2     = dot_xv(:, L1 + 1 : L1 + L2);
end