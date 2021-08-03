function phi_rest = initialize_phi_restriction(sys_info)
% function phi_res = initialize_phi_restriction(sys_info)

% (C) M. Zhong (JHU)
                      
[num_kinds, kind_name] = get_phi_or_rho_kinds(sys_info, 'phi');
phi_rest               = cell(1, num_kinds);
for ind = 1 : num_kinds
  phi_rest{ind}        = initialize_phi_restriction_each_kind(kind_name{ind}, sys_info);
end
end