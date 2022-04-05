function [yint, ypint] = deval_symplectic(sol, tint)
% function [yint, ypint] = deval_symplectic(sol, tint)

% for dense output, according to the paper: Continuous Extensions to Nystrom Methods for the
% Explicit Solution of Second Order Initial Value Problems, Arne Marthinsen, 1995.
% dense output of symplectic RKN of order more than 1 is impossible, so we use observation gap

% not sure about partitioned Runge-Kutta yet, but guessing might be the same

% (C) M. Zhong (JHU)

validateattributes(tint, {'numeric'}, {'row', 'increasing', 'nonnegative'});
if length(tint) == 1
  h1          = tint - sol.x(1);
else
  h1          = tint(2) - tint(1);
end
h2            = sol.x(2) - sol.x(1);
multiplier    = fix(h1/h2);
if abs(multiplier - h1/h2) >= 1.e-14; error(''); end
x_len         = size(sol.y, 1)/2;
L             = length(tint);
yint          = zeros(2 * x_len, L);
ypint         = zeros(2 * x_len, L);
l_0           = find(sol.x >= tint(1), 1);
if abs(sol.x(l_0) - tint(1)) >= 1.e-14; error(''); end
for l = 1 : L
  l_sol       = (l - 1) * multiplier + l_0;
  yint(:, l)  = sol.y(:, l_sol);
  x_t         = yint(1 : x_len, l);
  v_t         = yint(x_len + 1 : 2 * x_len, l);
  a_t         = eval_rhs_rkn(x_t, sol.extdata.options.sys_info);
  ypint(:, l) = [v_t; a_t];
end
end