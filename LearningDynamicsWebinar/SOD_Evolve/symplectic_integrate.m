function sol = symplectic_integrate(y0, solver_info, sys_info)
% function sol = symplectic_integrate(y0, solver_info, sys_info)

% (C) M. Zhong

% simplify the right hand side function                    
switch solver_info.solver
  case 'Runge-Kutta-Nystrom'
    odefun                   = @(x) eval_rhs_rkn(x, sys_info);
    type                     = 'rkn';
    if isfield(solver_info, 'is_explicit') && ~isempty(solver_info.is_explicit)
      is_explicit            = solver_info.is_explicit;
    else
      is_explicit            = true;
    end
  case 'partitioned-Runge-Kutta'
    odefun                   = @(x) eval_rhs_rkn(x, sys_info);
    type                     = 'prk';
    is_explicit              = false;
  case 'Leapfrog'
    odefun                   = @(x) eval_rhs_rkn(x, sys_info);
    type                     = 'lf';
    is_explicit              = true;
  otherwise
    error('SOD_Evovle:symplectic_integrate:exception', ...
      'Only RKN and PRK are being considered!!');
end
if isfield(solver_info, 'h')
  opts.h                     = solver_info.h; 
else
  opts.h                     = (solver_info.time_span(2) - ...
                                solver_info.time_span(1))/solver_info.num_steps; 
end
opts.order                   = solver_info.order;
opts.sys_info                = sys_info;
% set up the structure for sol, the same as other sol (struc) from any MATLAB built-in ode solver
sol.solver                   = ['symplectic_' type sprintf('_%d', opts.order)];
sol.extdata.odefun           = odefun;
sol.extdata.options          = opts;
sol.extdata.options.degree   = opts.order - 1;
sol.extdata.varargin         = [];
sol.idata.f3d                = [];
sol.idata.idxNonNegative     = [];
time_vec                     = solver_info.time_span(1) : opts.h : solver_info.time_span(2);
if time_vec(end) < solver_info.time_span(2), time_vec = [time_vec, solver_info.time_span(2)]; end
sol.x                        = time_vec;
sol.y                        = zeros(length(y0), length(time_vec));
sol.y(:, 1)                  = y0;
sol.stats.nsteps             = length(time_vec);
sol.stats.nfailed            = [];
sol.stats.nfevals            = 0;
% integrate in time
for t_idx = 2 : sol.stats.nsteps
% advance from y_{n - 1} (at t_{n - 1}) to y_n (at t_n) with a uniform time step size h
  [sol.y(:, t_idx), nfevals] = symplectic_integrate_single_step(sol.y(:, t_idx - 1), opts.h, ...
                               odefun, opts, solver_info.solver, is_explicit);
  sol.stats.nfevals          = sol.stats.nfevals + nfevals;
end
end