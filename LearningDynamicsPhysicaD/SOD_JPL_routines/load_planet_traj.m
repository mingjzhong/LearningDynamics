function obs_data = load_planet_traj(selection_idx, num_years, total_num_years, use_v, kind)
% function obs_data = load_planet_traj(selection_idx, num_years, total_num_years, use_v, kind)

% (C) M. Zhong

% please place the planet data inside the DataAnalyses folder
[path, total_years, time_type] = get_path_for_NASA_data(kind);
year_gap                       = total_years(end) - total_years(1) + 1;
if total_num_years > year_gap
  error('SOD_Data:load_planet_traj', 'It have only %d years of data!!', year_gap); 
end
AU                             = 149.5978707;                                                       % Astronomical unit, in the NASA unit: 10^6 km
num_years_fut                  = total_num_years;
if num_years < 0 || num_years > total_num_years
  num_years_cur                = total_num_years;
else
  num_years_cur                = num_years;
end
AO_names                       = {'Sun', 'Mercury', 'Venus', 'Earth', 'Moon', 'Mars', 'Jupiter', ...
                                  'Saturn', 'Uranus', 'Neptune', 'Pluto'};                          % Sun, 8 planets, Earth's Moon, and Pluto                                                                 
years                          = total_years(1 : num_years_cur);
years_fut                      = total_years(1 : num_years_fut);
days                           = get_num_days_from_years(years);
days_fut                       = get_num_days_from_years(years_fut);
time_vec                       = get_time_vec_from_days(days,     time_type);
time_vec_fut                   = get_time_vec_from_days(days_fut, time_type);
L                              = length(time_vec);
L_fut                          = length(time_vec_fut);
N                              = length(selection_idx);
trajfut_ind                    = get_ind_vec_for_traj(L_fut, time_type);                            % corresponding index in traj (if hourly data)
d                              = 3;
names                          = AO_names(selection_idx);
x_daily_fut                    = zeros(N * d, length(trajfut_ind));
v_daily_fut                    = zeros(N * d, length(trajfut_ind));
x_N                            = zeros(N * d, L);
v_N                            = zeros(N * d, L);
a_N                            = zeros(N * d, L);
for idx = 1 : length(selection_idx)
  planet_idx                   = selection_idx(idx);
  names{idx}                   = AO_names{planet_idx};
  file                         = [path, names{idx}, '.mat'];
  if use_v
    load(file, 'x', 'v', 'a_minutely');
  else
    load(file, 'x', 'v', 'ax_minutely');
  end
  ind1                         = (idx - 1) * d + 1;
  ind2                         = idx * d;
  x_daily_fut(ind1 : ind2, :)  = x(:, trajfut_ind);
  v_daily_fut(ind1 : ind2, :)  = v(:, trajfut_ind);
  x_N(ind1    : ind2, :)       = x(:, 1 : L);
  v_N(ind1  : ind2, :)         = v(:, 1 : L);
  if use_v
    a_N(ind1 : ind2, :)        = a_minutely(:, 1 : L);
  else         
    a_N(ind1 : ind2, :)        = ax_minutely(:, 1 : L);  
  end
end
if ~use_v 
  v_N                          = approximate_derivative(x, time_vec, 1);
end
obs_data.y                     = [x_N; v_N] * AU;
obs_data.dy                    = [v_N; a_N] * AU;
obs_data.time_vec              = time_vec;        
obs_data.y_fut                 = [x_daily_fut; v_daily_fut] * AU;
obs_data.day_vec_fut           = get_time_vec_from_days(days_fut, 'daily');                         % evaluate the dynamics data daily
obs_data.names                 = names;
obs_data.N                     = N;
obs_data.d                     = d;
end