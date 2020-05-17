function basis = construct_basis_Ck1Ck2_1D(idx, knots, basis_info)
% function basis = construct_basis_Ck1Ck2_1D(idx, knots, basis_info)

% (C) M. Zhong

% get the number of basis functions
n                                    = get_n_from_basis_info_and_knots(idx, basis_info, knots);
% get the degree
p                                    = basis_info.degree(idx);
% initialize storage
basis.f                              = cell(1, n);
basis.df                             = cell(1, n);
basis.d2f                            = cell(1, n);
basis.supp_knots_idx                 = zeros(n, 2, 'uint32');
basis.n                              = n;
% declare psi_eta depends on the point r and also the degree p
switch basis_info.type{idx}
  case 'B-spline'
    basis.supp_type                  = 'local';
    if strcmp(basis_info.sub_type{idx}, 'Clamped')
      num_basic_knots                = length(knots) - 2 * p;
    else
      num_basic_knots                = length(knots);
    end
    for eta = 1 : n
      basis.f{eta}                   = @(r) basis_B_spline(r,                eta, p, knots);
      basis.df{eta}                  = @(r) basis_B_spline_1st_derivative(r, eta, p, knots);
      basis.d2f{eta}                 = @(r) basis_B_spline_2nd_derivative(r, eta, p, knots);
      if eta < p + 1
        basis.supp_knots_idx(eta, 1) = 1; 
      else
        basis.supp_knots_idx(eta, 1) = eta - p; 
      end
      if eta > num_basic_knots - p - 1
        basis.supp_knots_idx(eta, 2) = num_basic_knots  - 1; 
      else
        basis.supp_knots_idx(eta, 2) = eta + p; 
      end
    end  
    knots                            = unique(knots);
  case 'PW-polynomial'
    basis.supp_type                  = 'local';
% find out the indices of the spport of knot span for each basis function
    for eta = 1 : n
      basis.f{eta}                   = @(r) basis_PW_polynomial(r,                eta, p, knots, ...
                                       basis_info.sub_type{idx});
      basis.df{eta}                  = @(r) basis_PW_polynomial_1st_derivative(r, eta, p, knots, ...
                                       basis_info.sub_type{idx});
      basis.d2f{eta}                 = @(r) basis_PW_polynomial_2nd_derivative(r, eta, p, knots, ...
                                       basis_info.sub_type{idx});                                        
      basis.supp_knots_idx(eta, 1)   = fix((eta - 1)/(p + 1)) + 1; 
      basis.supp_knots_idx(eta, 2)   = fix((eta - 1)/(p + 1)) + 1;
    end
  case 'Fourier'
    basis.supp_type                  = 'global';
    basis.supp_knots_idx             = [];
% find out the indices of the spport of knot span for each basis function
    for eta = 1 : n
      basis.f{eta}                   = @(r) basis_Fourier(r,                eta, knots, ...
                                       basis_info.sub_type{idx});
      basis.df{eta}                  = @(r) basis_Fourier_1st_derivative(r, eta, knots, ...
                                       basis_info.sub_type{idx});
      basis.d2f{eta}                 = @(r) basis_Fourier_2nd_derivative(r, eta, knots, ...
                                       basis_info.sub_type{idx});                                        
    end  
  otherwise
    error('');
end
basis.knots                          = knots;
end