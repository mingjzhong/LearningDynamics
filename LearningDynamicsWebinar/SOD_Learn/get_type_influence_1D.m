function [row_ind, col_ind, psi_vec, nnz_per_Ck] = get_type_influence_1D(rij, psi_pdiff, phi_rest, basis, d, Nk)
% function type_influence = get_type_influence_1D(rij, psi_pdiff, phi_rest, basis, d, Nk)

% (C) M. Zhong

% initialization
n                      = length(basis.f);
row_ind                = cell(1, n);
col_ind                = cell(1, n);
psi_vec                = cell(1, n);
nnz_per_Ck             = zeros(1, n);
is_local               = strcmp(basis.supp_type, 'local');                                      % indicator for locally supported basis
if is_local                                                                                         % preparation for local-support basis
  [num_rows, num_cols] = size(rij);                                                             % find out the size of the pdist_data matrix  
  rij                  = rij(:);                   
  [~, orig_idx_r]      = sort(rij);                                                             % sort in ascending order, and remember the mapping back to original vector
  rij_min              = rij(orig_idx_r(1));
  if rij_min < basis.knots(1), edges = [rij_min, basis.knots(2 : end)]; ...
  else, edges = basis.knots; end
  r_counts             = histcounts(rij, edges, 'Normalization', 'count');                      % bin the pairwise distances
end
for eta = 1 : n
  if is_local                                                                    
    psi_ij             = zeros(length(rij), 1);
    bin_idx1           = basis.supp_knots_idx(eta, 1);
    bin_idx2           = basis.supp_knots_idx(eta, 2);
    previous_counts    = sum(r_counts(1 : bin_idx1 - 1));
    sort_idx1          = previous_counts + 1;
    sort_idx2          = sum(r_counts(1 : bin_idx2));
    rij_idx            = orig_idx_r(sort_idx1 : sort_idx2);
    psi_ij(rij_idx)    = basis.f{eta}(rij(rij_idx));
    psi_ij             = reshape(psi_ij, [num_rows, num_cols]);
  else
    psi_ij             = basis.f{eta}(rij);
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