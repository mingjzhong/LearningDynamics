function ximxj = get_xi_minus_xj(x, d, N)
% function ximxj = get_xi_minus_xj(x, d, N)

% (C) M. Zhong

% % validate parameters
% validateattributes(d, {'numerics'}, {'positive', '>=', '1'}, 'find_xi_minus_xj', 'd', 2);
% validateattributes(N, {'numerics'}, {'positive', '>=', '1'}, 'find_xi_minus_xj', 'N', 3);
% validateattributes(x, {'numerics'}, {'size',     [d, N]},    'find_xi_minus_xj', 'x', 1);

% find xi - xj
xi_vec = reshape(x, [N * d, 1]);
xi_mat = repmat(xi_vec, [1, N]);
xj_mat = repmat(x, [N, 1]);
ximxj  = xi_mat - xj_mat;
end