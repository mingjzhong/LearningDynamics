function basis = construct_basis(phi_range, learn_info, basis_plan)
% function basis = construct_basis(phi_range, learn_info, basis_plan)

% (c) M. Zhong (JHU)

[num_kinds, kind_types] = get_phi_or_rho_kinds(learn_info.sys_info, 'phi');
basis                   = cell(1, num_kinds);
for ind = 1 : num_kinds
  basis_info            = get_basis_info(learn_info, kind_types{ind});
  basis{ind}            = construct_basis_each_kind(phi_range{ind}, learn_info, basis_info, ...
                          basis_plan{ind});
end
end