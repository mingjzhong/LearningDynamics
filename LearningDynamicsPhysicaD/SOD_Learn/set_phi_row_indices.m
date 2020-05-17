function Psi_row_ind = set_phi_row_indices(k, l, Nk, L, row_in_NkL_mat, row_in_NkdL_mat, agent_info, ...
                       sys_info, Psi_row_ind, is_rhoLT)
% function Psi_row_ind = set_phi_row_indices(k, l, Nk, L, row_in_NkL_mat, row_in_NkdL_mat, agent_info, sys_info, Psi_row_ind)

% (C) M. Zhong

if ~is_rhoLT
  num_Psi_mat                           = length(Psi_row_ind);
  if l == 1
    Psi_row_ind{1}{k}                   = zeros(Nk * sys_info.d * L, 1);
    for ind = 2 : num_Psi_mat
      Psi_row_ind{ind}{k}               = zeros(Nk * L, 1);
    end
  end
  Psi_row_ind{1}{k}(row_in_NkdL_mat)    = agent_info.idxs_in_Nd{k} + (l - 1) * sys_info.N * sys_info.d;
  for ind = 2 : num_Psi_mat
    Psi_row_ind{ind}{k}(row_in_NkL_mat) = agent_info.idxs{k} + (l - 1) * sys_info.N;
  end 
end
end