function show_JPL_various_dynamics_trajErr(sys_info, dyn_files, trajErr, trajErr_JPL, test_years)
% function show_JPL_various_dynamics_trajErr(sys_info, dyn_files, trajErr, trajErr_JPL, test_years)

% (C) M. Zhong

AO_ind   = [1, 3, 4];
if length(dyn_files) == 6
  line_sty                = {'--bo', '-.rs', ':bd', ':rd', ':kd', ':md'};
elseif length(dyn_files) == 9
  line_sty                = {'--bo', '--ro', '--ko', '-.bd', '-.rd', '-.kd', ':bs', ':rs', ':ks'};
end
err_sym  = {'x', 'v'};
win_h    = figure('Name', 'Traj. Err.: Dynamics (Inner)', 'NumberTitle', 'off', 'Position', ...
           [25, 25, 1600, 800]);
AHs        = gobjects(2, 4);
year_names = {'100 yrs', '200 yrs', '300 yrs', '400 yrs'};
subplot(2, 4, 1);
for idx = 1 : length(dyn_files)
  semilogy(test_years, cellfun(@(x) x(1), trajErr(idx, :)), ...
    line_sty{idx});
  if idx == 1; hold on; end
end
hold off;
title('System: x');
xticks(test_years);
xticklabels(year_names);
AHs(1, 1) = gca;
subplot(2, 4, 5);
for idx = 1 : length(dyn_files)
  semilogy(test_years, cellfun(@(x) x(2), trajErr(idx, :)), ...
    line_sty{idx});
  if idx == 1; hold on; end
end
hold off;
title('System: v');
xticks(test_years);
xticklabels(year_names);
AHs(2, 1) = gca;
for idx1 = 1 : length(err_sym)
  for idx2 = 1 : length(AO_ind)
    idx = (idx1 - 1) * (length(AO_ind) + 1) + idx2 + 1;
    subplot(2, 4, idx);
    for idx3 = 1 : length(dyn_files)
      semilogy(test_years, cellfun(@(x) x(AO_ind(idx2), idx1), trajErr_JPL(idx3, :)), ...
        line_sty{idx3});
      if idx3 == 1; hold on; end
    end
    hold off;
    title(sprintf('%s: %s', sys_info.AO_names{AO_ind(idx2)}, err_sym{idx1}));
    xticks(test_years);
    xticklabels(year_names);
    if idx == 4 || idx == 8, legend(dyn_files, 'Location', 'East'); end
    row_ind               = floor((idx - 1)/4) + 1;
    col_ind               = mod(idx - 1, 4) + 1;
    AHs(row_ind, col_ind) = gca;    
  end
end
tightFigaroundAxes(AHs);
print(win_h, 'trajErr_comp_inner', '-painters', '-dpng', '-r300');
AO_ind   = [7, 8, 9, 10];
win_h    = figure('Name', 'Traj. Err.: Dynamics (Outer)', 'NumberTitle', 'off', 'Position', ...
           [50, 25, 1600, 800]);
for idx1 = 1 : length(err_sym)
  for idx2 = 1 : length(AO_ind)
    idx = (idx1 - 1) * length(AO_ind) + idx2;
    subplot(2, 4, idx);
    for idx3 = 1 : length(dyn_files)
      semilogy(test_years, cellfun(@(x) x(AO_ind(idx2), idx1), trajErr_JPL(idx3, :)), ...
        line_sty{idx3});
      if idx3 == 1; hold on; end
    end
    hold off;
    title(sprintf('%s: %s', sys_info.AO_names{AO_ind(idx2)}, err_sym{idx1}));
    xticks(test_years);
    xticklabels(year_names);
    if idx == 3 || idx == 7, legend(dyn_files, 'Location', 'East'); end
    row_ind               = floor((idx - 1)/4) + 1;
    col_ind               = mod(idx - 1, 4) + 1;
    AHs(row_ind, col_ind) = gca;    
  end
end  
tightFigaroundAxes(AHs);
print(win_h, 'trajErr_comp_outer', '-painters', '-dpng', '-r300');
end