function f = LJ_C1truncated_phiE(r, epsilon, sigma, IR)
% function f = LJ_C1truncated_phiE(r, epsilon, sigma, IR)
%
% The Lennard Jones Potential:
% Phi_LJ(r) = 4 * epsilon * [(sigma/r)^12 - (sigma/r)^6)]
% epsilon: depth of the potential well
% sigma: finite distance at which the inter-particle potential is zero
% distance at which the potential reaches its mininum: r_m = 2^(1/6) * sigma
% source: wikipedia, https://en.wikipedia.org/wiki/Lennard-Jones_potential
% Corresponding to influence function:
% phi(r)  = Phi_LJ(r)'/r = 24 * epsilon/sigma^2 * [(sigma/r)^8 -2 * (sigma/r)^14]
% phi'(r) = 96 * epsilon/sigma^3 * [7 * (sigma/r)^15 - 2 * (sigma/r)^9]
% We need the new function f to have:
% 1) f is C^1
% 2) f(r) = 0 for r >= IR (the injective radius)
% 3) toward r = 0, f(r) cannot go to infinity too fast, i.e., lim_{r \rightarrow 0} f(r)r = 0.
%    hence f(0) is either a fixed number (no matter how big, prefer it to be small), or f(r) goes to
%    infinity slower than 1/r.
% since f'(IR) = 0, we will use spline-interpolation to come up with the truncated
% parts

% (c) M. Zhong

if IR == 0, error(''); end
% original phi(r) and phi'(r)
phi         = @(x) 24 * epsilon/sigma^2 * ((sigma./x).^8 - 2 * (sigma./x).^14);
dphi        = @(x) 96 * epsilon/sigma^3 * (7 * (sigma./x).^15 - 2 * (sigma./x).^9);
% pick a small threshold to turn it down to 0 in C^1 manner
f           = zeros(size(r));
% a truncation to prevent it from going to -infty
r_trunc     = sigma;
phi1        = phi(r_trunc);
dphi1       = dphi(r_trunc);
r_crit      = r_trunc/2;
% [0, r_c], it is a constant
ind         = 0 <= r & r < r_crit;
f(ind)      = phi1 - dphi1 * r_trunc/4;
% [r_c, r_t], it is a parabola
ind         = r_crit <= r & r <= r_trunc;
f(ind)      = dphi1/r_trunc * r(ind).^2 - dphi1 * r(ind) + phi1;
% ind       = 0 <= r & r <= r_trunc;
% x         = [0, r_trunc];
% y         = [-dphi(r_trunc), phi(r_trunc), phi(r_trunc), dphi(r_trunc)];
% f(ind)    = ppval(spline(x, y), r(ind));
% f(ind)    = dphi(r_trunc) * (r(ind) - r_trunc) + phi(r_trunc);
if IR ~= Inf
% [r_t, IR - threshold]
  threshold = IR/100;
  ind       = r > r_trunc & r < (IR - threshold);
  f(ind)    = phi(r(ind));
% [IR - threshold, IR]
  ind       = (IR - threshold) <= r & r <= IR;
  x         = [IR - threshold, IR];
  y         = [dphi(x(1)), phi(x(1)), 0, 0];
  f(ind)    = ppval(spline(x, y), r(ind));
else
  ind       = r > r_trunc;
  f(ind)    = phi(r(ind));
end
end