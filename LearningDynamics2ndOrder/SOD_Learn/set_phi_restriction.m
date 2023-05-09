function phi_rest = set_phi_restriction(k1, k2, agent_info, row_in_NkL_mat, phi_rest_l, phi_rest)
% function phi_rest = set_phi_restriction(k1, k2, agent_info, row_in_NkL_mat, phi_rest_l, phi_rest)

% (C) M. Zhong

if ~isempty(phi_rest_l)
  for ind = 1 : length(phi_rest_l)
    if ~isempty(phi_rest_l{ind})
      phi_rest{ind}{k1, k2}(row_in_NkL_mat, :) = phi_rest_l{ind}(agent_info.idxs{k1}, ...
                                                 agent_info.idxs{k2});
    end
  end
end
end