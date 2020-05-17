function phihat = eval_basis_functions_3D(r, s, z, alphas, basis)
% function phihat = eval_basis_functions_3D(r, s, z, alphas, basis)
% evaluate the a linear combination of basis functions, psi_\eta's in basis.f, with their coefficients 
% stored in the vector alphas, at the values stored in vector x.
% Intput:
%   r      - independent variable
%   s      - independent variable
%   z      - independent variable
%   alphas - the coefficients for the linear combination of basis functions in basis.f, each 
%            alphas(i) corresponding to basis function basis.f{i}
%   basis  - a structure which contains the basis functions, support of the basis functions and such
% Output:
%   phiat  - = \sum_{\eta = 1}^n alphas(\eta) * psi{\eta}(r, s, z)

% (C) M. Zhong (JHU)

if norm(size(r) - size(s), Inf) ~= 0, error(''); end
if norm(size(r) - size(z), Inf) ~= 0, error(''); end
% intialization
ind                  = r < basis.supp(1, 1);                                                        % for points to the left of the left end point of the support of the basis
r(ind)               = basis.supp(1, 1);                                                            % constant before the left end point
ind                  = r > basis.supp(1, 2);                                                        % for points to the right of the right end point of the support of the basis
r(ind)               = basis.supp(1, 2);                                                            % constant right right end point
ind                  = s < basis.supp(2, 1);                                                        % for points to the bottom of the bottom end point of the support of the basis
s(ind)               = basis.supp(2, 1);                                                            % constant before the bottom end point
ind                  = s > basis.supp(2, 2);                                                        % for points to the above of the top end point of the support of the basis
s(ind)               = basis.supp(2, 2);                                                            % constant after the top end point
ind                  = z < basis.supp(3, 1);
z(ind)               = basis.supp(3, 1);
ind                  = z > basis.supp(3, 2);
z(ind)               = basis.supp(3, 2);
[num_rows, num_cols] = size(r); 
phihat               = zeros(num_rows, num_cols);                                                         
is_local             = strcmp(basis.supp_type{1}, 'local') && strcmp(basis.supp_type{2}, 'local') ...
                       && strcmp(basis.supp_type{3}, 'local');
if is_local
  r                  = r(:); 
  s                  = s(:); 
  z                  = z(:);
  [~, orig_idx_r]    = sort(r); 
  [~, orig_idx_s]    = sort(s);
  [~, orig_idx_z]    = sort(z);
  r_min              = r(orig_idx_r(1)); 
  s_min              = s(orig_idx_s(1));
  z_min              = z(orig_idx_z(1));
  if r_min < basis.knots{1}(1), edges_r = [r_min, basis.knots{1}(2 : end)]; else, edges_r = basis.knots{1}; end
  if s_min < basis.knots{2}(1), edges_s = [s_min, basis.knots{2}(2 : end)]; else, edges_s = basis.knots{2}; end
  if z_min < basis.knots{3}(1), edges_z = [z_min, basis.knots{3}(2 : end)]; else, edges_z = basis.knots{3}; end
  r_counts           = histcounts(r, edges_r, 'Normalization', 'count'); 
  s_counts           = histcounts(s, edges_s, 'Normalization', 'count');
  z_counts           = histcounts(z, edges_z, 'Normalization', 'count');
  n_s                = basis.n(2);
  n_z                = basis.n(3);
end
for eta = 1 : length(basis.f)
  if alphas(eta) ~= 0  
    if is_local
      psi            = zeros(1, length(r));
      eta_r          = floor((eta - 1)/(n_s * n_z)) + 1;
      eta_sz         = mod(eta - 1, n_s * n_z) + 1;
      bin_idx1_r     = basis.supp_knots_idx{1}(eta_r, 1);
      bin_idx2_r     = basis.supp_knots_idx{1}(eta_r, 2);
      eta_s          = floor((eta_sz - 1)/n_z) + 1;
      bin_idx1_s     = basis.supp_knots_idx{2}(eta_s, 1);
      bin_idx2_s     = basis.supp_knots_idx{2}(eta_s, 2);
      eta_z          = mod(eta_sz - 1, n_z) + 1;
      bin_idx1_z     = basis.supp_knots_idx{3}(eta_z, 1);
      bin_idx2_z     = basis.supp_knots_idx{3}(eta_z, 2);      
      prev_r_counts  = sum(r_counts(1 : bin_idx1_r - 1));
      prev_s_counts  = sum(s_counts(1 : bin_idx1_s - 1));
      prev_z_counts  = sum(z_counts(1 : bin_idx1_z - 1));
      sort_idx1_r    = prev_r_counts + 1;
      sort_idx2_r    = sum(r_counts(1 : bin_idx2_r));
      sort_idx1_s    = prev_s_counts + 1;
      sort_idx2_s    = sum(s_counts(1 : bin_idx2_s));
      sort_idx1_z    = prev_z_counts + 1;
      sort_idx2_z    = sum(z_counts(1 : bin_idx2_z));      
      rs_idx         = intersect(orig_idx_r(sort_idx1_r : sort_idx2_r), orig_idx_s(sort_idx1_s : sort_idx2_s));
      rsz_idx        = intersect(rs_idx, orig_idx_z(sort_idx1_z : sort_idx2_z));
      psi(rsz_idx)   = basis.f{eta}(r(rsz_idx), s(rsz_idx), z(rsz_idx));
      psi            = reshape(psi, [num_rows, num_cols]);         
    else
      psi            = basis.f{eta}(r, s, z);
    end
    ind              = psi > 0;
    phihat(ind)      = phihat(ind) + alphas(eta) * psi(ind); 
  end
end
end