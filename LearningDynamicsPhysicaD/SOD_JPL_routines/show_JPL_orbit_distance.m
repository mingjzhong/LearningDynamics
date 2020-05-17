function show_JPL_orbit_distance(sys_info, t_day, r_days, dyn_names)
% function show_JPL_orbit_distance(sys_info, t_day, r_days, dyn_names)

% (C) M. Zhong

x_pos                       = 50;
x_gap                       = 25;
y_pos                       = 50;
width                       = 800;
height                      = 800;
for idx1 = 1 : length(dyn_names) + 1
  win_pos                   = [x_pos + (idx1 - 1) * x_gap, y_pos, width, height];
  if idx1 < length(dyn_names) + 1
    win_name                = ['Orbit Distance: ' dyn_names{idx1}];
    file_name               = sprintf('orbit_dist_%s', dyn_names{idx1});
  else
    win_name                = 'Orbit Distance: Neptune';
    file_name               = 'orbit_dist_Neptune';
  end
  WH                        = figure('Name', win_name, 'NumberTitle', 'off', 'Position', win_pos);
  set(groot,'CurrentFigure', WH);   
  if idx1 == length(dyn_names) + 1
    AHs = gobjects(2, 2);
    for idx2 = 1 : length(dyn_names)
      AH                    = subplot(2, 2, idx2);
      set(WH, 'CurrentAxes', AH);
      plot(t_day, r_days{9, idx2}, 'b');
      title(sprintf('%s: %s', sys_info.AO_names{sys_info.N}, dyn_names{idx2}));
      row_ind               = floor((idx2 - 1)/2) + 1;
      col_ind               = mod(idx2 - 1, 2) + 1;
      AHs(row_ind, col_ind) = AH;      
    end
  else
    AHs                     = gobjects(3, 3);
    for idx2 = 1 : (sys_info.N - 1)
      AH                    = subplot(3, 3, idx2);
      set(WH, 'CurrentAxes', AH);      
      plot(t_day, r_days{idx2, idx1}, 'b');
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