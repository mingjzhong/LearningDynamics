function state_vars = partition_sys_var(y, sys_info)
% function state_vars = partition_sys_var(y, sys_info)
%   partition the system variable, y = (x, and/or v, and/or xi)^T into its corresponding parts:x, 
%   and/or v, and/or xi
% IN:
%   y          : the system varaible might have size [Nd, 1], [Nd + N, 1], [2Nd, 1], or [2Nd + N, 1];
%   sys_info   : the structure which contains all the necessary information for the ODE system
% OUT:
%   state_vars : the struct which contains the parsed out x, v, and xi

% (c) M. Zhong (JHU)

if ~iscolumn(y), error('SOD_Utils:partition_sys_var:Exception', 'y has to be a column vector!'); end

block_size = sys_info.d * sys_info.N;
x          = reshape(y(1 : block_size), [sys_info.d, sys_info.N]); 
v = []; xi = [];
if sys_info.ode_order == 1
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi), xi = y(block_size + 1 : block_size + sys_info.N)'; end
elseif sys_info.ode_order == 2
  v        = reshape(y(block_size + 1 : 2 * block_size), [sys_info.d, sys_info.N]);
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi), xi = y(2 * block_size + 1 : 2 * block_size + sys_info.N)'; end
end
state_vars.x = x; state_vars.v = v; state_vars.xi = xi;
end