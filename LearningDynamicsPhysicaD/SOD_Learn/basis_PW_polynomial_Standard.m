function [y, dy, d2y] = basis_PW_polynomial_Standard(x, p)
% [y, dy, d2y] = basis_PW_polynomial_Standard(x, p)

% (C) M. Zhong (JHU)

% the polynomial value
y      = zeros(size(x));
% the 1st derivative of the polynomial
dy     = zeros(size(x));
% the 2nd derivative of the polynomial
d2y    = zeros(size(x));
% where x is in [-1, 1]
ind    = -1 <= x & x <= 1;
% return the values
y(ind) = x(ind).^p;
if p > 0, dy(ind)  = p * x(ind).^(p - 1); end
if p > 1, d2y(ind) = p * (p - 1) * x(ind).^(p - 2); end
end