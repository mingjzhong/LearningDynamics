function phi_map = get_phi_feature_map_each_kind(x, v, xi, agent_info, sys_info, learn_info, is_rhoLT, kind)
% function phi_map = get_phi_feature_map_each_kind(x, v, xi, agent_info, sys_info, learn_info, is_rhoLT, kind)

% (C) M. Zhong

phi_dim               = get_phi_and_rho_dim_each_kind(kind, sys_info, learn_info, is_rhoLT);
phi_map               = [];
if ~isempty(phi_dim)
  phi_map             = cell(sys_info.K);                                         
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      states          = get_states_Ck1Ck2(x, v, xi, k1, k2, agent_info);
      phi_map{k1, k2} = get_phi_feature_map_each_kind_Ck1Ck2(states, sys_info, kind);
    end
  end
end
end