function phi = SPPD_phiE(r, C_a, ell_a, C_r, ell_r, N)
% function phi = SPPD_phiE(r, C_a, ell_a, C_r, ell_r, N)
% multiplication by N due to the averaging 1/N 

% (c) M. Zhong


phi = N * (C_a/ell_a * exp(-r/ell_a) - C_r/ell_r * exp(-r/ell_r))./r;
end