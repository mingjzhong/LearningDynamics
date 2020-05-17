function num_Psi_matrices = get_num_Psi_matrices(learn_info)
% function num_Psi_matrices = get_num_Psi_matrices(learn_info)

% (C) M. Zhong

num_Psi_matrices   = 1;
if isfield(learn_info, 'Xibasis_info') && ~isempty(learn_info.Xibasis_info)
  num_Psi_matrices = num_Psi_matrices + 1;
end
end