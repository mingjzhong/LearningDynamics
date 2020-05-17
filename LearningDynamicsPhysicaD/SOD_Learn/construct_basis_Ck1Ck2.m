function basis = construct_basis_Ck1Ck2(range, learn_info, basis_info)
% [basis_fun, knot_vec] = construct_basis_Ck1Ck2(range, learn_info, basis_info)

% (c) M. Zhong (JHU)

knots = set_up_knots(range, learn_info, basis_info);
basis = construct_basis_Ck1Ck2_tensor_grid(range, knots, basis_info);
end