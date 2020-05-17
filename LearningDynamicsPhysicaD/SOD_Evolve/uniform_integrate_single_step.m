function [y_np1, nfevals] = uniform_integrate_single_step(t_n, y_n, h, ode_fun, opts)
% function y_np1 = uniform_integrate_single_step(t_n, y_n, h, ode_fun, opts)

% (C) M. Zhong (JHU)

switch opts.type
  case 'Runge-Kutta'
    [y_np1, nfevals] = single_rk_step(t_n, y_n, h, ode_fun, opts.order);
  otherwise
    error('');
end
end