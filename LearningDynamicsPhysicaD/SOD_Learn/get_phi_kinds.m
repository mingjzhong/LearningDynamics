function [num_kinds, kind_name] = get_phi_kinds(sys_info)
% function [num_kinds, kind_name] = get_phi_kinds(sys_info)

% (C) M. Zhong (JHU


if sys_info.ode_order == 1
  num_kinds = 2;
  kind_name = {'energy', 'xi'};
elseif sys_info.ode_order == 2
  num_kinds = 3;
  kind_name = {'energy', 'alignment', 'xi'};
end
end