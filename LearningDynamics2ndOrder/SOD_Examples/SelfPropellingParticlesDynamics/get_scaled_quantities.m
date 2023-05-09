function [R_hat, Rijs, V_hat, Vjs] = get_scaled_quantities(x, v, d, N)
% function [R_hat, Rijs, V_hat, V_js] = get_scaled_quantities(x, v, d, N)

% (C) M. Zhong (JHU)

[v_hat, vjs]  = normalized_matrix_of_vectors(v, d);
V_hat         = repmat(v_hat, [N, 1]);
Vjs           = repmat(vjs,   [N, 1]);
ximxj         = get_xi_minus_xj(x, d, N);
[R_hat, Rijs] = normalized_matrix_of_vectors(ximxj, d);
end