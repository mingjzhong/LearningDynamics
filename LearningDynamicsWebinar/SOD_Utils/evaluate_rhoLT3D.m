function rho = evaluate_rhoLT3D(r, s, z, rhoLT3D, densRhoLT3D)
% function rho = evaluate_rhoLT3D(r, s, z, rhoLT3D, densRhoLT3D)

% (c) M. Zhong (JHU)

validateattributes(r, {'numeric'}, {'nonnegative'},   'evaluate_rhoLT3D', 'r', 1);
validateattributes(s, {'numeric'}, {'size', size(r)}, 'evaluate_rhoLT3D', 's', 2);
validateattributes(z, {'numeric'}, {'size', size(r)}, 'evaluate_rhoLT3D', 'z', 3);
r_ind        = rhoLT3D.supp(1, 1) <= r & r <= rhoLT3D.supp(1, 2);
s_ind        = rhoLT3D.supp(2, 1) <= s & s <= rhoLT3D.supp(2, 2);
z_ind        = rhoLT3D.supp(3, 1) <= z & z <= rhoLT3D.supp(3, 2);
rho          = zeros(size(r));
ind          = r_ind & s_ind & z_ind;
rho(ind)     = densRhoLT3D(r(ind), s(ind), z(ind));
rho(rho < 0) = 0;                                                                                   % make sure everything is non-negative for probability
end