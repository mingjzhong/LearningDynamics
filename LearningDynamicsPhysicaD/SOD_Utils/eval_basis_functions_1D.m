function phihat = eval_basis_functions_1D(r, alphas, basis)
% function phihat = eval_basis_functions_1D(r, alphas, basis)
% evaluate the a linear combination of basis functions, psi_\eta's in basis.f, with their coefficients 
% stored in the vector alphas, at the values stored in vector x.
% Intput:
%   r      - independent variable
%   alphas - the coefficients for the linear combination of basis functions in basis.f, each 
%            alphas(i) corresponding to basis function basis.f{i}
%   basis  - a structure which contains the basis functions, support of the basis functions and such
% Output:
%   phihat - = \sum_{\eta = 1}^n alphas(\eta) * psi{\eta}(r)

% (C) M. Zhong (JHU)

% intialization
ind                   = r < basis.supp(1);                                                          % for points to the left of the left end point of the support of the basis
r(ind)                = basis.supp(1);                                                              % constant before the left end point
ind                   = r > basis.supp(2);                                                          % for points to the right of the right end point of the support of the basis
r(ind)                = basis.supp(2);                                                              % constant right right end point
[num_rows, num_cols]  = size(r);                                                                    % find out the size of the r matrix 
phihat                = zeros(num_rows, num_cols);                                                  % prepare phihat, having the same size as the independent variable r
is_local              = strcmp(basis.supp_type, 'local');
if is_local
  r                   = r(:);                   
  [~, orig_idx_r]     = sort(r);                                                                    % sort in ascending order, and remember the mapping back to original vector
  r_min               = r(orig_idx_r(1));
  if r_min < basis.knots(1), edges = [r_min, basis.knots(2 : end)]; else, edges = basis.knots; end
  r_counts            = histcounts(r, edges, 'Normalization', 'count');                             % bin the pairwise distances
end
for eta = 1 : length(basis.f)
  if alphas(eta) ~= 0
    if is_local
      psi             = zeros(1, length(r));
      bin_idx1        = basis.supp_knots_idx(eta, 1);
      bin_idx2        = basis.supp_knots_idx(eta, 2);
      previous_counts = sum(r_counts(1 : bin_idx1 - 1));
      sort_idx1       = previous_counts + 1;
      sort_idx2       = sum(r_counts(1 : bin_idx2));
      r_idx           = orig_idx_r(sort_idx1 : sort_idx2);
      psi(r_idx)      = basis.f{eta}(r(r_idx));
      psi             = reshape(psi, [num_rows, num_cols]);
    else
      psi             = basis.f{eta}(r);
    end
    ind               = psi > 0;
    phihat(ind)       = phihat(ind) + alphas(eta) * psi(ind);
  end
end
end  