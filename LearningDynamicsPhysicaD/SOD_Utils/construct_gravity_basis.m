function basis = construct_gravity_basis(degree, supp, n)
% function basis = construct_gravity_basis(degree, supp, n)

% (C) M. Zhong


basis_info.degree   = degree;
basis_info.type     = {'B-spline'};
basis_info.sub_type = {'Clamped'};
basis_info.dim      = 1;
basis_info.n        = n;
basis_info.period   = Inf;
knots               = set_up_knots_by_type(1, supp, basis_info, []);
basis               = construct_basis_Ck1Ck2_tensor_grid(supp, {knots}, basis_info);
end