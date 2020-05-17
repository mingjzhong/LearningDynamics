function psi_pdiff =  get_psi_pdiff_at_t(x, v, xi, sys_info, learn_info, is_rhoLT)
% function Psi_pdiff =  get_psi_pdiff_at_t(x, v, xi, sys_info, learn_info, is_rhoLT)

% (C) M. Zhong

if is_rhoLT
  psi_pdiff = [];
else
  psi_pdiff = get_phi_weight(x, v, xi, sys_info, learn_info, is_rhoLT);                             % use the same function for evolution
end
end