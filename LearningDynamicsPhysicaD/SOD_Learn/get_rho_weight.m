function rho_weight = get_rho_weight(v, xi, agent_info, sys_info, learn_info, is_rhoLT)
% function rho_weight = get_rho_weight(v, xi, agent_info, sys_info, learn_info, is_rhoLT)

% (C) M. Zhong

[num_kinds, kind_name] = get_phi_kinds(sys_info);
rho_weight             = cell(1, num_kinds);
for ind = 1 : num_kinds
  rho_weight{ind}      = get_rho_weight_each_kind(v, xi, agent_info, sys_info, learn_info, is_rhoLT, ...
    kind_name{ind});
end
end