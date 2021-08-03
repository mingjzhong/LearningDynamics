function r_plus_V = get_the_r_plus_V_map(x, v, xi, agent_info, sys_info)
% function r_plus_V = get_the_r_plus_V_map(x, v, xi, agent_info, sys_info)

% (C) M. Zhong

riip                          = get_distance_between_xi_and_xip(x, sys_info); 
r_plus_V                      = cell(sys_info.K);
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if isfield(sys_info, 'V_map') && ~isempty(sys_info.V_map) && ~isempty(sys_info.V_map{k1, k2})
      r_plus_V{k1, k2}        = cell(1, 1 + sys_info.V_dim(k1, k2));
    else
      r_plus_V{k1, k2}        = cell(1);
    end
    states                    = get_states_Ck1Ck2(x, v, xi, k1, k2, agent_info);
    for idx = 1 : length(r_plus_V{k1, k2})
      if idx == 1
        r_plus_V{k1, k2}{1}   = riip(agent_info.type_idx{k1}, agent_info.type_idx{k2});
      else
        r_plus_V{k1, k2}{idx} = sys_info.V_map{k1, k2}{idx - 1}(states{1}, states{2});
      end
    end
  end
end
end