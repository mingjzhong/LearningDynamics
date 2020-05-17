function set_JPL_AD_plot(WH, AH, title_name, rel_err, abs_err, names, num_years, plot_info)
% function set_JPL_AD_plot(WH, AH, title_name, rel_err, abs_err, names, num_years, plot_info)

% (C) M. Zhong

N           = length(names);
set(groot,'CurrentFigure', WH);
set(WH, 'CurrentAxes', AH)
semilogy(1 : N, rel_err, '--bo');
hold on;
semilogy(1 : N, abs_err, '-.rd');
hold off;
AH.FontSize = plot_info.tick_size;
AH.FontName = plot_info.font_name;
xticks(1 : N);
xticklabels(names);
LH          = legend('Max Rel. $\ell_2$ Err.', 'Max Abs. $\ell_2$ Err.', ...
              'Location', 'Best');
set(LH, 'interpreter', 'latex', 'FontName', plot_info.font_name, 'FontSize', plot_info.legend_size);
% ylabel('$\max_t\frac{|\tilde{v}_i(t) - v_i(t)|_2}{|v_i(t)|_2}$', 'interpreter', 'latex', ...
%   'FontName', font_name, 'FontSize', label_size);
title([title_name sprintf(':%d years', num_years)], 'interpreter', 'latex', 'FontName', ...
  plot_info.font_name, 'FontSize', plot_info.title_size);
axis([1, N, min([min(rel_err), min(abs_err)]) * 0.95, ...
  max([max(rel_err), max(abs_err)]) * 1.05]);
end