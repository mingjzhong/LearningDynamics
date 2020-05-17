function days = get_num_days_from_years(years)
% function days = get_num_days_from_years(years)

% (C) M. Zhong

% normally a year has 365 days
days      = 365 * ones(size(years));
% handle the leap years
ind       = mod(years, 4) == 0;
days(ind) = 366;
% for century year, if it is not divisible by 400, it only has 365 days
ind       = mod(years, 100) == 0 & mod(years, 400) ~= 0;
days(ind) = 365;
end