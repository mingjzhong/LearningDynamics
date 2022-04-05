function feature_map = get_feature_map_of_states_Ck1Ck2(states, sys_info, k1, k2)
% function feature_map = get_feature_map_of_states_Ck1Ck2(states, sys_info, k1, k2)

% (C) M. Zhong

% these are of size (d, N_1) or (1, N_1)
xi                               = states{1}{1}';
% vi                               = states{1}{2}';
% xii                              = states{1}{3}';
Ni                               = size(xi, 1);
% these are of size (d, N_2) or (1, N_2)
xj                               = states{2}{1}';
% vj                               = states{2}{2}';
% xij                              = states{2}{3}';
Nj                               = size(xj, 1);
if k1 == k2
  diag_idx                       = logical(eye(Ni));
end
xisq                             = xi .* xi;
xjsq                             = xj .* xj;
xi1dxi2                          = xi(:, 1) .* xi(:, 2);
xi1dxj1                          = xi(:, 1) * (xj(:, 1)');
xi1dxj2                          = xi(:, 1) * (xj(:, 2)');
xi2dxj1                          = xi(:, 2) * (xj(:, 1)');
xi2dxj1                          = xi2dxj1(:);
xi2dxj2                          = xi(:, 2) * (xj(:, 2)');
xj1dxj2                          = xj(:, 1) .* xj(:, 2);
Y                                = [repmat(xi, [Nj, 1]), kron(xj, ones(Ni, 1)), ...
                                    repmat(xisq, [Nj, 1]), kron(xjsq, ones(Ni, 1)), ...
                                    repmat(xi1dxi2, [Nj, 1]), xi1dxj1(:), xi1dxj2(:), ...
                                    xi2dxj1(:), xi2dxj2(:), kron(xj1dxj2, ones(Ni, 1))];
E_dim                            = size(sys_info.B_E{k1, k2}, 2);
feature_map                      = cell(1, E_dim);
Var                              = Y * sys_info.B_E{k1, k2};
for idx = 1 : E_dim
  feature_map{idx}               = reshape(Var(:, idx), Ni, Nj);
  if k1 == k2, feature_map{idx}(diag_idx) = 0; end
end
end