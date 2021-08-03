function L2rhoLT = L2_rhoLT3D(f, rhoLT3D, supp)
% function L2rhoT = L2_rhoLT3D(f, rhoLT3D, supp)
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

r_range   = intersectInterval(rhoLT3D.supp(1, :), supp(1, :));
relsol    = 1000;
r_ctrs    = get_centers_from_supp(r_range, relsol); 
h_r       = r_ctrs(2) - r_ctrs(1);
f_dim     = size(supp, 1);
if f_dim == 2            % x = s, y = \dot{r} or \xi
  s_range = intersectInterval(rhoLT3D.supp(2, :), supp(2, :));
  z_range = rhoLT3D.supp(3, :);
else                     % x = z_1, y = z_2
  s_range = intersectInterval(rhoLT3D.supp(2, :), supp(2, :));
  z_range = intersectInterval(rhoLT3D.supp(3, :), supp(3, :));
end
s_ctrs    = get_centers_from_supp(s_range, relsol); 
h_s       = s_ctrs(2) - s_ctrs(1);
z_ctrs    = get_centers_from_supp(z_range, relsol); 
h_z       = z_ctrs(2) - z_ctrs(1);
[R, S, Z] = ndgrid(r_ctrs, s_ctrs, z_ctrs);
drhos     = h_r * h_s * h_z * rhoLT3D.dense(R, S, Z);
if rhoLT2D.has_weight 
  switch rhoLT2D.weight_pos
    case 1
      W   = R;
    case 2
      W   = S;
    case 3
      W   = Z;
    otherwise
  end
else
  W       = 1;  
end
if f_dim == 2
  L2rhoLT = sqrt(sum(sum(sum((f(R, S)    .* W).^2 .* drhos))));
else
  L2rhoLT = sqrt(sum(sum(sum((f(R, S, Z) .* W).^2 .* drhos))));
end
end