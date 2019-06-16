function [psi, dpsi] = standard_basis(n, x, xspan)
%
%
%

% Ming Zhong
% Postdoc Researth at JHU

% find the interval where the function is supported: [x_k, x_kp1}
x_k         = xspan(1);
x_kp1       = xspan(2);
% it has to have increasing order
if x_kp1 <= x_k
  error('');
end
% only evaluate the points within this interval
ind         = find(x_k <= x & x < x_kp1);
% initiliaze the quantities
psi         = zeros(size(x));
dpsi        = zeros(size(x));
% the function value is x^n
psi(ind)    = x(ind).^n;
% the derivative is n * x^(n - 1) when n > 0
if n > 0
  dpsi(ind) = n * x(ind).^(n - 1);
end
end