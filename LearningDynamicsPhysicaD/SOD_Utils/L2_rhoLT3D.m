function L2rhoLT = L2_rhoLT3D(f, rhoLT3D, range)
% function L2rhoT = L2_rhoLT3D(f, rhoLT3D, range)
% calculates the L2_rhoLT norm of f(r, s) over [a, b]x[c, d] or f(r, s, z) over [a, b] x [c, d] x [e, f]
% it is given as
% 1) \sqrt(\int_a^b\int_c^d\int_{range of \dot{r}} (f(r, s^\dot{x}) * \dot{r})^2 * drhoLT(r, s, \dot{r})), or
% 2) \sqrt(\int_a^b\int_c^d\int_{range of \xi} (f(r, s^\xi) * \xi)^2 * drhoLT(r, s, \xi)), or
% 3) \sqrt(\int_a^b\int_c^d\int_e^f (f(r, s, z) * r)^2 * drhoLT(r, s, z))
% Input:
%   f       - the target function
%   rhoLT3D - the probability distribution rho_T^L(r, s^\dot{x}, \dot{r}), rho_T^L(r, s^\xi, \xi), 
%             or \rho(r, s, z)
%   range   - gives [a, b] x [c, d] or [a, b] x [c, d] x [e, f]
% Output:
%   the L2(rhoLT) norm of f over certain range

% (C) M. Zhong (JHU)

r_range                  = intersectInterval(rhoLT3D.supp{1}, range(1, :));
r_ctrs                   = linspace(r_range(1), r_range(2), 1000);
f_dim                    = size(range, 1);
if f_dim == 2            % x = s, y = \dot{r} or \xi
  s_range                = intersectInterval(rhoLT3D.supp{2}, range(2, :));
  z_range                = rhoLT3D.supp{3};
else                     % x = z_1, y = z_2
  s_range                = intersectInterval(rhoLT3D.supp{2}, range(2, :));
  z_range                = intersectInterval(rhoLT3D.supp{3}, range(3, :));
end
s_ctrs                   = linspace(s_range(1), s_range(2), 1000);
z_ctrs                   = linspace(z_range(1), z_range(2), 1000);
[R, S, Z]                = ndgrid(r_ctrs, s_ctrs, z_ctrs);
drhos                    = rhoLT3D.dense(R, S, Z);
if f_dim == 2
  L2rhoLT                = sqrt(sum(sum(sum((f(R, S) .* Z).^2 .* drhos))));
else
  L2rhoLT                = sqrt(sum(sum(sum((f(R, S, Z) .* R).^2 .* drhos))));
end
end