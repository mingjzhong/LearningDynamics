function geo_dist = geodesic_distance_on_hyperbolic_surface(xi, xj, d)
% function geo_dist = geodesic_distance_on_hyperbolic_surface(xi, xj, d)

% (C) M. Zhong

lorentz_prod      = compute_the_Lorentz_product(xi, xj, d);
ind               = lorentz_prod > -1;  % possible due to small numerical error
lorentz_prod(ind) = -1;
geo_dist          = acosh(-lorentz_prod);
end