function [X, Y, Z] = hyperbolic_surface(y_range, z_range, num_pts)
% function [X, Y, Z] = hyperbolic_surface(y_range, z_range, num_pts)

% (C) M. Zhong

y_pts  = linspace(y_range(1), y_range(2), num_pts);
z_pts  = linspace(z_range(1), z_range(2), num_pts);
[Y, Z] = ndgrid(y_pts, z_pts);
X      = sqrt(1 + Y.^2 + Z.^2);
end