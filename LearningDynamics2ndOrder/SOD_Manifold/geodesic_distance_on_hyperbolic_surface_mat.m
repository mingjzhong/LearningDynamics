function geo_dist = geodesic_distance_on_hyperbolic_surface_mat(xi, xihat, d)
% function geo_dist = geodesic_distance_on_hyperbolic_surface_mat(xi, xihat, d)

% (C) M. Zhong

N                 = length(xi)/d;
xi                = reshape(xi,    [d, N]);
xihat             = reshape(xihat, [d, N]);
xi(1, :)          = -xi(1, :);
lorentz_prod      = sum(xi .* xihat);
ind               = lorentz_prod > -1;  % possible due to small numerical error
lorentz_prod(ind) = -1;
geo_dist          = acosh(-lorentz_prod)';
end