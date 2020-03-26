function basis = uniform_basis(R, degree, num_basis_fun, basis_info)
% [basis_fun, knot_vec] = uniform_basis(R, degree, num_basis_fun, type)

% (c) M. Zhong (JHU)

if isfield(basis_info, 'is_splines') && basis_info.is_splines
  spline_info          = set_up_spline_info(R, degree, num_basis_fun);
  basis                = construct_B_spline_basis(spline_info);
else
  polynomial_info      = set_up_piecewise_polynomial_info(R, degree, num_basis_fun);                % construct the neccessary information for piecewise polynomial
  polynomial_info.type = basis_info.type;                                                           % choose a type of polynomial
  basis                = construct_piecewise_polynomial_basis(polynomial_info);                     % construct the basis functions and knot vector
end
end