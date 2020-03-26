function [alpha_vec, opt_val] = solve_the_learning_problem_on_xi(Phi, rhs_vec, basis, T, M, learning_info)
% [alpha_vec, opt_val] = solve_the_learning_problem_on_xi(Phi, rhs_vec, knot_vecs, T, M, learning_info)

% Ming Zhong
% Postdoc Research at JHU

% choose a solver
solver_type = learning_info.xi_solver_type;
% find the minimizer based on the type of the solver
if strcmp(solver_type, 'CVX')
% solve the problem using an external software package, CVX  
  [alpha_vec, opt_val] = solve_for_interactions_on_xi_by_CVX(Phi, rhs_vec, basis,  T, M, learning_info); 
else
% solve the problem using built-in MATLAB routines
  [alpha_vec, opt_val] = solve_for_interactions_on_xi_by_others(Phi, rhs_vec, basis, T, M, learning_info); 
end
return