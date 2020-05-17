function Psi = assemble_the_learning_matrix_each_kind(psi_pdist, psi_pdiff, phi_rest, basis, d, L, ...
               Psi_row_ind, agent_info, sys_info, ISSPARSE)
% function Psi = assemble_the_learning_matrix_each_kind(psi_pdist, psi_pdiff, phi_rest, basis, d, L, ...
%              Psi_row_ind, agent_info, sys_info, ISSPARSE)

% (c) M. Zhong (JHU)

num_basis_each_class             = cellfun(@(x) length(x.f), basis);
total_num_basis                  = sum(num_basis_each_class(:));
Psi                              = spalloc(L * sys_info.N * d, total_num_basis, 10 * L * sys_info.N * d);
if ~ISSPARSE, Psi                = full(Psi); end
num_prev_basis                   = 0;
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    ind1                         = num_prev_basis + 1;
    ind2                         = num_prev_basis + num_basis_each_class(k1, k2);
    row_inds                     = Psi_row_ind{k1};
    if k1 == k2 && agent_info.num_agents(k2) == 1
      Psi(row_inds, ind1 : ind2) = 0;
    else
      phi_rest_Ck1Ck2            = [];
      if ~isempty(phi_rest) && ~isempty(phi_rest{k1, k2})
        phi_rest_Ck1Ck2          = phi_rest{k1, k2};
      end
      type_influence             = get_type_influence(psi_pdist{k1, k2}, psi_pdiff{k1, k2}, ...
        phi_rest_Ck1Ck2, basis{k1, k2}, d, agent_info.num_agents(k2));
      Psi(row_inds, ind1 : ind2) = type_influence;      
    end
    num_prev_basis               = ind2;
  end
end
end