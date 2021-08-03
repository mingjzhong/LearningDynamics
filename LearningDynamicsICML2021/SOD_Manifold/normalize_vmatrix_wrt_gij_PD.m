function vij = normalize_vmatrix_wrt_gij_PD(vij, xi, d)
% function vij = normalize_vmatrix_wrt_gij_PD(vij, xi, d)

% (C) M. Zhong

Ni                 = size(xi, 2);
Nj                 = size(vij, 2);
G                  = riemannian_metric_on_poincare_disk(xi, d);
increment          = kron(0 : d : (Ni - 1) * d, ones(1, d^2));
row_ind            = repmat(repmat(1 : d, [1, d]),   [1, Ni]) + increment;
col_ind            = repmat(kron(1 : d, ones(1, d)), [1, Ni]) + increment;
G                  = sparse(row_ind, col_ind, G, Ni * d, Ni * d, Ni * d^2);
vij_norm           = zeros(Ni, Nj);
vij_new            = vij .* (G * vij);
for idx = 1 : d
  ind              = idx : d : (Ni - 1) * d + idx;
  vij_norm         = vij_norm + vij_new(ind, :);
end
vij_norm           = vij_norm.^(0.5);
ind                = vij_norm == 0;
vij_norm(ind)      = 1;
vij                = smatrix_times_vmatrix(1./vij_norm, vij, d);
end