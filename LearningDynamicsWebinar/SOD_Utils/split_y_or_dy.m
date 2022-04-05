function [x, v, xi] = split_y_or_dy(y, sys_info)
% function [x, v, xi] = split_y_or_dy(y, sys_info)

% (C) M. Zhong (JHU)

one_block = sys_info.N * sys_info.d;
x         = y(1 : one_block, :); 
v         = []; 
xi        = [];
switch sys_info.ode_order
  case 1
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      xi  = y(one_block + 1 : one_block + sys_info.N, :);
    end
  case 2
    v     = y(one_block + 1 : 2 * one_block, :);
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      xi  = y(2 * one_block + 1 : 2 * one_block + sys_info.N, :);
    end    
  otherwise
    error('');
end
end