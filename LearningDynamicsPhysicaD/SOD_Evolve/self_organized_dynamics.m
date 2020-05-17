function dynamics = self_organized_dynamics( y_init, sys_info, solver_info )
% function [dynamics, flag] = self_organized_dynamics( y_init, sys_info, solver_info )
%   runs a self organized dynamics of the following form:
%   1st order:
%      \dot{x}_i   = \sum_{i' = 1, i' \neq i}^N 1/N_{K_i'} \phi^E_{K_i, K_i'}(r_{ii'})R^E_{ii'}\br_{ii'}
%   2nd order:
%      \dot{v}_i   = F^v(x_i, v_i, \xi_i) + \sum_{i' = 1, i' \neq i}^N 1/N_{K_i'} (\phi^E_{K_i, K_i'}(r_{ii'}R^E_{ii'}\br_{ii'} + \phi^A_{K_i, K_i'}(r_{ii'})R^A_{ii'}\dot{\br}_{ii'})
%      \dot{\xi}_i = F^\xi(x_i, v_i, \xi_i) + \sum_{i' = 1, i' \new i}^N 1/N_{K_i'} \phi^{\xi}_{K_i, K_i'}(r_{ii'})R^\xi_{ii'}\xi_{ii'}
%   where
%     x_i       : position (or opinion, or states) of the i^th agent, \in R^d
%     v_i       : = \dot{x}_i (velocity, in the case of x_i being the position)
%     \xi_i     : interaction with the environment (emotion, excitation level towards a food source) of the i^th agent
%     \phi^E_{k1, k2}, \phi^A_{k1, k2}, \phi^{\xi}_{k1, k2}
%               : energy (or alignment, or xi) based interaction of agents in the k2^th type onto agents in the k1^th type
%     N         : total number of agents in the system
%     N_k       : number of agents in the k^th type
%     \br_{ii'} : = x_i' - x_i
%     r_{ii'}   : = |x_i' - x_i| (the usual Euclidean norm in R^d)
%     R^E_{ii'}, R^A_{ii'}, R^{\xi}_{ii'}
%               : energy(or alignment, or xi) based regulation on the interacion between agent i and agent i'
%     \dot{\br}_{ii'}
%               : = v_i' - v_i
%     \xi_{ii'} : = \xi_i' - \xi_i
%     F^v, F^\xi: non-collective change on v_i and \xi_i respectively
% IN:
%   y_init      : initial condition to run the dynamics
%   sys_info    : information regarding the system of the dynamics
%   solver_ino  : information regarding the setup of the numerical integrator
% OUT:
%   dynamics    : structure with x and y fields representing times and solution values, resp.
%     flag      : 0 if integration was successful up to time solver_info.time_span(end), 1 otherwise

% (c) M. Zhong, M. Maggioni, JHU

% stochastic dynamics is taken out
if sys_info.has_noise, error('SOD_Evolve:self_organized_dynamics', 'Stochastic Interation is not implemented yet!!'); end
% simplify the right hand side function
odefun              = @(y) eval_rhs(y, sys_info);
% solve the ODE system either with adaptive or unifom integrator
if isfield(solver_info, 'is_uniform') && ~isempty(solver_info.is_uniform) && solver_info.is_uniform
  if isfield(solver_info, 'h'), h = solver_info.h; 
  else, h = (solver_info.time_span(2) - solver_info.time_span(1))/solver_info.num_steps; end
  ode_opts.type     = solver_info.type;
  ode_opts.order    = solver_info.order;
  ode_opts.h        = h;
  ode_opts.sys_info = sys_info;
  dynamics          = uniform_integrate(@(t, y) odefun(y), solver_info.time_span, y_init, ode_opts);
else
  ode_opts          = odeset('RelTol', solver_info.rel_tol, 'AbsTol', solver_info.abs_tol);         % set ODE solver options
  eval(sprintf('dynamics = ode%s(@(t, y) odefun(y), solver_info.time_span, y_init, ode_opts);', ...
    solver_info.solver));
end
stats               = dynamics.stats;
stats.nfailed       = dynamics.x(end) < solver_info.time_span(2);                                   % check to see if the dynamics has run all the way to the given final time
dynamics.stats      = stats;
flag                = dynamics.x(end) < solver_info.time_span(2);
dynamics.flag       = flag;
end
