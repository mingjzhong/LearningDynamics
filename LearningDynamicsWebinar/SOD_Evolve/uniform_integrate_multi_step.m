function [y_n, nfevals] = uniform_integrate_multi_step(t_ns, y_ns, h, ode_fun, opts, solver)
% function [y_n, nfevals] = uniform_integrate_multi_step(t_ns, y_ns, h, ode_fun, opts, solver)

% (C) M. Zhong (JHU)

num_pts              = length(t_ns);
if num_pts < opts.order
  order              = num_pts;
else
  order              = opts.order;
end
switch solver
  case 'Backward-Differentiation'
    [y_n, nfevals] = single_bdf_step(t_ns, y_ns, h, ode_fun, order);
  case 'GNI'
    [y_n, nfevals] = single_bdf_step(t_ns, y_ns, h, ode_fun, order);
% projection step    
    y_n            = opts.sys_info.manifold_projection(y_n);
  otherwise
    error('');
end
end