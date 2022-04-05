function Estimator = get_Estimator_for_adaptive_learning(phi_range, knots, learn_info)
% function Estimator = get_Estimator_for_adaptive_learning(phi_range, knots, learn_info)

% (C) M. Zhong

% get the knots by simpling refining the phi range  
basis_plan = get_basis_construction_plan_at_jth_refinement(phi_range, knots, learn_info);
% construction basis based on that plan  
basis      = construct_basis(phi_range, learn_info, basis_plan);
% Assemble ALM and bLM
[Estimator.ALM, Estimator.bLM, ~, Estimator.ALMXi, Estimator.bLMXi] ...
           = assemble_A_and_b(learn_info.M, learn_info.L, basis, learn_info);
Estimator  = set_basis_in_Estimator(basis, basis_plan, learn_info.sys_info, Estimator);
learn_info = update_basis_info(Estimator, learn_info);
% Solve for alphas
[Estimator.alpha, Estimator.alpha_xi] ...
           = solve_the_learning_problem(Estimator, learn_info); 
end