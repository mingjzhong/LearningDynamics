function phi_rest_at_t = get_phi_restriction_at_t(x, v, xi, sys_info, is_rhoLT)
% function phi_rest_at_t = get_phi_restriction_at_t(x, v, xi, sys_info, is_rhoLT)

% (C) M. Zhong (JHU)

if is_rhoLT
  phi_rest_at_t          = [];
else
  [num_kinds, kind_name] = get_phi_kinds(sys_info);
  phi_rest_at_t          = cell(1, num_kinds);
  for ind = 1 : num_kinds
    phi_rest_at_t{ind}   = get_phi_restriction_each_kind(x, v, xi, sys_info, kind_name{ind});
  end
end
end