function [phi_range, rho_range] = initialize_range_data(sys_info, learn_info, is_rhoLT, M)
% function range_data = initialize_range_data(sys_info, learn_info, is_rhoLT, M)

% (C) M. Zhong

[num_kinds, kind_names]            = get_phi_kinds(sys_info);
phi_range                          = cell(1, num_kinds);
rho_range                          = cell(1, num_kinds);
for ind = 1 : num_kinds
  [phi_range{ind}, rho_range{ind}] = initialize_range_data_each_kind(sys_info, learn_info, is_rhoLT, ...
    M, kind_names{ind}); 
end
if is_rhoLT, phi_range = []; end
end