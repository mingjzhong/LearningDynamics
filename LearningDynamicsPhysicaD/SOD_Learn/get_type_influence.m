function type_influence = get_type_influence(psi_pdist, psi_pdiff, phi_rest, basis, d, Nk)
% function class_influence = get_type_influence(psi_pdist, psi_pdiff, phi_rest, basis, d, Nk)

% (C) M. Zhong (JHU)

% initialization
if ~isempty(psi_pdiff)
  type_influence             = zeros(size(psi_pdiff, 1), length(basis.f));
else
  LNk                        = size(psi_pdist{1}, 1);
  type_influence             = zeros(LNk * d, length(basis.f));
end
psi_dim                      = length(psi_pdist);                                                   % dimension of the basis function
switch psi_dim
  case 1
    is_local                 = strcmp(basis.supp_type, 'local');                                    % indicator for locally supported basis
    if is_local                                                                                     % preparation for local-support basis
      rij                    = psi_pdist{1};
      [num_rows, num_cols]   = size(rij);                                                           % find out the size of the pdist_data matrix  
      rij                    = rij(:);                   
      [~, orig_idx_r]        = sort(rij);                                                           % sort in ascending order, and remember the mapping back to original vector
      rij_min                = rij(orig_idx_r(1));
      if rij_min < basis.knots(1), edges = [rij_min, basis.knots(2 : end)]; else, edges = basis.knots; end
      r_counts               = histcounts(rij, edges, 'Normalization', 'count');                    % bin the pairwise distances
    end
    for eta = 1 : length(basis.f)
      if is_local                                                                    
        psi_ij               = zeros(1, length(rij));
        bin_idx1             = basis.supp_knots_idx(eta, 1);
        bin_idx2             = basis.supp_knots_idx(eta, 2);
        previous_counts      = sum(r_counts(1 : bin_idx1 - 1));
        sort_idx1            = previous_counts + 1;
        sort_idx2            = sum(r_counts(1 : bin_idx2));
        rij_idx              = orig_idx_r(sort_idx1 : sort_idx2);
        psi_ij(rij_idx)      = basis.f{eta}(rij(rij_idx));
        psi_ij               = reshape(psi_ij, [num_rows, num_cols]);
      else
        psi_ij               = basis.f{eta}(psi_pdist{1});
      end
      if ~isempty(phi_rest), psi_ij = psi_ij .* phi_rest; end
      type_influence(:, eta) = sum(smatrix_times_vmatrix(psi_ij, psi_pdiff, d), 2)/Nk;
    end        
  case 2
    is_local                 = strcmp(basis.supp_type{1}, 'local') && strcmp(basis.supp_type{2}, 'local');
    if is_local
      rij                    = psi_pdist{1};
      sij                    = psi_pdist{2};
      [num_rows, num_cols]   = size(rij); 
      if norm(size(sij) - [num_rows, num_cols], Inf) ~= 0, error(''); end
      rij                    = rij(:); 
      sij                    = sij(:); 
      [~, orig_idx_r]        = sort(rij); 
      [~, orig_idx_s]        = sort(sij);
      rij_min                = rij(orig_idx_r(1)); 
      sij_min                = sij(orig_idx_s(1));
      if rij_min < basis.knots{1}(1), edges_r = [rij_min, basis.knots{1}(2 : end)]; else, edges_r = basis.knots{1}; end
      if sij_min < basis.knots{2}(1), edges_s = [sij_min, basis.knots{2}(2 : end)]; else, edges_s = basis.knots{2}; end
      r_counts               = histcounts(rij, edges_r, 'Normalization', 'count'); 
      s_counts               = histcounts(sij, edges_s, 'Normalization', 'count');
      n_s                    = basis.n(2);
    end
    for eta = 1 : length(basis.f)
      if is_local
        psi_ij               = zeros(1, length(rij));
        eta_r                = floor((eta - 1)/n_s) + 1;
        bin_idx1_r           = basis.supp_knots_idx{1}(eta_r, 1);
        bin_idx2_r           = basis.supp_knots_idx{1}(eta_r, 2);
        eta_s                = mod(eta - 1, n_s) + 1;
        bin_idx1_s           = basis.supp_knots_idx{2}(eta_s, 1);
        bin_idx2_s           = basis.supp_knots_idx{2}(eta_s, 2);
        prev_r_counts        = sum(r_counts(1 : bin_idx1_r - 1));
        prev_s_counts        = sum(s_counts(1 : bin_idx1_s - 1));
        sort_idx1_r          = prev_r_counts + 1;
        sort_idx2_r          = sum(r_counts(1 : bin_idx2_r));
        sort_idx1_s          = prev_s_counts + 1;
        sort_idx2_s          = sum(s_counts(1 : bin_idx2_s));
        rs_idx               = intersect(orig_idx_r(sort_idx1_r : sort_idx2_r), orig_idx_s(sort_idx1_s : sort_idx2_s));
        psi_ij(rs_idx)       = basis.f{eta}(rij(rs_idx), sij(rs_idx));
        psi_ij               = reshape(psi_ij, [num_rows, num_cols]);        
      else
        psi_ij               = basis.f{eta}(psi_pdist{1}, psi_pdist{2});
      end
      if ~isempty(phi_rest), psi_ij = psi_ij .* phi_rest; end
      type_influence(:, eta) = sum(smatrix_times_vmatrix(psi_ij, psi_pdiff, d), 2)/Nk;        
    end
  case 3
    is_local                 = strcmp(basis.supp_type{1}, 'local') && ...
                               strcmp(basis.supp_type{2}, 'local') && ...
                               strcmp(basis.supp_type{3}, 'local');
    if is_local
      rij                    = psi_pdist{1};
      sij                    = psi_pdist{2};
      zij                    = psi_pdist{3};
      [num_rows, num_cols]   = size(rij); 
      if norm(size(sij) - [num_rows, num_cols], Inf) ~= 0, error(''); end
      if norm(size(zij) - [num_rows, num_cols], Inf) ~= 0, error(''); end
      rij                    = rij(:); 
      sij                    = sij(:); 
      zij                    = zij(:);
      [~, orig_idx_r]        = sort(rij); 
      [~, orig_idx_s]        = sort(sij);
      [~, orig_idx_z]        = sort(zij);
      rij_min                = rij(orig_idx_r(1)); 
      sij_min                = sij(orig_idx_s(1));
      zij_min                = sij(orig_idx_z(1));
      if rij_min < basis.knots{1}(1), edges_r = [rij_min, basis.knots{1}(2 : end)]; else, edges_r = basis.knots{1}; end
      if sij_min < basis.knots{2}(1), edges_s = [sij_min, basis.knots{2}(2 : end)]; else, edges_s = basis.knots{2}; end
      if zij_min < basis.knots{2}(1), edges_z = [zij_min, basis.knots{3}(2 : end)]; else, edges_z = basis.knots{3}; end
      r_counts               = histcounts(rij, edges_r, 'Normalization', 'count'); 
      s_counts               = histcounts(sij, edges_s, 'Normalization', 'count');
      z_counts               = histcounts(zij, edges_z, 'Normalization', 'count');
      n_s                    = basis.n(2);
      n_z                    = basis.n(3);
    end
    for eta = 1 : length(basis.f)
      if is_local
        psi_ij               = zeros(1, length(rij));
        eta_r                = floor((eta - 1)/(n_s * n_z)) + 1;
        eta_sz               = mod(eta - 1, n_s * n_z) + 1;
        bin_idx1_r           = basis.supp_knots_idx{1}(eta_r, 1);
        bin_idx2_r           = basis.supp_knots_idx{1}(eta_r, 2);
        eta_s                = floor(eta_sz - 1, n_z) + 1;
        bin_idx1_s           = basis.supp_knots_idx{2}(eta_s, 1);
        bin_idx2_s           = basis.supp_knots_idx{2}(eta_s, 2);
        eta_z                = mod(eta_sz - 1, n_z) + 1;
        bin_idx1_z           = basis.supp_knots_idx{3}(eta_z, 1);
        bin_idx2_z           = basis.supp_knots_idx{3}(eta_z, 2);       
        prev_r_counts        = sum(r_counts(1 : bin_idx1_r - 1));
        prev_s_counts        = sum(s_counts(1 : bin_idx1_s - 1));
        prev_z_counts        = sum(z_counts(1 : bin_idx1_z - 1));
        sort_idx1_r          = prev_r_counts + 1;
        sort_idx2_r          = sum(r_counts(1 : bin_idx2_r));
        sort_idx1_s          = prev_s_counts + 1;
        sort_idx2_s          = sum(s_counts(1 : bin_idx2_s));
        sort_idx1_z          = prev_z_counts + 1;
        sort_idx2_z          = sum(z_counts(1 : bin_idx2_z));        
        rs_idx               = intersect(orig_idx_r(sort_idx1_r : sort_idx2_r), orig_idx_s(sort_idx1_s : sort_idx2_s));
        rsz_idx              = intersect(rs_idx, orig_idx_s(sort_idx1_z : sort_idx2_z));
        psi_ij(rsz_idx)      = basis.f{eta}(rij(rsz_idx), sij(rsz_idx), zij(rsz_idx));
        psi_ij               = reshape(psi_ij, [num_rows, num_cols]);        
      else
        psi_ij               = basis.f{eta}(psi_pdist{1}, psi_pdist{2}, psi_pdist{3});
      end
      if ~isempty(phi_rest), psi_ij = psi_ij .* phi_rest; end
      type_influence(:, eta) = sum(smatrix_times_vmatrix(psi_ij, psi_pdiff, d), 2)/Nk;        
    end    
  otherwise
    error('');
end
end
