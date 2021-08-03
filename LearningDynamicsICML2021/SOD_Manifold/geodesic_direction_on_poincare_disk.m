function [vij, Oij] = geodesic_direction_on_poincare_disk(xi, xj, d)
% function [vij, Oij] = geodesic_direction_on_poincare_disk(xi, xj, d)

% (C) M. Zhong

if d ~= 2, error(''); end
r             = 1;  % by default, it is on the unit disk
Ni            = size(xi, 2);
Nj            = size(xj, 2);
validateattributes(xi, {'numeric'}, {'size', [d, Ni]});
validateattributes(xj, {'numeric'}, {'size', [d, Nj]});
% the lines joining (xi, xj) on a Poincare disk is either a straight line if the line segment of
% (xi, xj) in R^2 passes through the origin, or an arc perpendicular to the boundary of the disk
dij           = geodesic_distance_on_poincare_disk(xi, xj, d);
Ri            = (sum(xi.^2) + r^2)/2;
Rj            = (sum(xj.^2) + r^2)/2;
xi            = repmat(xi(:), 1, Nj);                                                               % make it [Nid, Nj]
xj            = repmat(xj,   Ni, 1);                                                                % make it [Nid, Nj]
Rij           = zeros(Ni * d, Nj);
O_ind         = 1 : d : (Ni - 1) * d + 1;
Rij(O_ind, :) = repmat(Ri(:), 1, Nj);
E_ind         = 2 : d : Ni * d;
Rij(E_ind, :) = repmat(Rj, Ni, 1);
% use the Cramer's rule
xij_det       = xi(O_ind, :)  .* xj(E_ind, :)  - xi(E_ind, :)  .* xj(O_ind, :);
Oij_x         = Rij(O_ind, :) .* xj(E_ind, :)  - Rij(E_ind, :) .* xi(E_ind, :);
Oij_y         = xi(O_ind, :)  .* Rij(E_ind, :) - xj(O_ind, :)  .* Rij(O_ind, :);
% if they lie on a straight line through the origin (of PD), then it is the origin, also including 
% the case if they are the same points, just use the orgin
% use the tolerance (1.e-15, just in case they are zero within eps error)
ind1          = abs(xij_det) < 1.e-15;
xij_det(ind1) = 1;
Oij_x(ind1)   = 0;
Oij_y(ind1)   = 0;
Oij           = zeros(Ni * d, Nj);
Oij(O_ind, :) = Oij_x./xij_det;
Oij(E_ind, :) = Oij_y./xij_det;
xjmxi         = xj - xi;
Oijmxi        = Oij - xi;
Oijmxi        = normalize_vmatrix(Oijmxi, d);
xjmxidotOmxi  = get_matrix_dot_product(xjmxi, Oijmxi, d);
vij           = xjmxi - smatrix_times_vmatrix(xjmxidotOmxi, Oijmxi, d);
% if they are on a straight line, just use xj - xi, but not the same point
ind2          = dij ~= 0;
ind           = ind1 & ind2;
ind           = logical(kron(ind, ones(2, 1)));
vij(ind)      = xjmxi(ind);
vij           = normalize_vmatrix_wrt_gij_PD(vij, reshape(xi(:, 1), [d, Ni]), d);
vij           = smatrix_times_vmatrix(dij, vij, d);
end