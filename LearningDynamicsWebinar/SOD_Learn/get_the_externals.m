function [Fvec, FvecXi] = get_the_externals(l, x, v, xi, Fvec, FvecXi, sys_info)
% function [Fvec, FvecXi] = get_the_externals(l, x, v, xi, Fvec, FvecXi, sys_info)

% (C) M. Zhong (JHU)

switch sys_info.ode_order
  case 1
    if isfield(sys_info, 'Fx') && ~isempty(sys_info.Fx)
      Fvec(:, l)    = sys_info.Fx(x, xi);
    end
    if isfield(sys_info, 'Fxi') && ~isempty(sys_info.Fxi)
      FvecXi(:, l)  = sys_info.Fxi(x, xi);
    end
  case 2
     if isfield(sys_info, 'Fv') && ~isempty(sys_info.Fv)
      Fvec(:, l)    = sys_info.Fv(x, v, xi);
     end
     if isfield(sys_info, 'Fxi') && ~isempty(sys_info.Fxi)
       FvecXi(:, l) = sys_info.Fxi(x, v, xi);
     end
  otherwise
    error('SOD_Learn:get_the_externals:exception', ...
      'sys_info.ode_order can only be 1 or 2!!');
end
end