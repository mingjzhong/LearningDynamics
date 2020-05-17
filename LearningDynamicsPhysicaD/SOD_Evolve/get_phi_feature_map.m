function pdist_data = get_phi_feature_map(x, v, xi, agent_info, sys_info, learn_info, is_rhoLT)
% function pdist_data = get_phi_feature_map(x, v, xi, sys_info)

% (C) M. Zhong (JHU)

if nargin == 5, learn_info = []; is_rhoLT = true; end
[num_kinds, kind_name] = get_phi_kinds(sys_info);
pdist_data             = cell(1, num_kinds);
for ind = 1 : num_kinds
  pdist_data{ind}      = get_phi_feature_map_each_kind(x, v, xi, agent_info, sys_info, learn_info, ...
    is_rhoLT, kind_name{ind});
end
end