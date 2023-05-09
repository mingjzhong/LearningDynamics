function [Psi, PsiXi] = assemble_the_learning_matrix_all_kinds(psi_pdist, psi_pdiff, phi_rest, ...
                        basis, L, agent_info, sys_info)
% function [Psi, PsiXi] = assemble_the_learning_matrix_all_kinds(psi_pdist, psi_pdiff, phi_rest, ...
%                         basis, L, agent_info, sys_info)

% (c) M. Zhong (JHU)

% initialize some terms
[num_kinds, kind_types] = get_phi_or_rho_kinds(sys_info, 'phi');
Psis                    = cell(1, num_kinds);
for ind = 1 : num_kinds
  switch kind_types{ind}
    case 'energy'
      d                 = sys_info.d;
    case 'alignment'
      d                 = sys_info.d;
    case 'xi'
      d                 = 1;
    otherwise
      error('');
  end
  Psis{ind}             = assemble_the_learning_matrix_each_kind(psi_pdist{ind}, psi_pdiff{ind}, ...
                          phi_rest{ind}, basis{ind}, d, L, agent_info, sys_info);
end
if sys_info.ode_order == 1
  Psi                   = Psis{1};
  PsiXi                 = [];
  if num_kinds > 1
    PsiXi               = Psis{2};
  end
elseif sys_info.ode_order == 2
  switch num_kinds
    case 1
      Psi               = Psis{1};
      PsiXi             = [];
    case 2
      if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
        Psi             = Psis{1};
        PsiXi           = Psis{2};
      else
        Psi             = combine_ALMs(Psis{1}, Psis{2});
        PsiXi           = [];
      end
    case 3
      Psi               = combine_ALMs(Psis{1}, Psis{2});
      PsiXi             = Psis{3};
    otherwise
      error('');
  end
end
end