% function show_JPL_vi_and_ai()
% function show_JPL_vi_and_ai()

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
data_kind             = 2;                                                                          % minutely data
obs_data              = load_planet_data(selection_idx, num_years, total_num_years, use_v, ...
                        data_kind);
oneBlock              = N * d;
x                     = obs_data.y(1 : N * d, :);
v                     = obs_data.dy(1 : N * d, :);
a                     = obs_data.dy(N * d + 1 : 2 * N * d, :);
time_vec_minutely     = obs_data.time_vec;
names                 = obs_data.names;
clear obs_data
xi                    = zeros(1, N);
vi                    = zeros(1, N);
ai                    = zeros(1, N);
for idx = 1 : N
  ind1                = (idx - 1) * d + 1;
  ind2                = idx       * d;
  xi(idx)             = max(sum(x(ind1 : ind2, :).^2).^(0.5), [], 2);
  vi(idx)             = max(sum(v(ind1 : ind2, :).^2).^(0.5), [], 2);
  ai(idx)             = max(sum(a(ind1 : ind2, :).^2).^(0.5), [], 2);
end
plot_info.font_name   = 'Helvetica';
plot_info.tick_size   = 12;
plot_info.legend_size = 20;
plot_info.label_size  = 20;
plot_info.title_size  = 20;
win_h                 = figure('Name', 'Approximated Derivaties', 'NumberTitle', 'off', ...
                        'Position', [50, 50, 900, 900]);
AH                    = set_JPL_vi_and_ai_plot(win_h, 'Daily', names, num_years, 1 : N, xi, vi, ...
                        ai, plot_info);
tightFigaroundAxes(AH);
%save('JPL_derivative_test', '-v7.3', 'N', 'd', 'names', 'num_years', 'err_daily', 'err_hourly', ...
%  'err_minutely');
print(win_h, 'JPL_vi_and_ai', '-painters', '-dpng', '-r600');
%end