function [yint, ypint] = dense_output(sol, tint)
% function [yint, ypint] = dense_output(sol, tint)
% continuous ouput for various ODE solvers

% (C) M. Zhong

if contains(sol.solver, 'symplectic')
  [yint, ypint]   = deval_symplectic(sol, tint);
else
  if contains(sol.solver, 'uniform')
    [yint, ypint] = deval_uniform(sol, tint);
  else
% deval is the built-in MATLAB routine for obtaining continuous output for various ODE solvers (e.g.
% ode45, ode15s, etc.)
    [yint, ypint] = deval(sol, tint);
  end
end
end