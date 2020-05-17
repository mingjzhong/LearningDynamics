function JPL_analyze_Neptune_data(pos_x, gap_x, pos_y, width, height, x_pos, time_vec, dyn_names)
% function JPL_analyze_Neptune_data(pos_x, gap_x, pos_y, width, height, x_pos, time_vec, dyn_names)
% Input:
%   x_pos     - 
%   time_vec  - time or space range for data
%   dyn_names -

% (C) M. Zhong

% find the relative distance of Neptune to Sun
r_norms                 = cell(1, 4);
mainSines               = cell(1, 4);
nextSines               = cell(1, 4);
for idx = 1 : length(dyn_names)
  r_norms{idx}          = sum(x_pos{idx}.^2).^(0.5);
  sineParams            = sineFit_using_FFT(time_vec, r_norms{idx}, 'more padding');
  mainSine              = @(t) sineParams(1) + sineParams(2) * sin(2 * pi * sineParams(3) * t + sineParams(4));
  mainSines{idx}        = mainSine(time_vec);
  fprintf('\n1st Sine has a period of %10.4e days', 1/sineParams(3));
  sineParams            = sineFit_using_FFT(time_vec, r_norms{idx} - mainSines{idx}, 'more padding');
  nextSine              = @(t) sineParams(1) + sineParams(2) * sin(2 * pi * sineParams(3) * t + sineParams(4));
  nextSines{idx}        = nextSine(time_vec);
  fprintf('\n2nd Sine has a period of %10.4e days', 1/sineParams(3));
end
% Visualize the dist.
WH                      = figure('Name', 'Neptune: Freq. Analy.', 'NumberTitle', 'off', ...
                          'Position', [pos_x, pos_y, width, height]);
xlabel_name             = 't, in days';
ylabel_name             = 'Rel. Dist.';
file_name               = 'Neptune_dist';
JPL_show_2by2_plots(WH, dyn_names, xlabel_name, ylabel_name, time_vec, r_norms, file_name);
WH                      = figure('Name', 'Neptune: Freq. Analy.', 'NumberTitle', 'off', ...
                          'Position', [pos_x + 1 * gap_x, pos_y, width, height]);
file_name               = 'Neptune_dist_1stfreq';            
JPL_show_2by2_plots(WH, dyn_names, xlabel_name, ylabel_name, time_vec, mainSines, file_name);
WH                      = figure('Name', 'Neptune: Freq. Analy.', 'NumberTitle', 'off', ...
                          'Position', [pos_x + 2 * gap_x, pos_y, width, height]);
file_name               = 'Neptune_dist_2ndfreq';                        
JPL_show_2by2_plots(WH, dyn_names, xlabel_name, ylabel_name, time_vec, nextSines, file_name);
end