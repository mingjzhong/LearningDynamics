function geo_dist = geodesic_distance_on_poincare_disk(xi, xj, d)
% function geo_dist = geodesic_distance_on_poincare_disk(xi, xj, d)

% (C) M. Zhong

r        = 1;
Ni       = size(xi, 2);
Nj       = size(xj, 2);
validateattributes(xi, {'numeric'}, {'size', [d, Ni]});
validateattributes(xj, {'numeric'}, {'size', [d, Nj]});
% d(xi, xj) = arc-cosh(1 + (2 * |xi - xj|^2 * r^2)/((r^2 - |O - xi|^2) * (r^2 - |O - xj|^2)))
rij      = sqrt(abs(sqdist_mod(xi, xj)));
Oi       = (r^2 - sum(xi.^2))';
Oj       = r^2 - sum(xj.^2);
Oij      = Oi * Oj;
dij      = 1 + (2 * rij.^2 * r^2)./Oij;
ind      = dij < 1;
dij(ind) = 1;
geo_dist = acosh(dij);
end