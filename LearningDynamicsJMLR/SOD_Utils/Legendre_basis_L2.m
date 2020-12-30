function [psi, dpsi] = Legendre_basis_L2(n, x, xspan)
%
%
%

% Ming Zhong
% Postdoc Researth at JHU

% the support of the polynomial, [x_k, x_kp1]
x_k       = xspan(1);
x_kp1     = xspan(2);
% we need them in increasing order
if x_kp1 <= x_k
  error('');
end
% find out the step size
h_k       = x_kp1 - x_k;
% only find those within the interval [x_k, x_kp1]
ind       = find(x_k <= x & x < x_kp1);
% evaluate
[y, dy]   = Legendre_poly(n, 2 * (x(ind) - x_k)/h_k - 1);
% prepare the scaling
psi       = zeros(size(x));
dpsi      = zeros(size(x));
% scale the originals
psi(ind)  = sqrt(2 * n + 1)/sqrt(h_k) * y;
dpsi(ind) = sqrt(2 * n + 1)/sqrt(h_k) * dy * 2/h_k;
end