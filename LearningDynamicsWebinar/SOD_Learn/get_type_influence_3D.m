function [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence_3D(rij, sij, zij, ...
                                                   psi_pdiff, phi_rest, basis, d, Nk)
% function [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence_3D(rij, sij, zij, ...
%                                                    psi_pdiff, phi_rest, basis, d, Nk)

% (C) M. Zhong

% initialization
n                      = length(basis.f);
row_ind                = cell(1, n);
col_ind                = cell(1, n);
psi_vec                = cell(1, n);
nnz_per_Ck             = zeros(1, n);
is_local               = strcmp(basis.supp_type{1}, 'local') && ...
                         strcmp(basis.supp_type{2}, 'local') && ...
                         strcmp(basis.supp_type{3}, 'local');
if is_local
  [num_rows, num_cols] = size(rij); 
  validateattributes(sij, {'numeric'}, {'size', [num_rows, num_cols]});
  validateattributes(zij, {'numeric'}, {'size', [num_rows, num_cols]});
  rij                  = rij(:); 
  sij                  = sij(:); 
  zij                  = zij(:);
  [~, orig_idx_r]      = sort(rij); 
  [~, orig_idx_s]      = sort(sij);
  [~, orig_idx_z]      = sort(zij);
  rij_min              = rij(orig_idx_r(1)); 
  sij_min              = sij(orig_idx_s(1));
  zij_min              = sij(orig_idx_z(1));
  if rij_min < basis.knots{1}(1), edges_r = [rij_min, basis.knots{1}(2 : end)]; ...
  else, edges_r = basis.knots{1}; end
  if sij_min < basis.knots{2}(1), edges_s = [sij_min, basis.knots{2}(2 : end)]; ...
  else, edges_s = basis.knots{2}; end
  if zij_min < basis.knots{3}(1), edges_z = [zij_min, basis.knots{3}(2 : end)]; ...
  else, edges_z = basis.knots{3}; end    
  r_counts             = histcounts(rij, edges_r, 'Normalization', 'count'); 
  s_counts             = histcounts(sij, edges_s, 'Normalization', 'count');
  z_counts             = histcounts(zij, edges_z, 'Normalization', 'count');
end
for eta = 1 : n
  if is_local
    eta_r              = floor((eta - 1)/(basis.n(2) * basis.n(3))) + 1;
    eta_sz             = mod(eta - 1, basis.n(2) * basis.n(3)) + 1;
    eta_s              = floor((eta_sz - 1)/basis.n(3)) + 1;
    eta_z              = mod(eta_sz - 1, basis.n(3)) + 1;
    psi_ij             = zeros(length(rij), 1);
    bin_idx1_r         = basis.supp_knots_idx{1}(eta_r, 1);
    bin_idx2_r         = basis.supp_knots_idx{1}(eta_r, 2);   
    bin_idx1_s         = basis.supp_knots_idx{2}(eta_s, 1);
    bin_idx2_s         = basis.supp_knots_idx{2}(eta_s, 2);
    bin_idx1_z         = basis.supp_knots_idx{3}(eta_z, 1);
    bin_idx2_z         = basis.supp_knots_idx{3}(eta_z, 2);         
    prev_r_counts      = sum(r_counts(1 : bin_idx1_r - 1));
    prev_s_counts      = sum(s_counts(1 : bin_idx1_s - 1));
    prev_z_counts      = sum(z_counts(1 : bin_idx1_z - 1));        
    sort_idx1_r        = prev_r_counts + 1;
    sort_idx2_r        = sum(r_counts(1 : bin_idx2_r));
    sort_idx1_s        = prev_s_counts + 1;
    sort_idx2_s        = sum(s_counts(1 : bin_idx2_s));
    sort_idx1_z        = prev_z_counts + 1;
    sort_idx2_z        = sum(z_counts(1 : bin_idx2_z));        
    rs_idx             = intersect(orig_idx_r(sort_idx1_r : sort_idx2_r), ...
                         orig_idx_s(sort_idx1_s : sort_idx2_s));
    rsz_idx            = intersect(rs_idx, orig_idx_z(sort_idx1_z : sort_idx2_z));                               
    psi_ij(rsz_idx)    = basis.f{eta}(rij(rsz_idx), sij(rsz_idx), zij(rsz_idx));
    psi_ij             = reshape(psi_ij, [num_rows, num_cols]);     
  else
    psi_ij             = basis.f{eta}(rij, sij, zij);
  end
  if ~isempty(phi_rest), psi_ij = psi_ij .* phi_rest; end
  psi_ij               = sum(smatrix_times_vmatrix(psi_ij, psi_pdiff, d), 2)/Nk;
  ind                  = find(psi_ij);
  if ~isempty(ind)
    nnz_per_Ck(eta)    = length(ind);
    row_ind{eta}       = ind;
    col_ind{eta}       = eta * ones(nnz_per_Ck(eta), 1);
    psi_vec{eta}       = psi_ij(ind);
  end  
end
row_ind                = vertcat(row_ind{:});
col_ind                = vertcat(col_ind{:});
psi_vec                = vertcat(psi_vec{:});
nnz_per_Ck             = sum(nnz_per_Ck);
end