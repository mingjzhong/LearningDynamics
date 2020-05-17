function show_JPL_precession_orbit()
% function show_JPL_precession_orbit()

% (C) M. Zhong
% taken from https://physics.stackexchange.com/questions/366830/mercurys-perihelion-precession
% with modification
a      = 5; 
b      = 3;  
v1     = 4; 
v2     = 1/10; 
x      = @(t) (sqrt(a^2 - b^2) + a * cos(2 * pi * v1 * t)) .* cos(2 * pi * v2 * t) - ...
         b * sin(2 * pi * v1 * t) .* sin(2 * pi * v2 * t); 
y      = @(t) (sqrt(a^2 - b^2) + a * cos(2 * pi * v1 * t)) .* sin(2 * pi * v2 * t) + ...
         b * sin(2 * pi * v1 * t) .* cos(2 * pi * v2 * t);
ts     = linspace(0, 1.6, 1001);
ta     = [0,   1/4, 1/2, 3/4, 1]; 
tp     = [1/8, 3/8, 5/8, 7/8, 9/8];
win_h  = figure('Name', 'Precession', 'NumberTitle', 'off', 'Position', ...
         [50, 50, 800, 800]);
leg_h  = gobjects(1, 2);
plot(x(ts), y(ts), 'r');
hold on;
plot(0.01, -0.07, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'r');
for idx = 1 : length(ta)
  LH   = plot(x(ta(idx)),  y(ta(idx)), 'go', 'MarkerSize', 3, 'MarkerFaceColor', 'g', ...
    'MarkerEdgeColor', 'k');
  if idx == 1, leg_h(1) = LH; end
  LH   = plot(x(tp(idx)),  y(tp(idx)), 'co', 'MarkerSize', 3, 'MarkerFaceColor', 'c', ...
    'MarkerEdgeColor', 'k');
  if idx == 1, leg_h(2) = LH; end
  plot([x(ta(idx)), x(tp(idx))], [y(ta(idx)), y(tp(idx))], '--b');
  text(x(ta(idx)), y(ta(idx)), sprintf('  t = %.2f', ta(idx)))
end
hold off;
title('Precession of some orbit');
legend(leg_h, {'Aphelion', 'Perihelion'}, 'Location', 'Best');
tightFigaroundAxes(gca);
print(win_h, 'orbit_prec', '-painters', '-dpng', '-r600');
end