function a_EIH = compute_JPL_EIH_acceleration(x, v, a, time_vec, rel_tol, abs_tol, sys_info)
% function a_EIH = compute_JPL_EIH_acceleration(x, v, a, time_vec, rel_tol, abs_tol, sys_info)

% (C) M. Zhong


ode_opts            = odeset('RelTol', rel_tol, 'AbsTol', abs_tol);        
odefun              = @(t, y, yp) get_JPL_EIH_RHS(y, yp, sys_info);   
L                   = size(x, 2);
y                   = [x; v];
yp                  = [v; a];
yp_EIH              = zeros(size(y));
parfor l = 1 : L
  t_l               = time_vec(l);
  y_l               = y(:, l);
  yp_l              = yp(:, l);
  [~, yp_EIH(:, l)] = decic(odefun, t_l, y_l, true(size(y_l)), yp_l, false(size(yp_l)), ode_opts);
end
oneBlock            = size(x, 1);
a_EIH               = yp_EIH(oneBlock + 1 : 2 * oneBlock, :);
end