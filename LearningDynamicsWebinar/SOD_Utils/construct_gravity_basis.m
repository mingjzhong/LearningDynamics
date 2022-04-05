function basis = construct_gravity_basis(degree, supp, n)
% function basis = construct_gravity_basis(degree, supp, n)

% (C) M. Zhong

basis_info.degree                = degree;
basis_info.type                  = {'B-spline'};
basis_info.sub_type              = {'Clamped'};
basis_info.dim                   = 1;
basis_info.n                     = n;
basis_info.period                = Inf;
knots                            = set_up_knots_by_type(1, supp, basis_info, []);
basis.degree                     = basis_info.degree;
basis.supp                       = supp;
basis.dim                        = basis_info.dim;
basis.type                       = basis_info.type;
basis.sub_type                   = basis_info.sub_type;
basis.period                     = basis_info.period;
basis.n                          = n;
basis.supp_type                  = 'local';
basis.supp_knots_idx             = zeros(n, 2, 'uint32');
basis.f                          = cell(1, n);
basis.df                         = cell(1, n);
basis.d2f                        = cell(1, n);
num_subInts                      = length(knots) - 2 * degree - 1;
knots_idx                        = 1 - degree : num_subInts + degree + 1;
for eta = 1 : n
  basis.f{eta}                   = @(r) basis_B_spline(r, eta, degree, knots);
  basis.df{eta}                  = @(r) basis_B_spline_1st_derivative(r, eta, degree, knots);
  basis.d2f{eta}                 = @(r) basis_B_spline_2nd_derivative(r, eta, degree, knots);
  if knots_idx(eta) < 1
    basis.supp_knots_idx(eta, 1) = 1;
  else
    basis.supp_knots_idx(eta, 1) = knots_idx(eta);  
  end
  if knots_idx(eta + degree) > num_subInts
    basis.supp_knots_idx(eta, 2) = num_subInts;
  else
    basis.supp_knots_idx(eta, 2) = knots_idx(eta + degree);
  end
end  
basis.knots                      = unique(knots);
end