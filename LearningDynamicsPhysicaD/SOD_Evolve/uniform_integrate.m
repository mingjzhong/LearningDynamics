function sol = uniform_integrate(odefun, tspan, y_0, opts)
% function sol = uniform_integrate(odefun, tspan, y_0, opts)

% (C) M. Zhong

switch opts.type
  case 'Runge-Kutta'
    type = 'rk';
  case 'Adams-Bashforth'
    type = 'ab';
  otherwise
    error('');
end
% set up the structure for sol, the same as other sol (struc) from MATLAB built-in ode solver, e.g., ode45
sol.solver                       = ['uniform_' type sprintf('_%d', opts.order)];
sol.extdata.odefun               = odefun;
sol.extdata.options              = opts;
sol.extdata.options.degree       = opts.order - 1;
sol.extdata.varargin             = [];
sol.idata.f3d                    = [];
sol.idata.idxNonNegative         = [];
time_vec                         = tspan(1) : opts.h : tspan(2);
if time_vec(end) < tspan(2), time_vec = [time_vec, tspan(2)]; end
sol.x                            = time_vec;
sol.y                            = zeros(length(y_0), length(time_vec));
sol.y(:, 1)                      = y_0;
sol.stats.nsteps                 = length(time_vec);
sol.stats.nfailed                = [];
sol.stats.nfevals                = 0;
% integrate in time
for t_idx = 1 : sol.stats.nsteps - 1
% advance from y_n (at t_n) to y_(n + 1) (at t_(n + 1)) with a uniform time step size h
  [sol.y(:, t_idx + 1), nfevals] = uniform_integrate_single_step(sol.x(t_idx), sol.y(:, t_idx), ...
                                   opts.h, odefun, opts);
  sol.stats.nfevals              = sol.stats.nfevals + nfevals;
end
end