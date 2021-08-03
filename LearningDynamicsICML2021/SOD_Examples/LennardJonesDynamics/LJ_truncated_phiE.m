function f = LJ_truncated_phiE(r, epsilon, sigma)
% function f = LJ_truncated_phiE(r, epsilon, sigma)
%
% The Lennard Jones Potential:
% \Phi_LJ = 4 * epsilon * [(sigma/r)^12 - (sigma/r)^6)]
% epsilon: depth of the potential well
% sigma: finite distance at which the inter-particle potential is zero
% distance at which the potential reaches its mininum: r_m = 2^(1/6) * sigma
% Corresponding to influence function:
% phi(r) = \Phi_LJ(r)'/r = 24 * epsilon/(sigma^2) * [-2*(sigma/r)^14 + (sigma/r)^8]
% source: wikipedia, https://en.wikipedia.org/wiki/Lennard-Jones_potential

% (c) M. Zhong, M. Maggioni

r_trunc = sigma;

ind     = r>=r_trunc;
rinv    = sigma./r(ind);
f(ind)  = 24 * epsilon/(sigma^2) * (-2*(rinv.^14) + (rinv.^8));

ind     = r<r_trunc;
rinv    = sigma./r_trunc;
f(ind)  = 24 * epsilon/(sigma^2) * (-2*(rinv.^14) + (rinv.^8));

f       = reshape(f,size(r));
end