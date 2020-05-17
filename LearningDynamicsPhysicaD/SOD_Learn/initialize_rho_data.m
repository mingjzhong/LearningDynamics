function rho_pdist = initialize_rho_data(sys_info, learn_info, is_rhoLT)
% function rho_pdist = initialize_rho_data(sys_info, learn_info, is_rhoLT)

% (C) M. Zhong (JHU)

[num_kinds, kind_name] = get_phi_kinds(sys_info);
rho_pdist              = cell(1, num_kinds);
for ind = 1 : num_kinds
  rho_pdist{ind}       = initialize_rho_data_each_kind(sys_info, learn_info, is_rhoLT, kind_name{ind}); 
end
end