%% Load example definitions and let user select one example to run
selection_idx                                    = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                 % index from each AO in the solar system, from 1 = Sun to 9 = Neptune
total_num_years                                  = 400;                                             % total number of years of data, integer value
num_years                                        = 400;                                             % number of years of data for learning
use_v                                            = false;                                           % use true velocity or not
data_kind                                        = 3;
load_data_time                                   = tic;
[Example, obs_data]                              = Gravitation_JPL_def(selection_idx, num_years, ...
                                                   total_num_years, use_v, data_kind);
fprintf('\nIt takes %6.2f secs to load the data', toc(load_data_time));
sys_info                                         = Example.sys_info;
y                                                = obs_data.y;                                      % only keep the true observation (minutely) data
obs_data                                         = [];
total_years                                      = 1600 : 1999;
time_types                                       = {'daily', 'hourly'};
min_ints                                         = [60, 30, 15];
models                                           = {'linear', 'quadratic', 'periodic'};
fit_methods                                      = {'findPeaks', 'sineFit', 'sineFitZP'};
multiple                                         = floor(total_num_years/100);
test_years                                       = (1 : multiple) * 100;
test_years                                       = union(test_years, [num_years, total_num_years]);
PI                                               = zeros(length(time_types), length(min_ints), ...
                                                   length(models), length(fit_methods), ...
                                                   length(test_years), sys_info.N - 1, 4);
PIerr                                            = cell(length(time_types), length(min_ints), ...
                                                   length(models), length(fit_methods), ...
                                                   length(test_years));                                         
fprintf('\nTesting the Planet Information routines......');
for idx1 = 1 : length(time_types)
  time_type                                      = time_types{idx1};                                % daily, hourly, minutely data
  for idx2 = 1 : length(min_ints)
    PI_info.obs_time_int                         = min_ints(idx2);                                  % time interval to get sample for rel. dist. at t
% Find all related information on the planet
    for idx3 = 1 : length(models)
      PI_info.precession_model                   = models{idx3};
      for idx4 = 1 : length(fit_methods)
        PI_info.fit_method                       = fit_methods{idx4};
        fprintf('\n%6s data, min. int. len. = %2d mins, model = %9s, and fit = %s', time_type, ...
          PI_info.obs_time_int, PI_info.precession_model, PI_info.fit_method);
        find_PI_time                               = tic;
        for idx5 = 1 : length(test_years)
          years                                  = total_years(1 : test_years(idx5));
          days                                   = get_num_days_from_years(years);
          time_vec                               = get_time_vec_from_days(days, time_type);
          traj_ind                               = get_JPL_traj_ind_from_preset_data(data_kind, ...
                                                   days, time_type);
          traj                                   = y(1 : sys_info.N * sys_info.d, traj_ind);
          thePI                                  = get_JPL_planet_information_over_time(traj, ...
                                                   time_vec, sys_info, PI_info);
          PIerr{idx1, idx2, idx3, idx4, idx5}    = get_JPL_PI_errors(sys_info.PI, thePI);
          PI(idx1, idx2, idx3, idx4, idx5, :, :) = thePI;
        end
        fprintf('\nIt takes %6.2f secs to find the planet information', toc(find_PI_time));
      end  
    end    
  end
end
save('JPL_PItest.mat', '-v7.3', 'selection_idx', 'total_num_years', 'num_years', 'data_kind', ...
  'sys_info', 'total_years', 'time_types', 'min_ints', 'models', 'fit_methods', 'test_years', ...
  'PI', 'PIerr');
return;