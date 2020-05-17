function [PsiE, PsiA, PsiXi] = assemble_the_learning_matrix_all_kinds(psi_pdist, psi_pdiff, phi_rest, basis, L, ...
                Psi_row_ind, agent_info, sys_info)
% function [PsiE, PsiA, PsiXi] = assemble_the_learning_matrix_all_kinds(psi_pdist, psi_pdiff, phi_rest, basis, L, ...
%               Psi_row_ind, agent_info, sys_info)

% (c) M. Zhong (JHU)

% initialize some terms
Psis        = cell(size(basis));
ISSPARSE    = false;                                                                                % do not use sparse storage for now
for ind = 1 : length(basis)
  if ~isempty(basis{ind})
    which_Psi = get_Psi_kind(ind, sys_info);
    if which_Psi == 1
      d       = sys_info.d;
    else
      d       = 1;
    end
    Psis{ind} = assemble_the_learning_matrix_each_kind(psi_pdist{ind}, psi_pdiff{ind}, phi_rest{ind}, ...
      basis{ind}, d, L, Psi_row_ind{which_Psi}, agent_info, sys_info, ISSPARSE);
  end
end
if sys_info.ode_order == 1
  PsiE      = Psis{1};
  PsiA      = [];
  PsiXi     = Psis{2};
elseif sys_info.ode_order == 2
  PsiE      = Psis{1};
  PsiA      = Psis{2};
  PsiXi     = Psis{3};  
end
end