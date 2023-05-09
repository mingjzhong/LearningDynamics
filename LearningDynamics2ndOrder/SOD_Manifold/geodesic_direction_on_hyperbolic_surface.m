function vij = geodesic_direction_on_hyperbolic_surface(xi, xj, d)
% function vij = geodesic_direction_on_hyperbolic_surface(xi, xj, d)

% (C) M. Zhong

xixj_lp = compute_the_Lorentz_product(xi, xj, d);
dij     = geodesic_distance_on_hyperbolic_surface(xi, xj, d);
Ni      = size(xi, 2);
Nj      = size(xj, 2);
validateattributes(xi, {'numeric'}, {'size', [d, Ni]});
validateattributes(xj, {'numeric'}, {'size', [d, Nj]});
xi      = repmat(xi(:), 1, Nj);                                                                     % make it [Nid, Nj]
xj      = repmat(xj,   Ni, 1);                                                                      % make it [Nid, Nj]
% vij = dij/sinh(dij) * (xj - cosh(dij) * xi) is the tangent vector
% vij          = xj - smatrix_times_vmatrix(cosh(dij), xi, d);
% ind          = dij == 0;
% sinhdij      = sinh(dij);
% sinhdij(ind) = 1;
% vij          = smatrix_times_vmatrix(dij./sinhdij, vij, d);
% however we just need the directoin, and cosh(dij) = -<xj, xi>_L
% so we use vij = xj + <xj, xi>_L * xi, then normalize, to avoid too much numerical error
vij     = xj + smatrix_times_vmatrix(xixj_lp, xi, d);
vij     = normalize_vmatrix(vij, d);
vij     = smatrix_times_vmatrix(dij, vij, d);
end