function dynamics = self_organized_dynamics( y_init, sys_info, solver_info )
% function [dynamics, flag] = self_organized_dynamics( y_init, sys_info, solver_info )
%   runs a self organized dynamics of the following form:
%   1st order:
%      \dot{x}_i   = \sum_{i' = 1, i' \neq i}^N \kappa_{K_i'}/N_{K_i'} \phi^E_{K_i, K_i'}(r_{ii'})R^E_{ii'}\br_{ii'}
%   2nd order:
%      \dot{v}_i   = F^v(v_i, \xi_i) + \sum_{i' = 1, i' \neq i}^N \kappa_{K_i'}/N_{K_i'} (\phi^E_{K_i, K_i'}(r_{ii'}R^E_{ii'}\br_{ii'} + \phi^A_{K_i, K_i'}(r_{ii'})R^A_{ii'}\dot{\br}_{ii'})
%      \dot{\xi}_i = F^\xi(\xi_i) + \sum_{i' = 1, i' \new i}^N \kappa^{\xi}_{K_i'}/N_{K_i'} \phi^{\xi}_{K_i, K_i'}(r_{ii'})R^\xi_{ii'}\xi_{ii'}
%   where
%     x_i       : position (or opinion, or states) of the i^th agent, \in R^d
%     v_i       : = \dot{x}_i (velocity, in the case of x_i being the position)
%     \xi_i     : interaction with the environment (emotion, excitation level towards a food source) of the i^th agent
%     \kappa_k, \kappa^{\xi}_k
%               : coupling strength term for agents in the k^th type (class) for x_i or v_i, and \xi_i
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

% stochastic dynamics not supported yet
if sys_info.has_noise, error('SOD_Evolve:self_organized_dynamics', 'Stochastic Interation is not implemented yet!!');    end

ode_opts                = odeset('RelTol', solver_info.rel_tol, 'AbsTol', solver_info.abs_tol);     % set ODE solver options
eval( sprintf('dynamics = ode%s(@(t, y) odefun(y), solver_info.time_span, y_init, ode_opts);', solver_info.solver) );
stats.nfailed           = dynamics.x(end) < solver_info.time_span(end);                             % check to see if the dynamics has run all the way to the given final time
dynamics.stats          = stats;
flag                    = dynamics.x(end) < solver_info.time_span(end);
dynamics.flag           = flag;

% use a nested function to share sys_info with the main function
    function rhs = odefun(y)
        rhs                   = eval_rhs(y, sys_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    end

end
