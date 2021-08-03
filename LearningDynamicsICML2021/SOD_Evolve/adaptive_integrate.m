function sol = adaptive_integrate(y0, solver_info, sys_info)
% function sol = adaptive_integrate(y0, solver_info, sys_info)

% (c) M. Zhong

% adaptive ODE solver for solving ODE on manifold is taken out, according to Harier's book, adaptive
% method might not give intended results, hence uniform solvers are the ones for solving ODE on
% Manifold.
opts          = odeset('RelTol', solver_info.rel_tol, 'AbsTol', solver_info.abs_tol);               % set ODE solver options
opts.sys_info = sys_info;  
switch solver_info.solver
  case '15i'  % 15i needs initial derivative, for fully implicit
    sol       = ode15i(@solver_info.odefun, solver_info.time_span, y0, solver_info.yp0, opts);
  otherwise   % by default use ode15s, other implicit solvers (ode23s, ode23t, ode23tb) are very slow
              % ode45, ode23, and ode113 are explicit solvers, might have stability issue
    eval(sprintf('ode_solve = @(a, b, c, d) ode%s(a, b, c, d);', solver_info.solver));
    sol       = ode_solve(@solver_info.odefun, solver_info.time_span, y0, opts);      
end
end