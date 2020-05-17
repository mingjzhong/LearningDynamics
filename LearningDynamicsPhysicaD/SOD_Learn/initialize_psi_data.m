function [psi_pdist, psi_pdiff] = initialize_psi_data(sys_info, learn_info, is_rhoLT)
% function [psi_pdist, psi_pdiff] = initialize_psi_data(sys_info, learn_info, is_rhoLT)

% (C) M. Zhong (JHU)

if is_rhoLT
  psi_pdist                          = [];
  psi_pdiff                          = [];
else
  [num_kinds, kind_name]             = get_phi_kinds(sys_info);
  psi_pdist                          = cell(1, num_kinds);
  psi_pdiff                          = cell(1, num_kinds);
  for ind = 1 : num_kinds
    [psi_pdist{ind}, psi_pdiff{ind}] = initialize_psi_data_each_kind(sys_info, learn_info, is_rhoLT, ...
      kind_name{ind}); 
  end  
end