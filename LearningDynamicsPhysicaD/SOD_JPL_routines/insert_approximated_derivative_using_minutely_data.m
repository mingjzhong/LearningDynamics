function insert_approximated_derivative_using_minutely_data()
% function insert_approximated_derivative_using_minutely_data()

% (C) M. Zhong

if ispc, path   = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics\planet_data\']; 
else,    path   = [getenv('HOME'), '/DataAnalyses/LearningDynamics/planet_data/']; end 
types           = {'daily', 'hourly', 'minutely'};
paths           = {[path '1600_to_1999_daily'], [path '1600_to_1999_hourly'], ...
                   [path '1600_to_1999_minutely']};
if ispc
  div_string    = '\';
else
  div_string    = '/';
end
for idx = 1 : length(paths)
  paths{idx}    = [paths{idx}, div_string];
end
names           = {'Neptune', 'Uranus', 'Saturn', 'Sun', 'Jupiter', 'Mars', 'Earth', 'Venus', ...
                   'Moon', 'Mercury'};
years           = 1600 : 1999;
days            = get_num_days_from_years(years);
time_vec        = get_time_vec_from_days(days, 'minutely');
num_minutes     = sum(days) * 24 * 60;   
inds            = {1 : (24 * 60) : num_minutes, 1 : 60 : num_minutes, 1 : 1 : num_minutes};
for idx1 = 1 : length(names)
  proc_time     = tic;
  fprintf('\nAdded approximated derivative on %s file', names{idx1});
  load_time     = tic;
  matFile       = [paths{3}, names{idx1}, '.mat'];
  load(matFile, 'x_i', 'v_i');
  fprintf('\nIt takes %0.2f secs to load the file', toc(load_time));
  AD_time       = tic;
  x_i_minutely  = x_i;
  v_i_minutely  = v_i;
  a1_i_minutely = approximate_derivative(v_i_minutely, time_vec, 1);
  a2_i_minutely = approximate_derivative(x_i_minutely, time_vec, 2); 
  fprintf('\nIt takes %0.2f secs to finish approximating the derivatives', toc(AD_time));
  save_time     = tic;
  for idx2 = 1 : length(types)
    fprintf('\nWorking on %s data.', types{idx2});
    matFile   = [paths{idx2}, names{idx1}, '.mat'];
    x_i       = x_i_minutely(:,  inds{idx2});
    v_i       = v_i_minutely(:,  inds{idx2});
    a1_i      = a1_i_minutely(:, inds{idx2});
    a2_i      = a2_i_minutely(:, inds{idx2});
%     if idx2 < length(types)
%       load(matFile, 'x_i', 'v_i');
%       x_i_check = x_i_minutely(:, inds{idx2});
%       v_i_check = v_i_minutely(:, inds{idx2});
%       err_x_i   = norm(sum((x_i - x_i_check).^2).^(0.5), Inf);
%       err_v_i   = norm(sum((v_i - v_i_check).^2).^(0.5), Inf);
%       fprintf('\nError on x_i should be 0, and it is %10.4e', err_x_i);
%       fprintf('\nError on v_i should be 0, and it is %10.4e', err_v_i);
%       if err_x_i > 0, error(''); end
%       if err_v_i > 0, error(''); end
%       a1_i      = a1_i_minutely(:, inds{idx2});
%       a2_i      = a2_i_minutely(:, inds{idx2});
%     else
%       x_i       = x_i_minutely;
%       v_i       = v_i_minutely;
%       a1_i      = a1_i_minutely;
%       a2_i      = a2_i_minutely;
%     end
    save(matFile, '-v7.3', 'x_i', 'v_i', 'a1_i', 'a2_i');
  end
  fprintf('\nIt takes %0.2f to put them back in.', toc(save_time));
  fprintf('\nIt takes %0.2f secs to finish.', toc(proc_time));
end
end