function [y_n, nfevals] = uniform_integrate_single_step(t_n, y_nm1, h, ode_fun, opts, solver)
% function [y_n, nfevals] = uniform_integrate_single_step(t_n, y_nm1, h, ode_fun, opts, solver)

% (C) M. Zhong (JHU)

switch solver
  case 'Runge-Kutta'
    [y_n, nfevals] = single_rk_step(t_n, y_nm1, h, ode_fun, opts.order);
  case 'GNI'
    [y_n, nfevals] = single_rk_step(t_n, y_nm1, h, ode_fun, opts.order);
% projection step    
    y_n            = opts.sys_info.manifold_projection(y_n);
  otherwise
    error('');
end
end