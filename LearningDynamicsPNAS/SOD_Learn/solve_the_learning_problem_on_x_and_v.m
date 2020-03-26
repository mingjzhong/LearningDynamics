function [alpha, fric_coef, opt_val] = solve_the_learning_problem_on_x_and_v(Phi, rhs_vec, T, M, sys_info, learn_info)
% function [alpha, fric_coef, opt_val] = solve_the_learning_problem_on_x_and_v(Phi, rhs_vec, T, M, sys_info, learn_info)

% (c) M. Zhong (JHU)

if strcmp(learn_info.solver_type, 'CVX')                                                            
  [alpha, fric_coef, opt_val] = solve_for_interactions_on_x_and_v_by_CVX(Phi, rhs_vec, T, M, learn_info);    % use an external software package CVX
else    
  [alpha, fric_coef, opt_val] = solve_for_interactions_on_x_and_v_by_others(Phi, rhs_vec, T, M, learn_info); % use MATLAB built-in routines
end
return