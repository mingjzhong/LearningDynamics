function Lorentz_prod = compute_the_Lorentz_product(xi, xj, d)
% function Lorentz_prod = compute_the_Lorentz_product(xi, xj, d)

% (C) M. Zhong

Ni           = size(xi, 2);
Nj           = size(xj, 2);
validateattributes(xi, {'numeric'}, {'size', [d, Ni]});
validateattributes(xj, {'numeric'}, {'size', [d, Nj]});
% d_vec        = ones(d, 1);
% d_vec(1)     = -1;
% D_mat        = spdiags(d_vec, 0, d, d);
% xi           = D_mat * xi;
xi(1, :)     = -xi(1, :);
xi           = repmat(xi(:), 1, Nj);                                                                % make it [Nid, Nj]
xj           = repmat(xj,   Ni, 1);                                                                 % make it [Nid, Nj]
Lorentz_prod = get_matrix_dot_product(xi, xj, d);
end