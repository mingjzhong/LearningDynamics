function [phi_range_new, rho_range_new] = set_the_range_for_all_m(phi_range, rho_range, K)
% function [phi_range_new, rho_range_new] = set_the_range_for_all_m(phi_range, rho_range, K)

% (C) M. Zhong


phi_range_new = set_one_range_for_all_m(K, phi_range);
rho_range_new = set_one_range_for_all_m(K, rho_range);
end