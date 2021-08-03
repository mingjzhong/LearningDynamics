function basis_plan = get_basis_construction_plan_adaptive(phi_range, rhoLTM, learn_info)
% function basis_plan = get_basis_construction_plan_adaptive(phi_range, rhoLTM, learn_info)

% (C) M. Zhong

switch learn_info.adaptive_method
  case 'wrt_rho'
    basis_plan = get_basis_construction_plan_wrt_rho(phi_range, rhoLTM, learn_info);
  case 'wrt_rho_and_psi'
    basis_plan = get_basis_construction_plan_wrt_rho_and_psi(phi_range, rhoLTM, learn_info);
  otherwise
    error('SOD_Learn:get_basis_construction_plan_adaptive:exception', ...
      'Adaptive learning is based on either rho and rho/psi!!');
end
end