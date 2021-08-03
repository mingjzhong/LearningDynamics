function [psi_pdist, psi_pdiff] = initialize_psi_data(sys_info)
% function [psi_pdist, psi_pdiff] = initialize_psi_data(sys_info)

% (C) M. Zhong (JHU)

[num_kinds, kind_names]            = get_phi_or_rho_kinds(sys_info, 'phi');
psi_pdist                          = cell(1, num_kinds);
psi_pdiff                          = cell(1, num_kinds);
for ind = 1 : num_kinds
  [psi_pdist{ind}, psi_pdiff{ind}] = initialize_psi_data_each_kind(sys_info, kind_names{ind}); 
end  
end