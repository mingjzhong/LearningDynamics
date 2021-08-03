function sij = AD_get_sij(state_i, state_j)
% function sij = AD_get_sij(state_i, state_j)

% (C) M. Zhong

[d, N_i]  = size(state_i{1});
N_j       = size(state_j{1}, 2);
x_j_m_x_i = AD_get_difference_of_matrices(state_i{1}, state_j{1});
v_j_m_v_i = AD_get_difference_of_matrices(state_i{2}, state_j{2});
sij       = zeros(N_i, N_j);
for d_idx = 1 : d
  ind     = d_idx : d : d * (N_i - 1) + d_idx;
  sij     = sij + x_j_m_x_i(ind, :) .* v_j_m_v_i(ind, :);
end
end