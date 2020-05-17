function phi_weight = get_phi_weight(x, v, xi, sys_info, learn_info, is_rhoLT)
% function phi_weight = get_phi_weight(x, v, xi, sys_info)

% (C) M. Zhong (JHU)

% check input parameters
if nargin == 4, learn_info = []; is_rhoLT = true; end
[num_kinds, kind_name] = get_phi_kinds(sys_info);
phi_weight             = cell(1, num_kinds);
for ind = 1 : num_kinds
  phi_weight{ind}      = get_phi_weight_each_kind(x, v, xi, kind_name{ind}, sys_info, learn_info, ...
                         is_rhoLT);
end
end