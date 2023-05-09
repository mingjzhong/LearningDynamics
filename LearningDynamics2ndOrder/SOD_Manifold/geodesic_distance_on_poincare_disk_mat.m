function geo_dist = geodesic_distance_on_poincare_disk_mat(xi, xihat, d)
% function geo_dist = geodesic_distance_on_poincare_disk_mat(xi, xihat, d)

% (C) M. Zhong

r        = 1;
N        = length(xi)/d;
validateattributes(xi,    {'numeric'}, {'size', [d * N, 1]});
validateattributes(xihat, {'numeric'}, {'size', [d * N, 1]});
xi       = reshape(xi,    [d, N]);
xihat    = reshape(xihat, [d, N]);
% d(xi, xj) = arc-cosh(1 + (2 * |xi - xj|^2 * r^2)/((r^2 - |O - xi|^2) * (r^2 - |O - xj|^2)))
r_L2     = sum((xi - xihat).^2);
Oi       = r^2 - sum(xi.^2);
Oj       = r^2 - sum(xihat.^2);
Oij      = Oi .* Oj;
dij      = 1 + (2 * r_L2 * r^2)./Oij;
ind      = dij < 1;
dij(ind) = 1;
geo_dist = acosh(dij)';
end