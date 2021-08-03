function Psi = assemble_the_learning_matrix_each_kind(psi_pdist, psi_pdiff, phi_rest, basis, d, ...
               L, agent_info, sys_info)
% function Psi = assemble_the_learning_matrix_each_kind(psi_pdist, psi_pdiff, phi_rest, basis, d, ...
%                L, agent_info, sys_info)

% (c) M. Zhong (JHU)

num_basis_Ck1Ck2        = cellfun(@(x) length(x.f), basis);
Psi                     = cell(1, sys_info.K);
for k1 = 1 : sys_info.K
% need to use spare storage, however build the sparse matrix based on non-zero vectors with
% corresonding row and column indices
  Nk1                   = agent_info.num_agents(k1);
  psi_vec               = cell(1, sys_info.K);
  row_ind               = cell(1, sys_info.K);
  col_ind               = cell(1, sys_info.K);
  nnz_per_Ck            = zeros(1, sys_info.K);
  to_delete             = false;
  if Nk1 == 1, num_basis_Ck1Ck2(k1, k1) = 0; end
  nnz_cols              = sum(num_basis_Ck1Ck2(k1, :));
  for k2 = 1 : sys_info.K
    Nk2                 = agent_info.num_agents(k2);
    if k1 ~= k2 || Nk1 > 1  || Nk2 > 1
      if k2 == 1
        num_prev_basis  = 0;
      else
        num_prev_basis  = sum(num_basis_Ck1Ck2(k1, 1 : k2 - 1));
      end
      if ~isempty(phi_rest) && ~isempty(phi_rest{k1, k2})
        phi_rest_Ck1Ck2 = phi_rest{k1, k2};
      else
        phi_rest_Ck1Ck2 = [];
      end      
      [row_ind{k2}, col_ind{k2}, psi_vec{k2}, nnz_per_Ck(k2)] ...
                        = get_type_influence(psi_pdist{k1, k2}, psi_pdiff{k1, k2}, ...
                          phi_rest_Ck1Ck2, basis{k1, k2}, d, Nk2);    
      psi_vec{k2}       = psi_vec{k2}/sqrt(Nk1);
      if k2 > 1, col_ind{k2} = col_ind{k2} + num_prev_basis; end
    else
      to_delete         = true;
    end    
  end
  if to_delete
    psi_vec(k1)         = []; 
    row_ind(k1)         = []; 
    col_ind(k1)         = []; 
    nnz_per_Ck(k1)      = [];
  end
  Psi{k1}               = sparse(vertcat(row_ind{:}), vertcat(col_ind{:}), vertcat(psi_vec{:}), ...
                          L * Nk1 * d, nnz_cols, sum(nnz_per_Ck));
end