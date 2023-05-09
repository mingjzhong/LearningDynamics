function L2rhoLT = L2_rhoLT2D(f, rhoLT2D, supp)
% function L2rhoT = L2_rhoLT2D(f, rhoLT2D, supp)
% calculates the L2_rhoLT norm of f(r) over [a, b] or f(r, s) over [a, b]x[c, d], it is given as
% 1) \sqrt(\int_a^b\int_c^d (f(r, s^x) * r)^2 * drhoLT(r, s^x)), or
% 2) \sqrt(\int_a^b\int_{range of \dot{r}} (f(r) * \dot{r})^2 * drhoLT(r, \dot{r})), or
% 3) \sqrt(\int_a^b\int_{range of \xi} (f(r) * \xi)^2 * drhoLT(r, \xi))
% 4) \sqrt(\int_a^b\int_{range of s^\xi} (f(r, x^\xi)^2 * drhoLT(r, s^\xi))
% Input:
%   f       - the target function
%   rhoLT2D - the probability distribution rho_T^L(r, s^x), or rho_T^L(r, \dot{r}), or rho_T^L(r, \xi)
%             , or rho_T^L(r, s^\xi)
%   range   - gives [a, b] or [a, b] x [c, d]
% Output:
%   the L2(rhoLT) norm of f over certain range

% (C) M. Zhong (JHU)

r_range   = intersectInterval(rhoLT2D.supp(1, :), supp(1, :));
resol     = 2000;
r_ctrs    = linspace(r_range(1), r_range(2), resol + 1);
h_r       = r_ctrs(2) - r_ctrs(1);
f_dim     = size(supp, 1);
if f_dim == 1    % x =\dot{r}, or \xi
  s_range = rhoLT2D.supp(2, :);
else             % x = s
  s_range = intersectInterval(rhoLT2D.supp(2, :), supp(2, :));
end
s_ctrs    = linspace(s_range(1), s_range(2), resol + 1);
h_s       = s_ctrs(2) - s_ctrs(1);
[R, S]    = ndgrid(r_ctrs, s_ctrs);
drhos     = h_r * h_s * rhoLT2D.dense(R, S);
if rhoLT2D.has_weight 
  switch rhoLT2D.weight_pos
    case 1
      W   = R;
    case 2
      W   = S;
    otherwise
  end
else
  W       = 1;  
end
if f_dim == 1
  L2rhoLT = sqrt(sum(sum((f(R)    .* W).^2 .* drhos)));
else
  L2rhoLT = sqrt(sum(sum((f(R, S) .* W).^2 .* drhos)));
end
end