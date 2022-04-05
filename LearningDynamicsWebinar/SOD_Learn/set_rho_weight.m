function rho_weight = set_rho_weight(k1, k2, row_in_NkL_mat, rho_weight_at_t, rho_weight)
% function rho_weight = set_rho_weight(k1, k2, row_in_NkL_mat, rho_weight_at_t, rho_weight)

% (C) M. Zhong

num_weights                                    = length(rho_weight_at_t);
for ind = 1 : num_weights
  if ~isempty(rho_weight_at_t{ind})
    rho_weight{ind}{k1, k2}(row_in_NkL_mat, :) = rho_weight_at_t{ind}{k1, k2};
  end
end
end