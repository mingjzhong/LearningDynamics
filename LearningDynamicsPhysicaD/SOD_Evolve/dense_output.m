function [yint, ypint] = dense_output(sol, tint)
% function [yint, ypint] = dense_output(sol, tint)

% (C) M. Zhong

if contains(sol.solver, 'uniform')
  [yint, ypint] = deval_uniform(sol, tint);
elseif contains(sol.solver, 'stochastic')
  [yint, ypint] = deval_stochastic(sol, tint);                                                      % this is not right, will be implemented for stochastic system later
else
  [yint, ypint] = deval(sol, tint);
end
end