function rhs = get_JPL_EIH_RHS(y, dy, sys_info)
% function rhs = get_JPL_EIH_RHS(y, dy, sys_info)

% (C) M. Zhong

% source: https://en.wikipedia.org/wiki/Einstein%E2%80%93Infeld%E2%80%93Hoffmann_equations

oneBlock    = sys_info.N * sys_info.d;
x           = reshape(y(1 : oneBlock), [sys_info.d, sys_info.N]);                                   % y = [x; v]
v           = reshape(y(oneBlock + 1 : 2 * oneBlock), [sys_info.d, sys_info.N]);
dx          = reshape(dy(1 : oneBlock), [sys_info.d, sys_info.N]);                                  % dy = [dx; dv]
dv          = reshape(dy(oneBlock + 1 : 2 * oneBlock), [sys_info.d, sys_info.N]);
rij         = sqrt(abs(sqdist_mod(x)));                                                             % ||x_i - v_j||_2
xij         = get_pair_diff(x);                                                                     % x_j - x_i
vij         = get_pair_diff(v);                                                                     % v_j - v_i
rel_vijsq   = abs(sqdist_mod(v));                                                                   % ||v_i - v_j||_2^2, relative velocity in \ell_2 norm squared
ind         = logical(eye(sys_info.N));
rijinv      = rij.^(-1);                                                                            % 1/r_{i, j}, when i = j, set it to 0
rijinv(ind) = 0;
xhatij      = smatrix_times_vmatrix(rijinv, xij, sys_info.d);                                       % (x_j - x_i)/r_{i, j}
GMover_rij  = sys_info.G * rijinv .* repmat(sys_info.known_mass, [sys_info.N, 1]);                  % Gm_j/r_{i, j}
Newton      = smatrix_times_vmatrix(GMover_rij .* rijinv, xhatij, sys_info.d);                      % Gm_j/r_{i, j}^2 \cdot (x_j - x_i)/r_{i, j}
dotProd1    = get_matrix_dot_product(xhatij, repmat(v,  [sys_info.N, 1]));                          % <(x_j - x_i)/r_{i, j}, v_j>
dotProd2    = get_matrix_dot_product(xij,    repmat(dv, [sys_info.N, 1]));                          % <x_j - x_i, dv_j>
dotProd3    = get_matrix_dot_product(xhatij, ...
              3 * repmat(v, [sys_info.N, 1]) - 4 * repmat(v(:), [1, sys_info.N]));                  % <(x_j - x_i)/r_{i, j}, 3v_j - 4v_i>
EIH_mod     = 2 * rel_vijsq - repmat(sum(v.^2)', [1, sys_info.N]) - 3/2 * dotProd1.^2 ...           % 2||v_j - v_i||_2^2 - ||v_i||_2^2 - 3/2 * <(x_j - x_i)/r_{i, j}, v_j>^2
              - 4 * repmat(sum(GMover_rij, 2), [1, sys_info.N]) ...                                 % - 4 \sum_k Gm_k/r_{i, k}
              - repmat(sum(GMover_rij), [sys_info.N, 1]) ...                                        % -   \sum_k Gm_k/r_{k, i'}
              + 1/2 * dotProd2;                                                                     % + 1/2 <x_j - x_i, dv_i>
% Einstein-Infeld-Hoffmann equation for \dot{v}_i            
dv_EIH      = Newton + 1/sys_info.c^2 * smatrix_times_vmatrix(EIH_mod, Newton, sys_info.d) ...
              - 1/sys_info.c^2 * smatrix_times_vmatrix(GMover_rij .* rijinv .* dotProd3, vij, sys_info.d) ...
              + 7/(2 * sys_info.c^2) * smatrix_times_vmatrix(GMover_rij, repmat(dv, [sys_info.N, 1]), ...
              sys_info.d);
dv_EIH      = reshape(sum(dv_EIH, 2), [sys_info.d, sys_info.N]);
rhs         = [dx - v, dv - dv_EIH];
rhs         = rhs(:);
end