function [sys_info_PO, learn_info_PO] = get_partial_info(sys_info, learn_info, N_new)
% function [sys_info_PO, learn_info_PO] = get_partial_info(sys_info, learn_info, N_new)

% (C) M. Zhong

% system 
sys_info_PO                = sys_info;
sys_info_PO.N              = N_new;
sys_info_PO.AO_names       = sys_info.AO_names(1 : N_new);
sys_info_PO.known_mass     = sys_info.known_mass(1 : N_new);
sys_info_PO.orbitalPeriods = sys_info.orbitalPeriods(1 : N_new);
sys_info_PO.K              = N_new;
sys_info_PO.type_info      = 1 : N_new;
sys_info_PO.agent_mass     = sys_info.agent_mass(1 : N_new);
sys_info_PO.phiE           = sys_info.phiE(1 : N_new, 1 : N_new);
sys_info_PO.phiE_Newton    = sys_info.phiE_Newton(1 : N_new, 1 : N_new);
sys_info_PO.phiE_Einstein  = sys_info.phiE_Einstein(1 : N_new, 1 : N_new);
% Learning
learn_info_PO              = learn_info;
learn_info_PO.Ebasis_info  = learn_info.Ebasis_info(1 : N_new, 1 : N_new);
end