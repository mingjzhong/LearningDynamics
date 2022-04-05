function x_j_m_x_i = AD_get_difference_of_matrices(x_i, x_j)
% function x_j_m_x_i = AD_get_difference_of_matrices(x_i, x_j)

% (C) M. Zhong
[d, N_i]  = size(x_i);
N_j       = size(x_j, 2);
x_j_vec   = reshape(x_j, [d * N_j, 1]);
x_i_mat   = repmat(x_i, [N_j, 1]);
x_j_mat   = repmat(x_j_vec, [1, N_i]);
x_j_m_x_i = x_j_mat - x_i_mat;
end