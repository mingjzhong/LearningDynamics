function basis_plan = get_basis_construction_plan_wrt_rho(phi_range, rhoLTM, learn_info)
% function basis_plan = get_basis_construction_plan_wrt_rho(phi_range, rhoLTM, learn_info)

% (C) M. Zhong

[num_kinds, kind_types]              = get_phi_or_rho_kinds(learn_info.sys_info, 'phi');
basis_plan                           = cell(1, num_kinds);
J                                    = ceil(log2(learn_info.max_num_subs)); 
for idx = 1 : num_kinds
  basis_info                         = get_basis_info(learn_info, kind_types{idx});
  basis_plan{idx}                    = cell(learn_info.sys_info.K);
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      ext_knots                      = get_knots_for_equi_prob(rhoLTM{idx}{k1, k2}, J, ...
                                        learn_info.sample_tol);
      basis_plan{idx}{k1, k2}.knots  = set_up_knots(phi_range{idx}{k1, k2}, basis_info{k1, k2}, ...
                                       ext_knots);
      basis_plan{idx}{k1, k2}.use_TG = true;        
    end
  end
end
end