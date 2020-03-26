function theta = find_pair_angle(x, v)
% theta = find_pair_angle(x, v)

% (c) M. Zhong

[d, N]                     = size(x);
v_vec                      = reshape(v, [d * N, 1]);
x_pdiff                    = find_pair_diff(x);
v_mat                      = repmat(v_vec, [1, N]);
the_prod                   = x_pdiff .* v_mat; 
xdiff_dot_v                = the_prod(1 : d : (N - 1) * d + 1, :);
for d_idx = 2 : d
  xdiff_dot_v              = xdiff_dot_v + the_prod(d_idx : d : (N - 1) * d + d_idx, :);
end
pdist_mat                  = sqrt(abs(sqdist_mod(x)));
pdist_zero                 = pdist_mat == 0;
v_norm                     = sqrt(sum(v.^0.5));
vnorm_zero                 = v_norm == 0;
the_factors                = spdiags(v_norm', 0, N, N) * pdist_mat;
the_factors(pdist_zero)    = 1;
the_factors(vnorm_zero, :) = 1;
theta                      = acos(xdiff_dot_v ./ the_factors);
end