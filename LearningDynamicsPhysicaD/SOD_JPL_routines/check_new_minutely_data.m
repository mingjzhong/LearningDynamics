function check_new_minutely_data()
%

%

path             = 'D:/planet_data/';
AO_names         = {'Sun', 'Mercury', 'Venus', 'Earth', 'Moon', 'Mars', 'Jupiter', 'Saturn', ...
                    'Uranus', 'Neptune'};
years            = 1800 : 1999;
days             = get_num_days_from_years(years);
time_vec         = get_time_vec_from_days(days, 'minutely');
N                = length(AO_names);
err_i            = zeros(N, 1);
for N_idx = 1 : N
  proc_time      = tic;
  name           = AO_names{N_idx};
  matFile        = [path, name, '.mat'];
  load(matFile, 'x_i', 'v_i');
  tilde_v_i      = approximate_derivative(x_i, time_vec, 1);
  err_i(N_idx)   = max(sum((v_i - tilde_v_i).^2).^(0.5));
  fprintf('\nFor %s, the error is: %10.4e.', name, err_i(N_idx));
  fprintf('\nIt takes %6.2f seconds to finish checking data', toc(proc_time));
end
end