function basis_plan = get_basis_construction_plan_wrt_rho_and_psi(phi_range, rhoLTM, learn_info)
% function basis_plan = get_basis_construction_plan_wrt_rho_and_psi(phi_range, rhoLTM, learn_info)

% (C) M. Zhong

J               = ceil(log2(learn_info.max_num_subs)); 
indicators      = initialize_indicators_or_knots(J, learn_info);
knots           = initialize_indicators_or_knots(J, learn_info);
knots_jp1       = phi_range;
for j = 1 : J
  knots         = set_knots(j, knots_jp1, knots);
  knots_j       = get_knots(j, knots);  
  if j == 1
    Estimator_j = get_Estimator_for_adaptive_learning(phi_range, knots_j, learn_info);
  else
    Estimator_j = Estimator_jp1;
  end
  knots_jp1     = refine_the_jth_knots(knots_j);
  Estimator_jp1 = get_Estimator_for_adaptive_learning(phi_range, knots_jp1, learn_info);
  indicators    = get_refinement_indicators_from_rho_and_psi(j, Estimator_j, ...
                  Estimator_jp1, rhoLTM, knots, indicators, learn_info);
end
basis_plan      = get_basis_construction_plan_from_indicators(phi_range, knots, indicators, ...
                  learn_info);
end