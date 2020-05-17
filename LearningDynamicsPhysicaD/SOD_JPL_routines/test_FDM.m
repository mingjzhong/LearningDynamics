function test_FDM()
% function test_FDM()

% (C) M. Zhong

f                     = @(x) sin(x);
df                    = @(x) cos(x);
pts                   = [0, pi/6, pi/4, pi/3, pi/2];
leg_names             = {'$x = 0$', '$x = \frac{\pi}{6}$', '$x = \frac{\pi}{4}$', ...
                         '$x = \frac{\pi}{3}$', '$x = \frac{\pi}{2}$'};
types                 = {'-.ch', '-.bo', '-.rs', '-.kd', '-.mp'};
hs                    = 10.^(-1 : -1 : -16);
df_errs_h             = zeros(length(pts), length(hs));
df_errs_hsq           = zeros(length(pts), length(hs));
for idx = 1 : length(pts)
  df_errs_h(idx, :)   = abs((f(pts(idx) + hs) - f(pts(idx)))./hs - df(pts(idx)));
  df_errs_hsq(idx, :) = abs((f(pts(idx) + hs) - f(pts(idx) - hs))./(2 * hs) - df(pts(idx)));
%   if df(pts(idx)) > 1e-16 % cos(pi/2) = 6.1232e-17
%     df_Rerrs(idx, :) = df_Aerrs(idx, :)/abs(df(pts(idx)));
%   else
%     df_Rerrs(idx, :) = df_Aerrs(idx, :);
%   end
end
line_h                = gobjects(length(pts), 1);
AHs                   = gobjects(1, 2);
font_name             = 'Helvetica';
tick_size             = 12;
legend_size           = 18;
title_size            = 18;
% label_size           = 20;
win_h                 = figure('Name', 'FDM Test', 'NumberTitle', 'off', 'Position', ...
                        [50, 50, 1600, 800]);
AHs(1)                = subplot(1, 2, 1);
AHs(1).FontName       = font_name;
AHs(1).FontSize       = tick_size;
for idx = 1 : length(pts)
  line_h(idx)         = loglog(hs, df_errs_h(idx, :), types{idx});
  if idx == 1, hold on; end
end
hold off;
set(gca, 'XDir','reverse');
leg_h                = legend(line_h, leg_names);
set(leg_h, 'interpreter', 'latex', 'Location', 'North', 'FontName', font_name, 'FontSize', ...
  legend_size);
title('Abs. Err. $\mathcal{O}(h)$', 'interpreter', 'latex', 'FontName', font_name, 'FontSize', title_size);
AHs(2)               = subplot(1, 2, 2);
AHs(2).FontName      = font_name;
AHs(2).FontSize      = tick_size;
for idx = 1 : length(pts)
  line_h(idx)        = loglog(hs, df_errs_hsq(idx, :), types{idx});
  if idx == 1, hold on; end
end
hold off;
set(gca, 'XDir','reverse');
leg_h                = legend(line_h, leg_names);
set(leg_h, 'interpreter', 'latex', 'Location', 'North', 'FontName', font_name, 'FontSize', ...
  legend_size);
title('Abs. Err. $\mathcal{O}(h^2)$', 'interpreter', 'latex', 'FontName', font_name, 'FontSize', title_size);
tightFigaroundAxes(AHs);
print(win_h, 'FDM_limit', '-painters', '-dpng', '-r600');
end