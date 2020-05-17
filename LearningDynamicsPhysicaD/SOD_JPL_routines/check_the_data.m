function check_the_data(kind)
% function check_the_data(kind)

% (C) M. Zhong

AO_names            = {'Sun', 'Mercury', 'Venus', 'Earth', 'Moon', 'Mars', 'Jupiter', 'Saturn', ...
                       'Uranus', 'Neptune'};   
switch kind
  case 1
    years           = 1600 : 1999;
    starting_t      = 2305447.500000000;   
    ending_t        = 2451543.500000000;
    data_folder     = '1600_to_1999_daily';
    time_type       = 'daily';
  case 2
    years           = 1600 : 1999;
    starting_t      = 2305447.500000000; 
    ending_t        = 2451544.458333333; 
    data_folder     = '1600_to_1999_hourly';
    time_type       = 'hourly';
  case 3
    years           = 1600 : 1799;
    starting_t      = 2305447.500000000;
    ending_t        = 2451544.458333333;
    data_folder     = '1600_to_1999_minutely';
    time_type       = 'minutely';
  case 4
    years           = 1800 : 1899;
    starting_t      = 2378496.500000000;
    ending_t        = 2415020.499305556;
    time_type       = 'minutely';
    data_folder     = '1';
  case 5
    years           = 1900 : 1999;
    starting_t      = 2415020.500000000;
    ending_t        = 2451544.499305556;
    time_type       = 'minutely';
    data_folder     = '2';
  otherwise
    error('');
end
% please place the planet data inside the DataAnalyses folder  
if ispc
%  path              = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\planet_data\' data_folder '\']; 
  path              = 'D:/planet_data/';
else % includes ismac and isunix
  path              = [getenv('HOME'), '/DataAnalyses/LearningDynamics/planet_data/' data_folder '/']; 
end
days                = get_num_days_from_years(years);
time_vec            = get_time_vec_from_days(days, time_type);
L                   = length(time_vec);
fprintf('\nThere should be %d lines of data.\n', L);
N                   = length(AO_names);
times               = zeros(N, L);
for N_idx = 1 : N
  switch kind
    case 1
      file          = [path, AO_names{N_idx} '.txt'];
    case 2
      file          = [path, AO_names{N_idx} '.txt'];
    case 3
      file          = [path, AO_names{N_idx} '.csv'];
    case 4
      file          = [path, AO_names{N_idx} data_folder '.csv'];
    otherwise
      error('');
  end
  fid               = fopen(file);
  for l = 1 : L
    fline           = fgetl(fid);
    content         = strsplit(fline, ',');
    times(N_idx, l) = str2double(content{1});
  end
  fclose(fid);
end
delta_t             = (ending_t - starting_t)/(L - 1);
times_true          = (0 : (L - 1)) * delta_t + starting_t;
for N_idx = 1 : N
  figure(N_idx);
  subplot(1, 2, 1);
  plot(1 : L, times(N_idx, :), 'bo');
  title(sprintf('%s''s Times', AO_names{N_idx}));
  subplot(1, 2, 2);
  time_err          = abs(times(N_idx, :) - times_true);
  plot(1 : L, time_err, 'rx');
  title(sprintf('%s''s Error', AO_names{N_idx}));
  I                 = find(time_err > 1e-9, 1);
  fprintf('\nAt index = %d!!\n', I);
end

% % while ischar(tline)
% %     disp(tline)
% %     tline = fgetl(fid);
% % end
% %content      = textscan(fid, '%f,%s,%f,%f,%f,%f,%f,%f,', 'EndOfLine', '\r\n', 'ReturnOnError', false);
% fclose(fid);
% times        = content{1};
% length(times)
% % for idx = 1 : N
% %   file       = [path, AO_names{idx}, '.csv'];
% %   AO_data    = dlmread(file, ',', 0, 0, [0 0 time_vec(end) 0]);                                
% %   size(AO_data)
% %   times      = AO_data(:, 1); 
% % end
end