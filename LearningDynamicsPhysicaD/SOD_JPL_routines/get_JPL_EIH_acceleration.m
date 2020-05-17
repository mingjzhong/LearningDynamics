function dy = get_JPL_EIH_acceleration(sys_info, solver_info, obs_data, option)
% function dy = get_JPL_EIH_acceleration(solver_info, obs_data, option)

% (C) M. Zhong

solver_info.rel_tol = 1e-12;
solver_info.abs_tol = 1e-15;
ode_opts            = odeset('RelTol', solver_info.rel_tol, 'AbsTol', solver_info.abs_tol);         % set ODE solver options
odefun              = @(t, y, yp) get_JPL_EIH_RHS(y, yp, sys_info);                                 % the EIH right hand side
switch option.method
  case 1
    y0              = obs_data.y(:, 1);
    yp0             = obs_data.dy(:, 1);
    t0              = obs_data.time_vec(1);
% improve it further with decic
    [~, yp0]        = decic(odefun, t0, y0, true(size(y0)), yp0, false(size(yp0)), ode_opts);
    dyn_EIH         = ode15i(odefun, solver_info.time_span, obs_data.ICs, yp0, ode_opts);
    [~, dy]         = dense_output(dyn_EIH, obs_data.time_vec);    
  case 2
    L               = size(obs_data.y, 2);
    dy              = zeros(size(obs_data.dy));
    t               = obs_data.time_vec;
    y               = obs_data.y;
    yp              = obs_data.dy;
    parfor l = 1 : L
      t_l           = t(l);
      y_l           = y(:, l);
      yp_l          = yp(:, l);
      [~, dy(:, l)] = decic(odefun, t_l, y_l, true(size(y_l)), yp_l, false(size(yp_l)), ode_opts);
    end
  otherwise
    error('');
end
end