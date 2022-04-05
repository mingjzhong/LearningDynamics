function sol = uniform_integrate(y0, solver_info, sys_info)
% function sol = uniform_integrate(y0, solver_info, sys_info)

% (C) M. Zhong

if isfield(solver_info, 'h')
  opts.h                       = solver_info.h; 
else
  opts.h                       = (solver_info.time_span(2) - ...
                                  solver_info.time_span(1))/solver_info.num_steps; 
end
opts.order                     = solver_info.order;
opts.sys_info                  = sys_info;
switch solver_info.solver
  case 'Runge-Kutta'
    type                       = 'rk';
    multi_step                 = false;
  case 'Backward-Differentiation'
    type                       = 'bd';
    multi_step                 = true;
    num_steps                  = opts.order;
  case 'GNI'
    if isfield(solver_info, 'multi_step') && ~isempty(solver_info.multi_step) && ...
        solver_info.multi_step
      type                     = 'gni_bd';
      multi_step               = true;
      num_steps                = opts.order;
    else
      type                     = 'gni_rk';
      multi_step               = false;
    end
  otherwise
    error('');
end
% set up the structure for sol, the same as other sol (struc) from any MATLAB built-in ode solver
sol.solver                     = ['uniform_' type sprintf('_%d', opts.order)];
sol.extdata.odefun             = solver_info.odefun;
sol.extdata.options            = opts;
sol.extdata.options.degree     = round((opts.order + 1)/2);
sol.extdata.varargin           = [];
sol.idata.f3d                  = [];
sol.idata.idxNonNegative       = [];
time_vec                       = solver_info.time_span(1) : opts.h : solver_info.time_span(2);
if time_vec(end) < solver_info.time_span(2), time_vec = [time_vec, solver_info.time_span(2)]; end
sol.x                          = time_vec;
sol.y                          = zeros(length(y0), length(time_vec));
sol.y(:, 1)                    = y0;
sol.stats.nsteps               = length(time_vec);
sol.stats.nfailed              = [];
sol.stats.nfevals              = 0;
% integrate in time
for t_idx = 2 : sol.stats.nsteps
  if ~multi_step
% advance from y_{n - 1} (at t_{n - 1}) to y_n (at t_n) with a uniform time step size h
    [sol.y(:, t_idx), nfevals] = uniform_integrate_single_step(sol.x(t_idx - 1), ...
                                 sol.y(:, t_idx - 1), opts.h, solver_info.odefun, opts, ...
                                 solver_info.solver);
  else
% advance from y_{n - 1}, y_{n - 2}, \ldots, y_{n - k + 1}, to y_n, k is the order
% if the initial times, t = 1, \ldots, k - 1, we use an increasing order of multi-step method to
% come up with the solutions
    if t_idx < num_steps + 1
      ind                      = (t_idx - 1) : -1 : 1;
    else
      ind                      = (t_idx - 1) : -1 : (t_idx - num_steps);
    end
    [sol.y(:, t_idx), nfevals] = uniform_integrate_multi_step(sol.x(ind), sol.y(:, ind), ...
                                 opts.h, solver_info.odefun, opts, solver_info.solver);      
  end
  sol.stats.nfevals            = sol.stats.nfevals + nfevals;
end
end