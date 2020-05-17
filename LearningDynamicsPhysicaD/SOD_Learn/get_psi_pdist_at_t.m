function [psi_pdist_at_t, rho_weight_at_t] = get_psi_pdist_at_t(x, v, xi, agent_info, sys_info, learn_info, is_rhoLT)
% function [psi_pdist_at_t, rho_weight_at_t] = get_psi_pdist_at_t(x, v, xi, sys_info, learn_info, is_rhoLT)

% (C) M. Zhong (JHU)

psi_pdist_at_t  = get_phi_feature_map(x, v, xi, agent_info, sys_info, learn_info, is_rhoLT);
rho_weight_at_t = get_rho_weight(v, xi, agent_info, sys_info, learn_info, is_rhoLT);
end