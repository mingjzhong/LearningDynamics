function merge_minutely_data02()
% function merge_minutely_data02()

% (C) M. Zhong

path1       = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\planet_data\1600_to_1999_minutely\']; 
path2       = 'D:/planet_data/';
AO_names    = {'Sun', 'Mercury', 'Venus', 'Earth', 'Moon', 'Mars', 'Jupiter', 'Saturn', 'Uranus', ...
              'Neptune'};
x_is        = cell(1, 2);
v_is        = cell(1, 2);
for N_idx = 1 : length(AO_names)
  proc_time = tic;
  name      = AO_names{N_idx};
  fprintf('\nWorking on the file on %s.', name);
  matFile   = [path1, name, '.mat'];
  load(matFile, 'x_i', 'v_i');
  x_is{1}   = x_i;
  v_is{1}   = v_i;
  fprintf('\nFirst    set has %d minutes.', size(x_i, 2));
  matFile   = [path2, name, '.mat'];
  load(matFile, 'x_i', 'v_i');
  x_is{2}   = x_i;
  v_is{2}   = v_i;  
  fprintf('\nSecond   set has %d minutes.', size(x_i, 2));
  x_i       = [x_is{:}];
  v_i       = [v_is{:}];
  fprintf('\nFinished set has %d minutes.', size(x_i, 2));
  matFile   = [path1, name, '.mat'];
  save(matFile, '-v7.3', 'x_i', 'v_i');
  fprintf('\nIt takes %6.2f seconds to finish merging the data', toc(proc_time));
end
end