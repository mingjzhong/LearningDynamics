function basis = construct_basis_Ck1Ck2(phi_range, basis_info, basis_plan)
% [basis_fun, knot_vec] = construct_basis_Ck1Ck2(range, basis_info, basis_plan)

% (c) M. Zhong (JHU)

if basis_plan.use_TG
  if isfield(basis_plan, 'inner_prod') && ~isempty(basis_plan.inner_prod)
    basis_info.inner_prod = basis_plan.inner_prod;
  end
  basis                   = construct_basis_Ck1Ck2_ND(phi_range, basis_plan.knots, basis_info);
else
  error('SOD_Learn:construct_basis_Ck1Ck2:exception', ...
    'Non-Tensor-Grid construction of multi-dimenion basis is not supported yet!!');
end
end