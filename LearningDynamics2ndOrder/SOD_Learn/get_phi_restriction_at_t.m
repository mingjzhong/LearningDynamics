function phi_rest_at_t = get_phi_restriction_at_t(x, v, xi, sys_info)
% function phi_rest_at_t = get_phi_restriction_at_t(x, v, xi, sys_info)

% (C) M. Zhong (JHU)

[num_kinds, kind_name] = get_phi_or_rho_kinds(sys_info, 'phi');
phi_rest_at_t          = cell(1, num_kinds);
for ind = 1 : num_kinds
  phi_rest_at_t{ind}   = get_phi_restriction_each_kind(x, v, xi, sys_info, kind_name{ind});
end
end