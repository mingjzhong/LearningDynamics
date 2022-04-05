function basis_plan = get_basis_construction_plan_rho_adaptive(phi_range, rhoLTM, learn_info)
% function basis_plan = get_basis_construction_plan_rho_adaptive(phi_range, rhoLTM, learn_info)

% (C) M. Zhong

[num_kinds, kind_types]              = get_phi_or_rho_kinds(learn_info.sys_info, 'phi');
basis_plan                           = cell(1, num_kinds);
for idx = 1 : num_kinds
  rho                                = get_the_rhoLT(rhoLTM, learn_info.sys_info, kind_types{idx});
  basis_info                         = get_basis_info(learn_info, kind_types{idx});
  basis_plan{idx}                    = cell(learn_info.sys_info.K);
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      basis_plan{idx}{k1, k2}.knots  = set_up_knots_by_rho(phi_range{idx}{k1, k2}, ...
                                       basis_info{k1, k2}, rho{k1, k2});
      basis_plan{idx}{k1, k2}.use_TG = true;
    end
  end
end
end