function [sun_x, merc_x, time_vec] = load_planet_trajP()
% function [sun_x, merc_x, time_vec] = load_planet_trajP()

% (C) M. Zhong

AO_names                 = {'Sun', 'Mercury_300'}; %Mercury_3S default 1870-2019, Mercury_300=230 years
AO_data                  = cell(1, length(AO_names));
for idx = 1 : length(AO_names)
  file                   = [AO_names{idx} '.txt'];
  AO_data{idx}           = dlmread(file, ',', 0, 2);
end
years                    = 1870 : 2099; %2099
num_days                 = [366, 365];
leap_year                = mod(years, 4);
leap_year(leap_year > 0) = 1;
leap_year                = leap_year + 1;
days                     = num_days(leap_year);
ind                      = mod(years, 100) == 0 & mod(years, 400) ~= 0;
days(ind)                = 365;
L                        = sum(days);
T                        = L - 1;
time_vec                 = 0 : T;
%sun_x                    = AO_data{1}(1 : L, 1 : 3)';
sun_x = [];
merc_x                   = AO_data{2}(1 : L, 1 : 3)';
end