function vij = geodesic_direction_on_sphere(xi, xj, d, R)
% function vij = geodesic_direction_on_sphere(xi, xj, d, R)

% (C) M. Zhong

Ni  = size(xi, 2);
Nj  = size(xj, 2);
validateattributes(xi, {'numeric'}, {'size', [d, Ni]});
validateattributes(xj, {'numeric'}, {'size', [d, Nj]});
xij = repmat(xj, Ni, 1) - repmat(xi(:), 1, Nj);                            % xj - xi
ni  = -repmat(xi(:), 1, Nj);                                               % -xi (points to the origin)
ni  = normalize_vmatrix(ni, d);                                            % normalize them
vij = xij - smatrix_times_vmatrix(get_matrix_dot_product(xij, ni), ni, d); % xij - Proj_{ni}(xij), the tangent direction
vij = normalize_vmatrix(vij, d);                                           % normalize it in L2 norm
dij = geodesic_distance_on_sphere(xi, xj, d, R);                           % the geodecis distant between xi and xj
vij = smatrix_times_vmatrix(dij, vij, d);                                  % wij = dij * vij
end