function rho_pdist = initialize_rho_data_Ck1Ck2(k1, Nk1, k2, Nk2, L, rho_pdist)
% function rho_pdist = initialize_rho_data_Ck1Ck2(k1, Nk1, k2, Nk2, L, rho_pdist)

% (C) M. Zhong

num_rhos                                = length(rho_pdist);
for ind1 = 1 : num_rhos
  if ~isempty(rho_pdist{ind1})
    rho_dim                             = length(rho_pdist{ind1}{k1, k2});
    for ind2 = 1 : rho_dim
      if k1 == k2
        if Nk1 > 1
          rho_pdist{ind1}{k1, k2}{ind2} = zeros(Nk1 * (Nk1 - 1), L);                                % pairwise data for agents of the same type, take out the diagonal part
        end
      else
        rho_pdist{ind1}{k1, k2}{ind2}   = zeros(Nk1 * Nk2, L);                                      % pairwise data for agents of different types
      end
    end
  end
end
end