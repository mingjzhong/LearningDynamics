function sys_var_len = calculate_sys_var_len(sys_info)
% function sys_var_len = calculate_sys_var_len(sys_info)
%   finds out the length of the system variable y = (x, and/or v, and/or xi)^T for a self-organized 
%   dynamical system.
% IN:
%   sys_info    :
% OUT: 
%   sys_var_len :

% (c), M. Zhong (JHU)
 
if sys_info.ode_order == 1                                                                          % x \in \R^{Nd}, xi \in \R^{N}
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    sys_var_len = sys_info.d * sys_info.N + sys_info.N;                                             % y = (x, xi)
  else
    sys_var_len = sys_info.d * sys_info.N;                                                          % y = (x)
  end
elseif sys_info.ode_order == 2                                                                      % x, v \in \R^{Nd}, xi \in \R^{N}
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    sys_var_len = 2 * sys_info.d * sys_info.N + sys_info.N;                                         % y = (x, v, xi)
  else
    sys_var_len = 2 * sys_info.d * sys_info.N;                                                      % y = (x, v)
  end
end
end