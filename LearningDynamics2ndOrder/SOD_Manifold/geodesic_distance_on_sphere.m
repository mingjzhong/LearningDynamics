function geo_dist = geodesic_distance_on_sphere(xi, xj, d, R)
% function geo_dist = geodesic_distance_on_sphere(xi, xj, d, R)

% (C) M. Zhong

Ni             = size(xi, 2);
Nj             = size(xj, 2);
validateattributes(xi, {'numeric'}, {'size', [d, Ni]});
validateattributes(xj, {'numeric'}, {'size', [d, Nj]});
xihat          = get_normalized_matrix(xi, d, Ni);
xihat          = repmat(xihat(:), 1, Nj);                                                           % make it [Nid, Nj]
xjhat          = get_normalized_matrix(xj, d, Nj);
xjhat          = repmat(xjhat, Ni, 1);                                                              % make it [Nid, Nj]
xi_dot_xj      = get_matrix_dot_product(xihat, xjhat, d);
% -1 <= cos(theta) <= 1, but numerical erors can cause it to over-float
ind            = xi_dot_xj > 1;
xi_dot_xj(ind) = 1;
ind            = xi_dot_xj < -1;
xi_dot_xj(ind) = -1;
geo_dist       = acos(xi_dot_xj) * R;
end