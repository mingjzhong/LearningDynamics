function [psi_pdist, rho_pdist, phi_range_l, rho_range_l] = set_psi_and_rho_pdist(k1, Nk1, k2, Nk2, l,...
           row_in_NkL_mat, psi_pdist_l, rho_weight_l, psi_pdist, rho_pdist, phi_range_l, rho_range_l)
% function [psi_pdist, rho_pdist, phi_range_l, rho_range_l] = set_psi_and_rho_pdist(k1, k2, l, row_in_NkL_mat, ...
%           psi_pdist_l, rho_weight_l, psi_pdist, rho_pdist, phi_range_l, rho_range_l)

% (C) M. Zhong

for ind1 = 1 : length(psi_pdist_l)
  if ~isempty(psi_pdist_l{ind1}) && ~isempty(psi_pdist_l{ind1}{k1, k2})
    phi_dim                                              = length(psi_pdist_l{ind1}{k1, k2});
    if ~isempty(rho_weight_l{ind1})
      rho_dim                                            = phi_dim + 1;
    else
      rho_dim                                            = phi_dim;
    end
    for ind2 = 1 : phi_dim
      psi_pdist_Ck1Ck2                                   = psi_pdist_l{ind1}{k1, k2}{ind2};
      if ~isempty(psi_pdist)
        psi_pdist{ind1}{k1, k2}{ind2}(row_in_NkL_mat, :) = psi_pdist_Ck1Ck2;
        phi_range_l{ind1}{k1, k2}(ind2, 1, l)            = get_min_psi_pdist(k1, Nk1, k2, Nk2, psi_pdist_Ck1Ck2);
        phi_range_l{ind1}{k1, k2}(ind2, 2, l)            = get_max_psi_pdist(k1, Nk1, k2, Nk2, psi_pdist_Ck1Ck2);
      end
      if k1 == k2
        if Nk1 > 1 || Nk2 > 1
          rho_pdist{ind1}{k1, k2}{ind2}(:, l)            = get_rid_of_diagonal(psi_pdist_Ck1Ck2);
        end
      else
        rho_pdist{ind1}{k1, k2}{ind2}(:, l)              = psi_pdist_Ck1Ck2(:);
      end
      if ~isempty(rho_pdist{ind1}{k1, k2}{ind2})
        rho_range_l{ind1}{k1, k2}(ind2, 1, l)            = min(rho_pdist{ind1}{k1, k2}{ind2}(:, l));
        rho_range_l{ind1}{k1, k2}(ind2, 2, l)            = max(rho_pdist{ind1}{k1, k2}{ind2}(:, l));
      end
    end
    if phi_dim < rho_dim
      if k1 == k2
        if Nk1 > 1 || Nk2 > 1
          rho_pdist{ind1}{k1, k2}{rho_dim}(:, l)         = get_rid_of_diagonal(rho_weight_l{ind1}{k1, k2});
        end
      else
        rho_pdist{ind1}{k1, k2}{rho_dim}(:, l)           = rho_weight_l{ind1}{k1, k2}(:);
      end
      if ~isempty(rho_pdist{ind1}{k1, k2}{rho_dim})
        rho_range_l{ind1}{k1, k2}(rho_dim, 1, l)         = min(rho_pdist{ind1}{k1, k2}{rho_dim}(:, l));
        rho_range_l{ind1}{k1, k2}(rho_dim, 2, l)         = max(rho_pdist{ind1}{k1, k2}{rho_dim}(:, l));
      end
    end
  end
end
end