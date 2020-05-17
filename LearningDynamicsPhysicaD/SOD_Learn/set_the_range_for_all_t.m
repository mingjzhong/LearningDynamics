function [phi_range, rho_range] = set_the_range_for_all_t(phi_range_l, rho_range_l, m, K, phi_range, rho_range)
% function [phi_range, rho_range] = set_the_range_for_all_t(phi_range_l, rho_range_l, m, K, phi_range, rho_range)

% (C) M. Zhong

phi_range = set_one_range_for_all_t(phi_range_l, m, K, phi_range);
rho_range = set_one_range_for_all_t(rho_range_l, m, K, rho_range);
end