% function test_JPL_derivatives()
% function test_JPL_derivatives()

% (C) M. Zhong

N                     = 10;
d                     = 3;
total_years           = 1600 : 1999;
selection_idx         = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
total_num_years       = 400;
num_years             = 400;
years                 = total_years(1 : num_years);
days                  = get_num_days_from_years(years);
use_v                 = true;
data_kind             = 4;                                                                          % minutely data
obs_data              = load_planet_data(selection_idx, num_years, total_num_years, use_v, ...
                        data_kind);
y                     = obs_data.y;
time_vec_minutely     = obs_data.time_vec;
names                 = obs_data.names;
clear obs_data
x                     = y(1         : N * d,     :);
v                     = y(N * d + 1 : 2 * N * d, :);
v_app                 = approximate_derivative(x, time_vec_minutely, 1);
[re_min, ae_min]      = get_error_of_a_NdL_matrix(v, v_app, N, d);
num_minutes           = size(y, 2);
ind                   = 1 : 60 : num_minutes;
x                     = y(1         : N * d,     ind);
v                     = y(N * d + 1 : 2 * N * d, ind);
time_vec_hourly       = get_time_vec_from_days(days, 'hourly');
v_app                 = approximate_derivative(x, time_vec_hourly, 1);
[re_hou, ae_hou]      = get_error_of_a_NdL_matrix(v, v_app, N, d);
ind                   = 1 : (60 * 24) : num_minutes;
x                     = y(1         : N * d,     ind);
v                     = y(N * d + 1 : 2 * N * d, ind);
time_vec_daily        = get_time_vec_from_days(days, 'daily');
v_app                 = approximate_derivative(x, time_vec_daily, 1);
[re_dai, ae_dai]      = get_error_of_a_NdL_matrix(v, v_app, N, d);
plot_info.font_name   = 'Helvetica';
plot_info.tick_size   = 12;
plot_info.legend_size = 20;
plot_info.label_size  = 20;
plot_info.title_size  = 20;
AHs                   = gobjects(1, 3);
win_h                 = figure('Name', 'Approximated Derivaties', 'NumberTitle', 'off', ...
                        'Position', [20, 20, 1900, 950]);
AHs(1)                = subplot(1, 3, 1);
set_JPL_AD_plot(win_h, AHs(1), 'Daily', re_dai, ae_dai, names, num_years, ...
  plot_info);
AHs(2)                = subplot(1, 3, 2);
set_JPL_AD_plot(win_h, AHs(2), 'Hourly', re_hou, ae_hou, names, num_years, ...
  plot_info);
AHs(3)                = subplot(1, 3, 3);
set_JPL_AD_plot(win_h, AHs(3), 'Minutely', re_min, ae_min, names, num_years, ...
  plot_info);
tightFigaroundAxes(AHs);
%save('JPL_derivative_test', '-v7.3', 'N', 'd', 'names', 'num_years', 'err_daily', 'err_hourly', ...
%  'err_minutely');
print(win_h, 'FDM_accuracy', '-painters', '-dpng', '-r600');
%end