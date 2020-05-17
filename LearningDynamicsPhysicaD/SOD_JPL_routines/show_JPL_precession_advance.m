function show_JPL_precession_advance(sys_info, ts_s, thetas_s, dyn_names)
% function show_JPL_precession_advance(sys_info, ts_s, thetas_s, dyn_names)

% (C) M. Zhong

x_pos                       = 50;
x_gap                       = 25;
y_pos                       = 50;
width                       = 800;
height                      = 800;
marker_size                 = 2.5;
extra_names                 = {'Venus', 'Earth', 'Moon'};
extra_idx                   = [2, 3, 4];
for idx1 = 1 : length(dyn_names) + length(extra_names)
  win_pos                   = [x_pos + (idx1 - 1) * x_gap, y_pos, width, height];
  if idx1 < length(dyn_names) + 1
    win_name                = ['Precession Adavance: ', dyn_names{idx1}];
    file_name               = sprintf('prec_adva_%s',   dyn_names{idx1});
  else
    win_name                = ['Precession Advance: ', extra_names{idx1 - 4}];
    file_name               = sprintf('prec_adva_%s', extra_names{idx1 - 4});
  end
  WH                        = figure('Name', win_name, 'NumberTitle', 'off', 'Position', win_pos);  
  set(groot,'CurrentFigure', WH);      
  if idx1 > length(dyn_names)
    AHs                     = gobjects(2, 2);
    for idx2 = 1 : length(dyn_names)
      AH                    = subplot(2, 2, idx2);
      set(WH, 'CurrentAxes', AH);
      plot(ts_s{extra_idx(idx1 - 4), idx2}, thetas_s{extra_idx(idx1 - 4), idx2}, '--b', ...
        'MarkerSize', marker_size);
      title(sprintf('%s: %s', sys_info.AO_names{extra_idx(idx1 - 4) + 1}, dyn_names{idx2}));
      if strcmp(sys_info.AO_names{extra_idx(idx1 - 4) + 1}, 'Moon')
        axis([0, 6550, 0, 630000]);
      end
      row_ind               = floor((idx2 - 1)/2) + 1;
      col_ind               = mod(idx2 - 1, 2) + 1;
      AHs(row_ind, col_ind) = AH;      
    end    
  else
    AHs                     = gobjects(3, 3);
    for idx2 = 1 : (sys_info.N - 1)
      AH    = subplot(3, 3, idx2);
      set(WH, 'CurrentAxes', AH)      
      plot(ts_s{idx2, idx1}, thetas_s{idx2, idx1}, '--bo', 'MarkerSize', marker_size);
      title(sprintf('%s', sys_info.AO_names{idx2 + 1}));
      row_ind               = floor((idx2 - 1)/3) + 1;
      col_ind               = mod(idx2 - 1, 3) + 1;
      AHs(row_ind, col_ind) = AH;
    end    
  end
  tightFigaroundAxes(AHs);
  print(WH, file_name, '-painters', '-dpng', '-r600');
end
end