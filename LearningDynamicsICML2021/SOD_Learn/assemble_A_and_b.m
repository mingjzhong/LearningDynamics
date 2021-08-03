function [ALM, bLM, rhs_l2sq, ALMXi, bLMXi, rhsXi_l2sq] = assemble_A_and_b(M, L, basis, learn_info)
% function [ALM, bLM, rhs_l2sq, ALMXi, bLMXi, rhsXi_l2sq] = assemble_A_and_b(M, L, basis, learn_info)

% (C) M. Zhong

if isfield(learn_info.sys_info, 'phiXi') && ~isempty(learn_info.sys_info.phiXi)
  has_xi                               = true;
else
  has_xi                               = false;
end
rhs_l2sq                               = [];
rhsXi_l2sq                             = [];
agent_info                             = getAgentInfo(learn_info.sys_info);
if learn_info.is_parallel
  parfor m = 1 : M
    assemble_A_and_b_at_m(m, L, basis, agent_info, learn_info);
  end
  for m = 1 : M
    rhs_l2sq                           = add_dvec_norm(m, M, L, rhs_l2sq, [], learn_info, 'EA');
    if m == 1
      ALM                              = add_Psim_to_ALM(m, M, L, [], [], learn_info, 'EA');
      bLM                              = add_dvecm_to_bLM(m, M, L, [], [], [], learn_info, 'EA');      
    else
      ALM                              = add_Psim_to_ALM(m, M, L, ALM, [], learn_info, 'EA');
      bLM                              = add_dvecm_to_bLM(m, M, L, bLM, [], [], learn_info, 'EA');           
    end
    if has_xi
      rhsXi_l2sq                       = add_dvec_norm(m, M, L, rhsXi_l2sq, [], learn_info, 'xi');
      if m == 1
        ALMXi                          = add_Psim_to_ALM(m, M, L, [], [], learn_info, 'xi');
        bLMXi                          = add_dvecm_to_bLM(m, M, L, [], [], [], learn_info, 'xi');
      else
        ALMXi                          = add_Psim_to_ALM(m, M, L, ALMXi, [], learn_info, 'xi');
        bLMXi                          = add_dvecm_to_bLM(m, M, L, bLMXi, [], [], learn_info, 'xi');
      end
    else
      if m == 1
        ALMXi                          = [];
        bLMXi                          = [];
      end      
    end
  end
else
  for m = 1 : M
    [Psi_m, dvec_m, PsiXi_m, dvecXi_m] = assemble_A_and_b_at_m(m, L, basis, agent_info, learn_info);
    rhs_l2sq                           = add_dvec_norm(m, M, L, rhs_l2sq, dvec_m, learn_info, 'EA');
    if m == 1
      ALM                              = add_Psim_to_ALM(m, M, L, [], Psi_m, learn_info, 'EA');
      bLM                              = add_dvecm_to_bLM(m, M, L, [], Psi_m, dvec_m, learn_info, 'EA');      
    else
      ALM                              = add_Psim_to_ALM(m, M, L, ALM, Psi_m, learn_info, 'EA');
      bLM                              = add_dvecm_to_bLM(m, M, L, bLM, Psi_m, dvec_m, learn_info, 'EA');           
    end
    if ~isempty(has_xi)
      rhsXi_l2sq                       = add_dvec_norm(m, M, L, rhsXi_l2sq, dvecXi_m, learn_info, 'xi');
      if m == 1
        ALMXi                          = add_Psim_to_ALM(m, M, L, [], PsiXi_m, learn_info, 'xi');
        bLMXi                          = add_dvecm_to_bLM(m, M, L, [], PsiXi_m, dvecXi_m, learn_info, 'xi');
      else
        ALMXi                          = add_Psim_to_ALM(m, M, L, ALMXi, PsiXi_m, learn_info, 'xi');
        bLMXi                          = add_dvecm_to_bLM(m, M, L, bLMXi, PsiXi_m, dvecXi_m, learn_info, 'xi');
      end
    else
      if m == 1
        ALMXi                          = [];
        bLMXi                          = [];
      end      
    end
  end
end
end