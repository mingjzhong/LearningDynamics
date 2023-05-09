function phi = AD_phiA(r, tau, U_prime)
% function phi = AD_phiA(r, tau, U_prime)

% (C) M. Zhong

phi = tau * U_prime(r) ./ r;
end