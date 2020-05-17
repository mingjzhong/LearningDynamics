function show_JPL_apsis_errors(WH, sign_sym, title_sym, dyn_names, ts_err, apsis_err, thetas_err, ...
         plot_info)
% function show_JPL_apsis_errors(WH, sign_sym, title_sym, dyn_names, ts_err, apsis_err, thetas_err, ...
%          plot_info)

% (C) M. Zhong
AHs                       = gobjects(3, 3);
LHs                       = gobjects(1, 2);
theErrs                   = {ts_err, apsis_err, thetas_err};
set(groot,'CurrentFigure', WH);
for idx1 = 1 : length(theErrs)
  for idx2 = 1 : length(theErrs{1})
    idx                   = (idx1 - 1) * length(theErrs{1}) + idx2;
    AH                    = subplot(3, 3, idx);
    AH.FontName           = plot_info.font_name;
    AH.FontSize           = plot_info.tick_size;  
    num_ts                = length(theErrs{1}{1});  
    for idx3 = 1 : num_ts
      if idx1 ~= 2
        if theErrs{idx1}{idx2}(idx3) >= 0, sign_idx = 1; else, sign_idx = 2; end
        plot(idx3, abs(theErrs{idx1}{idx2}(idx3)), sign_sym{sign_idx});
      else
        plot(idx3, theErrs{idx1}{idx2}(idx3), '--ks');  
      end
      if idx3 == 1, hold on; end
    end  
    if idx1 ~= 2
      LHs(1)              = plot(1, NaN, sign_sym{1});
      LHs(2)              = plot(2, NaN, sign_sym{2});
      legH                = legend(LHs, {'Pos. Val.', 'Neg. Val.'});
      set(legH, 'Location', plot_info.legend_loc, 'Interpreter', 'latex', 'FontName', ...
        plot_info.font_name, 'FontSize', plot_info.legend_size);      
    end
    hold off;
    axis tight;
    title([dyn_names{idx2} ': ' title_sym{idx1}], 'FontName', plot_info.font_name, 'FontSize', ...
      plot_info.title_size, 'Interpreter', 'latex');
    row_ind               = floor((idx - 1)/3) + 1;
    col_ind               = mod(idx - 1, 3) + 1;
    AHs(row_ind, col_ind) = AH;
  end
end
tightFigaroundAxes(AHs);
end