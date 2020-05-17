function show_JPL_various_dynamics_comparison(sys_info, dyn_files, trajErr_JPL, PRErr, test_years)
% function show_JPL_various_dynamics_comparison(sys_info, dyn_files, trajErr_JPL, PRErr, test_years)

% (C) M. Zhong

AO_ind                    = [2, 5, 6];
if length(dyn_files) == 6
  line_sty                = {'--bo', '-.rs', ':bd', ':rd', ':kd', ':md'};
elseif length(dyn_files) == 9
  line_sty                = {'--bo', '--ro', '--ko', '-.bd', '-.rd', '-.kd', ':bs', ':rs', ':ks'};
end
err_sym                   = {'x', 'v'};
win_h                     = figure('Name', 'Comparison: Dynamics', 'NumberTitle', 'off', 'Position', ...
                            [25, 25, 950, 950]);
AHs                       = gobjects(3, 3);
year_names                = {'100 yrs', '200 yrs', '300 yrs', '400 yrs'};
for idx1 = 1 : length(err_sym)
  for idx2 = 1 : length(AO_ind)
    idx  = (idx1 - 1) * length(AO_ind) + idx2;
    subplot(3, 3, idx);
    for idx3 = 1 : length(dyn_files)
      semilogy(test_years, cellfun(@(x) x(AO_ind(idx2), idx1), trajErr_JPL(idx3, :)), ...
        line_sty{idx3});
      if idx3 == 1, hold on; end
    end
    hold off;
    if idx == 1, legend(dyn_files); end
    title(sprintf('%s: %s', sys_info.AO_names{AO_ind(idx2)}, err_sym{idx1}));
    xticks(test_years);
    xticklabels(year_names);
    row_ind               = floor((idx - 1)/3) + 1;
    col_ind               = mod(idx - 1, 3) + 1;
    AHs(row_ind, col_ind) = gca;
  end
end
for idx1 = 1 : length(AO_ind)
  idx                     = 6 + idx1;
  subplot(3, 3, idx);
  for idx2 = 1 : length(dyn_files)
    semilogy(test_years, cellfun(@(x) x(AO_ind(idx1) - 1), PRErr(idx2, :)), ...
      line_sty{idx2});
    if idx2 == 1; hold on; end
  end
  hold off;
  title(sprintf('%s: PR Err.', sys_info.AO_names{AO_ind(idx1)}));
  xticks(test_years);
  xticklabels(year_names);
  row_ind                 = floor((idx - 1)/3) + 1;
  col_ind                 = mod(idx - 1, 3) + 1;
  AHs(row_ind, col_ind)   = gca;  
end
tightFigaroundAxes(AHs);
print(win_h, 'Mercury_Moon_Mars_comp', '-painters', '-dpng', '-r300');
end