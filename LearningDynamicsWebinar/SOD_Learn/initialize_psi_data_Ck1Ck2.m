function [psi_pdist, psi_pdiff] = initialize_psi_data_Ck1Ck2(k1, Nk1, k2, Nk2, d, L, psi_pdist, ...
                                  psi_pdiff, sys_info)
% function [Psi_pdist, psi_pdiff] = initialize_psi_data_Ck1Ck2(k1, Nk1, k2, Nk2, d, L, Psi_pdist, ...
%                                   Psi_pdiff, sys_info)

% (C) M. Zhong

if ~isempty(psi_pdist)
  num_kinds                           = length(psi_pdist);
  for ind1 = 1 : num_kinds
    if ~isempty(psi_pdist{ind1})
      if ind1 < num_kinds
        psi_pdiff{ind1}{k1, k2}       = zeros(L * Nk1 * d, Nk2);                                    % for x_pdiff and v_pdiff
      else
        if ~isfield(sys_info, 'phiXi_weight') || isempty(sys_info.phiXi_weight) || sys_info.phiXi_weight
          psi_pdiff{ind1}{k1, k2}     = zeros(L * Nk1, Nk2);                                        % for xi_pdiff
        end
      end 
      phi_dim                         = length(psi_pdist{ind1}{k1, k2});
      for ind2 = 1 : phi_dim
        psi_pdist{ind1}{k1, k2}{ind2} = zeros(L * Nk1, Nk2);                                        % for any pdist
      end
    end
  end
end
end