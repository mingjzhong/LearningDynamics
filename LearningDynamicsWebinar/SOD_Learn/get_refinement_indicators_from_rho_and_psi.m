function indicators = get_refinement_indicators_from_rho_and_psi(j, Estimator_j, Estiamtor_jp1, ...
                      rhoLTM, knots, indicators, learn_info)
% function indicators = get_refine_indicators_from_rho_and_psi(j, Estimator_jm1, Estiamtor_j, ...
%                       knots, indicators)

% (C) M. Zhong

[num_kinds, kind_types]          = get_phi_or_rho_kinds(learn_info.sys_info, 'phi');
for idx = 1 : num_kinds
  [alphas_j, basis_j]            = get_alphas_and_basis_from_Estimator(kind_types{idx}, Estimator_j);
  [alphas_jp1, basis_jp1]        = get_alphas_and_basis_from_Estimator(kind_types{idx}, Estiamtor_jp1);
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      indicators{idx}{k1, k2}{j} = get_indicator_score_from_rho_and_psi(alphas_j{k1, k2}, ...
                                   basis_j{k1, k2}, alphas_jp1{k1, k2}, basis_jp1{k1, k2}, ...
                                   rhoLTM{idx}{k1, k2}, knots{idx}{k1, k2}{j}, learn_info);
    end
  end
end
end