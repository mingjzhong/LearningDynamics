function rho_pdist = initialize_rho_data(sys_info)
% function rho_pdist = initialize_rho_data(sys_info)

% (C) M. Zhong (JHU)

[num_kinds, kind_names] = get_phi_or_rho_kinds(sys_info, 'rho');
rho_pdist               = cell(1, num_kinds);
for ind = 1 : num_kinds
  rho_pdist{ind}        = initialize_rho_data_each_kind(sys_info, kind_names{ind}); 
end
end