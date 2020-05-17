function Psi_row_ind = initialize_Psi_row_ind(sys_info, learn_info, is_rhoLT)
% function Psi_row_ind = initialize_Psi_row_ind(sys_info, learn_info, is_rhoLT)

% (C) M. Zhong (JHU)

if is_rhoLT
  Psi_row_ind        = [];
else
  num_Psi_matrices   = get_num_Psi_matrices(learn_info);
  Psi_row_ind        = cell(1, num_Psi_matrices);
  for ind = 1 : num_Psi_matrices
    Psi_row_ind{ind} = cell(1, sys_info.K);
  end
end
end