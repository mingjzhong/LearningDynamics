function xi_jmxi_i = get_xi_j_minus_xi_i(xi_i, xi_j)
% function xiimxij = get_xi_j_minus_xi_i(xi_i, xi_j)

% (C) M. Zhong

if ~iscolumn(xi_i), xi_i = xi_i'; end
if ~isrow(xi_j), xi_j = xi_j'; end
N_xi_i    = length(xi_i);
N_xi_j    = length(xi_j);
xi_i_mat  = repmat(xi_i, [1, N_xi_j]);
xi_j_mat  = repmat(xi_j, [N_xi_i, 1]);
xi_jmxi_i = xi_j_mat - xi_i_mat;
end