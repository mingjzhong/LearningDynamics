function plot_manifold(WH, AH, sys_info, plot_info)
% function plot_manifold(WH, AH, sys_info, plot_info)

% (C) M. Zhong

set(WH, 'CurrentAxes', AH);
resolution    = 500;
transparency  = 0.1;
switch sys_info.manifold_type
  case 'S1'
    theta     = linspace(0, 2 * pi, resolution + 1);
    x         = sys_info.R * cos(theta);
    y         = sys_info.R * sin(theta);
    patch([x, NaN], [y, NaN], plot_info.color_gray, 'LineStyle', '--', 'LineWidth', ...
      plot_info.traj_line_width, 'EdgeAlpha', transparency);    
  case 'S2'
    [X, Y, Z] = sphere(resolution);
    surf(sys_info.R * X, sys_info.R * Y, sys_info.R * Z, 'FaceColor', plot_info.color_gray, ...
        'FaceAlpha', transparency, 'EdgeColor', 'none', 'EdgeAlpha', 0);
  case 'H2'
    [X, Y, Z] = hyperbolic_surface(plot_info.y_range, plot_info.z_range, resolution);
    surf(X, Y, Z, 'FaceColor', plot_info.color_gray, 'FaceAlpha', transparency, 'EdgeColor', ...
      'none', 'EdgeAlpha', 0);    
  case 'PD'
    theta     = linspace(0, 2 * pi, resolution + 1);
    x         = cos(theta);
    y         = sin(theta);
    patch([x, NaN], [y, NaN], plot_info.color_gray, 'LineStyle', '--', 'LineWidth', ...
      plot_info.traj_line_width, 'EdgeAlpha', transparency);     
  otherwise
    error('');
end
end