function rho = evaluate_rhoLT3D(r, s, z, rhoLT3D)
% function rho = evaluate_rhoLT3D(r, s, z, rhoLT3D)

% (c) M. Zhong (JHU)

% validateattributes(r, {'numeric'}, {'nonnegative'},   'evaluate_rhoLT3D', 'r', 1);
% validateattributes(s, {'numeric'}, {'size', size(r)}, 'evaluate_rhoLT3D', 's', 2);
% validateattributes(z, {'numeric'}, {'size', size(r)}, 'evaluate_rhoLT3D', 'z', 3);
r_range      = rhoLT3D.supp(1, :);
s_range      = rhoLT3D.supp(2, :);
z_range      = rhoLT3D.supp(3, :);
r_ctrs       = (rhoLT3D.histedges{1}(2 : end) + rhoLT3D.histedges{1}(1 : end - 1))/2;
s_ctrs       = (rhoLT3D.histedges{2}(2 : end) + rhoLT3D.histedges{2}(1 : end - 1))/2;
z_ctrs       = (rhoLT3D.histedges{3}(2 : end) + rhoLT3D.histedges{3}(1 : end - 1))/2;
[R, S, Z]    = ndgrid(r_ctrs, s_ctrs, z_ctrs);                                                      % different from meshgrid even in 2D
densRhoLT3D  = griddedInterpolant(R, S, Z, rhoLT3D.hist, 'linear', 'linear');
r_ind        = r_range(1) <= r & r <= r_range(2);
s_ind        = s_range(1) <= s & s <= s_range(2);
z_ind        = z_range(1) <= z & z <= z_range(2);
rho          = zeros(size(r));
ind          = r_ind & s_ind & z_ind;
rho(ind)     = densRhoLT3D(r(ind), s(ind), z(ind));
rho(rho < 0) = 0;                                                                                   % make sure everything is non-negative for probability
end