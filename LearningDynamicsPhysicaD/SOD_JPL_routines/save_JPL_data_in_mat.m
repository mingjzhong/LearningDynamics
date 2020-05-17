function save_JPL_data_in_mat(kind)
% function save_JPL_data_in_mat(kind)

% (C) M. Zhong

switch kind
  case 1
    data_folder = '1600_to_1999_daily';
    time_type   = 'daily';
  case 2
    data_folder = '1600_to_1999_hourly';
    time_type   = 'hourly';
  otherwise
    error('');
end
if ispc
  path          = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\planet_data\' data_folder '\']; 
else % includes ismac and isunix
  path          = [getenv('HOME'), '/DataAnalyses/LearningDynamics/planet_data/' data_folder '/']; 
end
AO_names        = {'Sun', 'Mercury', 'Venus', 'Earth', 'Moon', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune'};
years           = 1600 : 1999;
days            = get_num_days_from_years(years);
time_vec        = get_time_vec_from_days(days, time_type);
L               = length(time_vec);
total_time      = tic;
for N_idx = 1 : length(AO_names)
  proc_time     = tic;
  name          = AO_names{N_idx};
  fprintf('\nWorking on data on %s.', name);
  matFile       = [path, name, '.mat'];
  file          = [path, name, '.txt'];
  AO_data       = dlmread(file, ',', 0, 2);
  x_i           = AO_data(1 : L, 1 : 3)';
  v_i           = AO_data(1 : L, 4 : 6)';
  save(matFile, '-v7.3', 'x_i', 'v_i');
  fprintf('\nIt takes %6.2f seconds to finish reading data on %s.', toc(proc_time), name);
end
fprintf('\nIt takes %6.2f seconds to finish the whole thing.\n', toc(total_time));
end