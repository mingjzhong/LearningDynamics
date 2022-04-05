function phihat = eval_basis_functions_2D(r, s, alphas, basis)
% function phihat = eval_basis_functions_2D(r, s, alphas, basis)
% evaluate the a linear combination of basis functions, psi_\eta's in basis.f, with their coefficients 
% stored in the vector alphas, at the values stored in vector x.
% Intput:
%   r      - independent variable
%   s      - independent variable
%   alphas - the coefficients for the linear combination of basis functions in basis.f, each 
%            alphas(i) corresponding to basis function basis.f{i}
%   basis  - a structure which contains the basis functions, support of the basis functions and such
% Output:
%   phiat  - = \sum_{\eta = 1}^n alphas(\eta) * psi{\eta}(r, s)

% (C) M. Zhong (JHU)

size_of_r             = size(r);
validateattributes(s, {'numeric'}, {'size', size_of_r});
% intialization
ind                 = r < basis.supp(1, 1);                                                         % for points to the left of the left end point of the support of the basis
r(ind)              = basis.supp(1, 1);                                                             % constant before the left end point
ind                 = r > basis.supp(1, 2);                                                         % for points to the right of the right end point of the support of the basis
r(ind)              = basis.supp(1, 2);                                                             % constant right right end point
ind                 = s < basis.supp(2, 1);                                                         % for points to the bottom of the bottom end point of the support of the basis
s(ind)              = basis.supp(2, 1);                                                             % constant before the bottom end point
ind                 = s > basis.supp(2, 2);                                                         % for points to the above of the top end point of the support of the basis
s(ind)              = basis.supp(2, 2);                                                             % constant after the top end point
phihat              = zeros(size_of_r);                                                         
is_local            = strcmp(basis.supp_type{1}, 'local') && strcmp(basis.supp_type{2}, 'local');
if is_local
  r                 = r(:); 
  s                 = s(:); 
  [~, orig_idx_r]   = sort(r); 
  [~, orig_idx_s]   = sort(s);
  r_min             = r(orig_idx_r(1)); 
  s_min             = s(orig_idx_s(1));
  if r_min < basis.knots{1}(1), edges_r = [r_min, basis.knots{1}(2 : end)]; 
  else, edges_r = basis.knots{1}; end
  if s_min < basis.knots{2}(1), edges_s = [s_min, basis.knots{2}(2 : end)]; 
  else, edges_s = basis.knots{2}; end
  r_counts          = histcounts(r, edges_r, 'Normalization', 'count'); 
  s_counts          = histcounts(s, edges_s, 'Normalization', 'count');
end
for eta = 1 : length(basis.f)
  if alphas(eta) ~= 0
    if is_local
      eta_r         = floor((eta - 1)/basis.n(2)) + 1;
      eta_s         = mod(eta - 1, basis.n(2)) + 1;
      psi           = zeros(1, length(r));
      bin_idx1_r    = basis.supp_knots_idx{1}(eta_r, 1);
      bin_idx2_r    = basis.supp_knots_idx{1}(eta_r, 2);
      bin_idx1_s    = basis.supp_knots_idx{2}(eta_s, 1);
      bin_idx2_s    = basis.supp_knots_idx{2}(eta_s, 2);
      prev_r_counts = sum(r_counts(1 : bin_idx1_r - 1));
      prev_s_counts = sum(s_counts(1 : bin_idx1_s - 1));
      sort_idx1_r   = prev_r_counts + 1;
      sort_idx2_r   = sum(r_counts(1 : bin_idx2_r));
      sort_idx1_s   = prev_s_counts + 1;
      sort_idx2_s   = sum(s_counts(1 : bin_idx2_s));
      rs_idx        = intersect(orig_idx_r(sort_idx1_r : sort_idx2_r), ...
                      orig_idx_s(sort_idx1_s : sort_idx2_s));
      psi(rs_idx)   = basis.f{eta}(r(rs_idx), s(rs_idx));
      psi           = reshape(psi, size_of_r);    
    else
      psi           = basis.f{eta}(r, s);
    end
    ind             = psi ~= 0;
    phihat(ind)     = phihat(ind) + alphas(eta) * psi(ind); 
  end
end
end