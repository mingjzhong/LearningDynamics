function num_states = calculate_sys_states(sys_info)
% function num_states = calculate_sys_states(sys_info)

% (C) M. Zhong

if sys_info.ode_order == 1
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    num_states = 3;
  else
    num_states = 1;
  end
elseif sys_info.ode_order == 2
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    num_states = 4;
  else
    num_states = 3;
  end  
end
end