function basis = construct_basis_each_kind(phi_range, learn_info, basis_info, basis_plan)
% function basis = construct_basis_each_kind(phi_range, learn_info, basis_info, basis_plan)

% (C) M. Zhong, M. Maggioni (JHU)

if ~isempty(basis_info)
  basis             = cell(learn_info.sys_info.K);                                                  % the basis for each type
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      basis{k1, k2} = construct_basis_Ck1Ck2(phi_range{k1, k2}, basis_info{k1, k2}, basis_plan{k1, k2});
    end
  end
else
  basis             = [];
end
end