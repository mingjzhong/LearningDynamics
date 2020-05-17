function show_JPL_PI_test_result(sys_info, time_types, min_ints, models, test_years, fit_methods, ...
         PIerr)
% function show_JPL_PI_test_result(sys_info, time_types, min_ints, models, test_years, fit_methods, ...
%        PIerr)

% (C) M. Zhong

x_pos                     = 20;
y_pos                     = 20;
x_gap                     = 20;
width                     = 1024;
height                    = 1024;
err_types                 = {'Aphelion', 'Perihelion', 'Period', 'Precession Rate'};
% filenames                 = {'Aphelion', 'Perihelion', 'Period', 'Precession_Rate'};
N_idx                     = 2 : 10;
P_idx                     = N_idx - 1;
MI_idx                    = 3;
FM_idx                    = 3;
font_name                 = 'Helvetica';
tick_size                 = 10;
legend_size               = 10;
title_size                = 10;
num_rows                  = 3;
num_cols                  = 3;
grid_mul                  = 3;
for idx1 = 1 : length(err_types)
  WH                      = figure('Name', err_types{idx1}, 'NumberTitle', 'off', 'Position', ...
                            [x_pos + (idx1 - 1) * x_gap, y_pos, width, height]);
  set(groot,'CurrentFigure', WH);
  AHs                     = gobjects(num_rows, num_cols);
  for idx2 = 1 : length(N_idx)
    AH                    = subplot(num_rows, num_cols, idx2);
    AH.FontName           = font_name;
    AH.FontSize           = tick_size;
    set(WH, 'CurrentAxes', AH)
    semilogy(test_years, squeeze(cellfun(@(x) x.rel_err(P_idx(idx2), idx1), ...
      PIerr(1, MI_idx, 1, FM_idx, :))), '-.bd');
    hold on;
    semilogy(test_years, squeeze(cellfun(@(x) x.rel_err(P_idx(idx2), idx1), ...
      PIerr(1, MI_idx, 2, FM_idx, :))), '-.rd');
    semilogy(test_years, squeeze(cellfun(@(x) x.rel_err(P_idx(idx2), idx1), ...
      PIerr(1, MI_idx, 3, FM_idx, :))), '-.kd');
    semilogy(test_years, squeeze(cellfun(@(x) x.rel_err(P_idx(idx2), idx1), ...
      PIerr(2, MI_idx, 1, FM_idx, :))), ':bs');
    semilogy(test_years, squeeze(cellfun(@(x) x.rel_err(P_idx(idx2), idx1), ...
      PIerr(2, MI_idx, 2, FM_idx, :))), ':rs');
    semilogy(test_years, squeeze(cellfun(@(x) x.rel_err(P_idx(idx2), idx1), ...
      PIerr(2, MI_idx, 3, FM_idx, :))), ':ks');
    hold off;
    legend([time_types{1}, ': ', models{1}], [time_types{1}, ': ', models{2}], ...
      [time_types{1}, ': ', models{3}], [time_types{2}, ': ', models{1}], ...
      [time_types{2}, ': ', models{2}], [time_types{2}, ': ', models{3}], 'FontName', font_name, ...
      'FontSize', legend_size, 'Location', 'Best');
    title([sys_info.AO_names{N_idx(idx2)}, ':', sprintf('%d mins', min_ints(MI_idx)), ', ', ...
      fit_methods{FM_idx}], ...
      'FontName', font_name, 'FontSize', title_size);
    xticks(test_years);
    xticklabels({'100 yrs', '200 yrs', '300 yrs', '400 yrs'});
    row_ind               = floor((idx2 - 1)/grid_mul) + 1;
    col_ind               = mod(idx2 - 1, grid_mul) + 1;
    AHs(row_ind, col_ind) = AH;
  end
  tightFigaroundAxes(AHs);
%  print(WH, sprintf('Err_%s_%dmin_%s', filenames{idx1}, min_ints(MI_idx), fit_methods{FM_idx}), ...
%    '-painters', '-dpng', '-r600');
end
end