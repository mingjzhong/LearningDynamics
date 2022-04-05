function [psi_pdist, phi_range_l] = set_psi_pdist(k1, Nk1, k2, Nk2, l, row_in_NkL_mat, ...
                                    psi_pdist_l, psi_pdist, phi_range_l)
% function [psi_pdist, phi_range_l] = set_psi_pdist(k1, Nk1, k2, Nk2, l, row_in_NkL_mat, ...
%                                     psi_pdist_l, psi_pdist, phi_range_l)

% (C) M. Zhong

for ind1 = 1 : length(psi_pdist_l)
  if ~isempty(psi_pdist_l{ind1}) && ~isempty(psi_pdist_l{ind1}{k1, k2})
    phi_dim                                              = length(psi_pdist_l{ind1}{k1, k2});
    for ind2 = 1 : phi_dim
      psi_pdist_Ck1Ck2                                   = psi_pdist_l{ind1}{k1, k2}{ind2};
      if ~isempty(psi_pdist)
        psi_pdist{ind1}{k1, k2}{ind2}(row_in_NkL_mat, :) = psi_pdist_Ck1Ck2;
        phi_range_l{ind1}{k1, k2}(ind2, 1, l)            = get_min_psi_pdist(k1, Nk1, k2, Nk2, ...
                                                           psi_pdist_Ck1Ck2);
        phi_range_l{ind1}{k1, k2}(ind2, 2, l)            = get_max_psi_pdist(k1, Nk1, k2, Nk2, ...
                                                           psi_pdist_Ck1Ck2);
      end
    end
  end
end
end