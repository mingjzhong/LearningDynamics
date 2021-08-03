function phi_weight = get_phi_weight(x, v, xi, sys_info)
% function phi_weight = get_phi_weight(x, v, xi, sys_info)

% (C) M. Zhong (JHU)

[num_kinds, kind_name] = get_phi_or_rho_kinds(sys_info, 'phi');
phi_weight             = cell(1, num_kinds);
for ind = 1 : num_kinds
  phi_weight{ind}      = get_phi_weight_each_kind(x, v, xi, kind_name{ind}, sys_info);
end
end