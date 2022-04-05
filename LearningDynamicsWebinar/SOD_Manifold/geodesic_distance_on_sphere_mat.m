function geo_dist = geodesic_distance_on_sphere_mat(xi, xihat, d, R)
% function geo_dist = geodesic_distance_on_sphere_mat(xi, xihat, d, R)

% (C) M. Zhong

N              = length(xi)/d;
validateattributes(xi,    {'numeric'}, {'size', [d * N, 1]});
validateattributes(xihat, {'numeric'}, {'size', [d * N, 1]});
xi                = get_normalized_matrix(reshape(xi, [d, N]),    d, N);
xihat             = get_normalized_matrix(reshape(xihat, [d, N]), d, N);
xi_dot_xihat      = sum(xi .* xihat);
% -1 <= cos(theta) <= 1, but numerical erors can cause it to over-float
ind               = xi_dot_xihat > 1;
xi_dot_xihat(ind) = 1;
ind               = xi_dot_xihat < -1;
xi_dot_xihat(ind) = -1;
geo_dist          = acos(xi_dot_xihat)' * R;
end