function sys_var_len = calculate_sys_var_len(sys_info)
% function sys_var_len = calculate_sys_var_len(sys_info)
%   finds out the length of the system variable y = (x, and/or v, and/or xi)^T for a self-organized 
%   dynamical system.
% IN:
%   sys_info    :
% OUT: 
%   sys_var_len :

% (c), M. Zhong (JHU)

if sys_info.ode_order == 1
  sys_var_len = sys_info.d * sys_info.N;                                                            % first order system, contains only x, size (d * N, 1)
elseif sys_info.ode_order == 2
  if sys_info.has_xi
    sys_var_len = 2 * sys_info.d * sys_info.N + sys_info.N;                                         % second order system with xi, contains x, v and xi, size (2 * d * N + N, 1)
  else
    sys_var_len = 2 * sys_info.d * sys_info.N;                                                      % second order system without xi, contains x and v, size (2 * d * N, 1)
  end
end
end