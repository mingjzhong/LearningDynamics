function merge_minutely_data()
% function merge_minutely_data()

% (C) M. Zhong

% if ispc
%   path           = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\planet_data\1600_to_1999_minutely\']; 
% else % includes ismac and isunix
%   path           = [getenv('HOME'), '/DataAnalyses/LearningDynamics/planet_data/1600_to_1999_minutely/']; 
% end
path             = 'D:/planet_data/';
AO_names         = {'Sun', 'Mercury', 'Venus', 'Earth', 'Moon', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune'};
years            = 1800 : 1999;
days             = get_num_days_from_years(years);
time_vec         = get_time_vec_from_days(days, 'minutely');
L                = length(time_vec);
N                = length(AO_names);
d                = 3;
x_i              = zeros(d, L);
v_i              = zeros(d, L);
year_range       = {1800 : 1899, 1900 : 1999};
for N_idx = 1 : N
  proc_time      = tic;
  name           = AO_names{N_idx};
  matFile        = [path, name, '.mat'];
  for idx = 1 : 2
    file         = [path, name, sprintf('%d', idx), '.csv'];
    
    AO_data      = dlmread(file, ',', 0, 2);
    [theL, idxs] = get_index_in_data_file(year_range{idx}, idx);
    x_i(:, idxs) = AO_data(1 : theL, 1 : 3)';
    v_i(:, idxs) = AO_data(1 : theL, 4 : 6)';
  end
  save(matFile, '-v7.3', 'x_i', 'v_i');
  fprintf('\nIt takes %6.2f seconds to finish reading data on %s.', toc(proc_time), name);
end
end