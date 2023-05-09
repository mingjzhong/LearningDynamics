function [rho_pdist, rho_range_l] = set_rho_pdist(k1, Nk1, k2, Nk2, l, rho_pdist_l, rho_pdist, ...
                                    rho_range_l)
% function [rho_pdist, rho_range_l] = set_rho_pdist(k1, Nk1, k2, Nk2, l, rho_pdist_l, rho_pdist, ...
%                                     rho_range_l)

% (C) M. Zhong

if k1 ~= k2 || Nk1 > 1 || Nk2 > 1
  for idx1 = 1 : length(rho_pdist_l)
    if ~isempty(rho_pdist_l{idx1}) && ~isempty(rho_pdist_l{idx1}{k1, k2})
      for idx2 = 1 : length(rho_pdist_l{idx1}{k1, k2})
        rho_pdist_Ck1Ck2                        = rho_pdist_l{idx1}{k1, k2}{idx2};
        if k1 == k2
          if Nk1 > 1 || Nk2 > 1
            rho_pdist{idx1}{k1, k2}{idx2}(:, l) = get_rid_of_diagonal(rho_pdist_Ck1Ck2);
          end
        else
          rho_pdist{idx1}{k1, k2}{idx2}(:, l)   = rho_pdist_Ck1Ck2(:);
        end
        rho_range_l{idx1}{k1, k2}(idx2, 1, l)   = min(rho_pdist{idx1}{k1, k2}{idx2}(:, l));
        rho_range_l{idx1}{k1, k2}(idx2, 2, l)   = max(rho_pdist{idx1}{k1, k2}{idx2}(:, l));        
      end
    end
  end
end
end