function xij = normalize_vmatrix(xij, d)
% function xij = normalize_vmatrix(xij, d)

% (C) M. Zhong

xij_norm      = get_vmatrix_lpnorm(xij, d, 2);
ind           = xij_norm == 0;
xij_norm(ind) = 1;
xij           = smatrix_times_vmatrix(1./xij_norm, xij, d);
end