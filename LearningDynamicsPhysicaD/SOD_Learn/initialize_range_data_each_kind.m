function [phi_range, rho_range] = initialize_range_data_each_kind(sys_info, learn_info, is_rhoLT, M, kind)
% function [phi_range, rho_range] = initialize_range_data_each_kind(sys_info, learn_info, is_rhoLT, M, kind)

% (C) M. Zhong

[phi_dim, rho_dim] = get_phi_and_rho_dim_each_kind(kind, sys_info, learn_info, is_rhoLT);
phi_range          = initialize_range(phi_dim, sys_info.K, M);
rho_range          = initialize_range(rho_dim, sys_info.K, M);
end