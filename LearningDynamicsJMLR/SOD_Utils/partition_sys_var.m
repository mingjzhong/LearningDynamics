function state_vars = partition_sys_var(y, sys_info)
% function state_vars = partition_sys_var(y, sys_info)
%   partition the system variable, y = (x, and/or v, and/or xi)^T into its corresponding parts:x, 
%   and/or v, and/or xi
% IN:
%   y        :
%   sys_info :
% OUT:
%   state_vars

% (c) M. Zhong (JHU)

if ~iscolumn(y), error('SOD_Utils:partition_sys_var:Exception', 'y has to be a column vector!'); end

block_size = sys_info.d * sys_info.N;
x          = reshape(y(1 : block_size), [sys_info.d, sys_info.N]);
if sys_info.ode_order == 1
  v        = [];
  xi       = [];
elseif sys_info.ode_order == 2
  v        = reshape(y(block_size + 1 : 2 * block_size), [sys_info.d, sys_info.N]);
  if sys_info.has_xi
    xi     = reshape(y(2 * block_size + 1 : 2 * block_size + sys_info.N), [1, sys_info.N]);
  else
    xi     = [];
  end
end
state_vars.x  = x;
state_vars.v  = v;
state_vars.xi = xi;
end