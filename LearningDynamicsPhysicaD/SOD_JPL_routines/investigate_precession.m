% function investigate_precession()
%

% (C) M. Zhong

% Load the gravity horly data
load_time                      = tic;
selection_idx                  = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                    
total_num_years                = 400;                                                                
num_years                      = 400;                                                            
data_kind                      = 2;                                                                  
use_v                          = true;                                                               
[Example, obs_data]            = Gravitation_JPL_def(selection_idx, num_years, total_num_years, ...
                                 use_v, data_kind);
fprintf('\nIt takes %6.2f secs to load the data.', toc(load_time));

% prepare the Mercury-Sun and Neptune-Sun relative distance
prep_time                      = tic;
sys_info                       = Example.sys_info;
d                              = sys_info.d;
N                              = sys_info.N;
x_pos                          = cell(2, 4);
v_pos                          = cell(1, 4);
x_pos{1, 1}                    = obs_data.y(d + 1 : 2 * d, :)           - obs_data.y(1 : d, :);
x_pos{2, 1}                    = obs_data.y((N - 1) * d + 1 : N * d, :) - obs_data.y(1 : d, :);
v_pos{1}                       = obs_data.y((N + 1) * d + 1 : (N + 2) * d, :) - 
time_vec                       = obs_data.time_vec;
clear Example obs_data
fprintf('\nIt takes %6.2f secs to prepare the JPL data.', toc(prep_time));

% Load the other data
prep_time                      = tic;
SAVE_DIR                       = 'D:\saved_tests_for_Gravity\main_tests\';
dyn_files                      = {'EIH', 'CubicLD400trained', 'Newton'};
for idx = 1 : length(dyn_files)
  file_name                    = [SAVE_DIR, dyn_files{idx} '_400years.mat'];
  load(file_name, 'learn_out');
  y                            = dense_output(learn_out.dynamicshat, time_vec);
  x_pos{1, idx + 1}            = y(d + 1 : 2 * d, :)           - y(1 : d, :);
  x_pos{2, idx + 1}            = y((N - 1) * d + 1 : N * d, :) - y(1 : d, :);
end
clear learn_out y
fprintf('\nIt takes %6.2f secs to prepare other data.', toc(prep_time));

% prepare the spline interpolation, find out the apsis, and thetas at ts
num_minutes                    = (floor(time_vec(end)) + 1) * 24 * 60;
t_min                          = (0 : (num_minutes - 1))/(24 * 60);
ind                            = t_min > time_vec(end);
t_min(ind)                     = [];
ts                             = cell(2, 4);
apsis                          = cell(2, 4);
thetas                         = cell(2, 4);
mod_fac                        = [1, -1];
for idx1 = 1 : 4
  r_spline                     = pchipd(time_vec, x_pos{1, idx1});
  rvec_min                     = ppval(r_spline, t_min);
  r_min                        = sum(rvec_min.^2).^(0.5);
  for idx2 = 1 : 2
    [~, locs]                  = findpeaks(mod_fac(idx2) * r_min);
    ts{idx2, idx1}             = t_min(locs);
    apsis{idx2, idx1}          = rvec_min(:, locs);
    thetas{idx2, idx1}         = zeros(size(ts{idx2, idx1}));   
    for idx3 = 2 : length(ts{idx2, idx1})
      thetas{idx2, idx1}(idx3) = get_JPL_angle(apsis{idx2, idx1}(:, 1), ...
                                 apsis{idx2, idx1}(:, idx3)) * 3600;
    end
  end
end

% % post-processing
% for idx1 = 1 : 3
%   for idx2 = 1 : 2
%     len_ts                     = min([length(ts{idx2, 1}), length(ts{idx2, 2}), ...
%                                  length(ts{idx2, 3}), length(ts{idx2, 4})]);
%     ts{idx2, idx1 + 1}         = ts{idx2, idx1 + 1}(1 : len_ts);
%     apsis{idx2, idx1 + 1}      = apsis{idx2, idx1 + 1}(:, 1 : len_ts);
%     thetas{idx2, idx1 + 1}     = thetas{idx2, idx1 + 1}(1 : len_ts);
%   end
% end

% % find out the error compared to the observed dynamics
% ts_err                         = cell(2, 3);
% apsis_err                      = cell(2, 3);
% thetas_err                     = cell(2, 3);
% for idx1 = 1 : 3
%   for idx2 = 1 : 2
%     ts_err{idx2, idx1}         = ts{idx2,     idx1 + 1} - ts{idx2,     1};
%     apsis_err{idx2, idx1}      = zeros(size(ts{idx2, 1}));
%     for idx3 = 1 : length(ts{idx2, idx1})
%       apsis_err{idx2, idx1}(idx3) = norm(apsis{idx2, idx1 + 1}(:, idx3) - apsis{idx2, 1}(:, idx3));
%     end
%     thetas_err{idx2, idx1}     = thetas{idx2, idx1 + 1} - thetas{idx2, 1};
%   end
% end

% % visualize the errors
% width                          = 900;
% height                         = 900;
% pos_x                          = 50;
% gap_x                          = 25;
% pos_y                          = 50;
% WH                             = figure('Name', 'Apsis', 'NumberTitle', 'off', 'Position', ...
%                                  [pos_x, pos_y, width, height]);
% title_sym                      = {'t', 'Aphel.', 'Theta'};
% sign_sym                       = {'bo', 'rd'};
% dyn_names                      = {'EIH', 'CubicLD', 'Newton'};
% plot_info.font_name            = 'Helvetica';
% plot_info.tick_size            = 12;
% plot_info.legend_size          = 12;
% plot_info.title_size           = 12;
% plot_info.legend_loc           = 'NorthWest';
% show_JPL_apsis_errors(WH, sign_sym, title_sym, dyn_names, ts_err(1, :), apsis_err(1, :), ...
%   thetas_err(1, :), plot_info);
% print(WH, 'comp_Aphelion', '-painters', '-dpng', '-r300');
% WH                             = figure('Name', 'Apsis', 'NumberTitle', 'off', 'Position', ...
%                                  [pos_x + gap_x, pos_y, width, height]);
% title_sym                      = {'t', 'Perih.', 'Theta'};                               
% show_JPL_apsis_errors(WH, sign_sym, title_sym, dyn_names, ts_err(2, :), apsis_err(2, :), ...
%   thetas_err(2, :), plot_info);
% print(WH, 'comp_Perihelion', '-painters', '-dpng', '-r300');

% print out the precession rate for Mercury
types                           = {'Aphelion', 'Perihelion'};
dyn_names                       = {'Observed', 'EIH', 'CubicLD', 'Newton'};
for idx1 = 1 : 4
  for idx2 = 1 : 2
    PR                          = get_JPL_precession_rate(ts{idx2, idx1}, thetas{idx2, idx1});
    fprintf('\nPrecession Rate on %10s from %8s is: %6.2f arc-second pear 100 Earth-year.', ...
      types{idx2}, dyn_names{idx1}, PR(1)); 
  end
end

% JPL_analyze_Neptune_data(pos_x, gap_x, pos_y, width, height, x_pos(2, :), time_vec, dyn_names);
return