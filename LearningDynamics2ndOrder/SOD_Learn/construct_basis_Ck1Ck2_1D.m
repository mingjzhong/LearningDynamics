function basis = construct_basis_Ck1Ck2_1D(idx, knots, basis_info)
% function basis = construct_basis_Ck1Ck2_1D(idx, knots, basis_info)

% (C) M. Zhong

% get the number of basis functions
n                                    = get_n_from_basis_info_and_knots(idx, basis_info, knots);
% get the degree
if ~isempty(basis_info.degree)
  p                                  = basis_info.degree(idx);
else
  p                                  = [];
end
% initialize storage
basis.f                              = cell(1, n);
basis.supp_knots_idx                 = zeros(n, 2, 'uint32');
basis.n                              = n;
% declare psi_eta depends on the point r and also the degree p
switch basis_info.type{idx}
  case 'B-spline'
    basis.supp_type                  = 'local';
    if strcmp(basis_info.sub_type{idx}, 'Clamped')
      num_subInts                    = length(knots) - 2 * p - 1;
    else  
      num_subInts                    = length(knots) - 1;
    end
    knots_idx                        = 1 - p : num_subInts + p + 1;
    for eta = 1 : n
      basis.f{eta}                   = @(r) basis_B_spline(r, eta, p, knots);
      if knots_idx(eta) < 1
        basis.supp_knots_idx(eta, 1) = 1;
      else
        basis.supp_knots_idx(eta, 1) = knots_idx(eta);  
      end
      if knots_idx(eta + p) > num_subInts
        basis.supp_knots_idx(eta, 2) = num_subInts;
      else
        basis.supp_knots_idx(eta, 2) = knots_idx(eta + p);
      end
    end  
    knots                            = unique(knots);
  case 'PW-polynomial'
    basis.supp_type                  = 'local';
% find out the indices of the spport of knot span for each basis function
    for eta = 1 : n
      basis.f{eta}                   = @(r) basis_PW_polynomial(r, eta, p, knots, basis_info.sub_type{idx});                                     
      basis.supp_knots_idx(eta, 1)   = fix((eta - 1)/(p + 1)) + 1; 
      basis.supp_knots_idx(eta, 2)   = fix((eta - 1)/(p + 1)) + 1;
    end    
  case 'Polynomial'
    basis.supp_type                  = 'global';
    basis.supp_knots_idx             = [];
    for eta = 1 : n
      basis.f{eta}                   = @(r) basis_polynomial(r, eta, knots, basis_info.sub_type{idx});
%       switch basis_info.sub_type{idx}
%         case 'Orthogonal'
%           if eta == 1
%             basis.f{eta}             = @(r) ones(size(r));
%           elseif eta == 2
%             a_1                      = basis_info.inner_prod(@(r) r, basis.f{1});
% % b_1 = 0 (can be anything though); and rho is a probabiliy measure
%             basis.f{eta}             = @(r) r - a_1;
%           else
%             basis.f{eta}             = @(r) basis_polynomial(r, eta, knots, ...
%                                        basis_info.sub_type{idx}, basis_info.inner_prod, ...
%                                        basis.f{eta - 1}, basis.f{eta - 2});
% %             basis.f{eta}             = construct_interpolant_1D(basis.f{eta}, ...
% %                                        linspace(knots(1), knots(2), 201), 3);
%           end
%         otherwise
%           basis.f{eta}               = @(r) basis_polynomial(r, eta, knots, basis_info.sub_type{idx});
%       end
    end
  otherwise
    error('');
end
basis.knots                          = knots;
end