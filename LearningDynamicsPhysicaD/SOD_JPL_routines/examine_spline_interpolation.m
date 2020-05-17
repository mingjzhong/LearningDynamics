% examine_spline_interpolation

% (C) M. Zhong

load_time                 = tic;
selection_idx             = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
total_num_years           = 400;
num_years                 = 400;
use_v                     = false;
data_kind                 = 3;                                                                      % minutely data
obs_data                  = load_planet_data(selection_idx, num_years, total_num_years, use_v, ...
                            data_kind);
fprintf('\nIt takes %0.2f secs to load the data.', toc(load_time));
N                         = length(selection_idx);
d                         = 4;
oneBlock                  = N * d;
x_hourly                  = obs_data.y(1 : oneBlock, :);
time_vec_hourly           = obs_data.time_vec;
x_daily                   = obs_data.y_fut(1 : oneBlock, :);
time_vec_daily            = obs_data.day_vec_fut;
num_minutes               = time_vec_daily(end) * 24 * 60;
time_vec_minutely         = (0 : (num_minutes - 1))/(24 * 60);
spline_errs               = zeros(2, N - 1);
names                     = obs_data.names;
clear obs_data
for idx = 2 : N
  ind1                    = (idx - 1) * d + 1;
  ind2                    = idx       * d;
  if N ~= 5
    r_hourly              = x_hourly(ind1 : ind2,   :) - x_hourly(1   : d, :);
    r_daily               = x_daily(ind1 : ind2,    :) - x_daily(1    : d, :);
  else
    r_hourly              = x_hourly(ind1 : ind2,   :) - x_hourly((3 * d + 1)   : (4 * d), :);
    r_daily               = x_daily(ind1 : ind2,    :) - x_daily((3 * d + 1)    : (4 * d), :);    
  end
  spline_hourly           = spline(time_vec_hourly,   r_hourly);
  spline_daily            = spline(time_vec_daily,    r_daily);
  rh_minutely             = ppval(spline_hourly,      time_vec_minutely);
  rd_minutely             = ppval(spline_daily,       time_vec_minutely);
  rh_norm                 = sum(rh_minutely.^2).^(0.5);
  rd_norm                 = sum(rd_minutely.^2).^(0.5);
  vec_err                 = sum((rd_minutely - rh_minutely).^2).^(0.5);
  norm_err                = abs(rd_norm - rh_norm);
  ind                     = rh_norm ~= 0;
  vec_err(ind)            = vec_err(ind)./rh_norm(ind);
  norm_err(ind)           = norm_err(ind)./rh_norm(ind);
  spline_errs(1, idx - 1) = max(vec_err);
  spline_errs(2, idx - 1) = max(norm_err);
  fprintf('\nFor %8s:', names{idx});
  fprintf('\n\tVectors from daily-spline compared to hourly-spline: %10.4e.', ...
    spline_errs(1, idx - 1));
  fprintf('\n\tNorms   from daily-spline compared to hourly-spline: %10.4e.', ...
    spline_errs(2, idx - 1));  
end




