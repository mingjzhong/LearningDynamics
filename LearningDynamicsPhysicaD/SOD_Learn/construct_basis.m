function basis = construct_basis(phi_range, sys_info, learn_info)
% function basis = construct_basis(phi_range, sys_info, learn_info)

% (c) M. Zhong (JHU)

basis        = cell(size(phi_range));
for ind = 1 : length(phi_range)
  basis_info = get_basis_info(learn_info, sys_info, ind);
  basis{ind} = construct_basis_all_Ck1Ck2s(phi_range{ind}, sys_info, learn_info, basis_info);
end
end