function phi = AD_phiE(r, s, tau, U_prime, U_dprime)
% function phi = AD_phiE(r, s, tau, U_prime, U_dprime)

% (C) M. Zhong

phi = tau * (U_dprime(r)./r.^(2) - U_prime(r)./r.^(3)) .* s + U_prime(r)./r;
end