function AH = set_JPL_vi_and_ai_plot(WH, title_name, names, num_years, x_vals, xi, vi, ai, plot_info)
% function AH = set_JPL_vi_and_ai_plot(WH, title_name, names, num_years, x_vals, xi, vi, ai, plot_info)

% (C) M. Zhong

set(groot,'CurrentFigure', WH);
semilogy(x_vals, xi, ':kd');
AH          = gca;
hold on;
semilogy(x_vals, vi, '--bo');
semilogy(x_vals, ai, '-.rs');
hold off;
AH.FontSize = plot_info.tick_size;
AH.FontName = plot_info.font_name;
xticks(x_vals);
xticklabels(names);
LH          = legend('Max. $x_i$ in $\ell_2$', 'Max. $v_i$ in $\ell_2$', ...
              'Max. $a_i$ in $\ell_2$', 'Location', 'Best');
set(LH, 'interpreter', 'latex', 'FontName', plot_info.font_name, 'FontSize', plot_info.legend_size);
title([title_name sprintf(':%d years', num_years)], 'interpreter', 'latex', 'FontName', ...
  plot_info.font_name, 'FontSize', plot_info.title_size);
axis([x_vals(1), x_vals(end), min([min(xi), min(vi), min(ai)]) * 0.95, ...
  max([max(xi), max(vi), max(ai)]) * 1.05]);
end