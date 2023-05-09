function [y_n, nfevals] = symplectic_integrate_single_step(y_nm1, h, ode_fun, opts, solver, ...
                          is_explicit)
% function [y_n, nfevals] = symplectic_integrate_single_step(y_nm1, h, ode_fun, opts, solver, ...
%                           is_explicit)

% (C) M. Zhong (JHU)

switch solver
  case 'Runge-Kutta-Nystrom'
    if is_explicit
      [y_n, nfevals] = single_rkn_step_explicit(y_nm1, h, ode_fun, opts.order);
    else
      [y_n, nfevals] = single_rkn_step_implicit(y_nm1, h, ode_fun, opts.order);  
    end
  case 'partitioned-Runge-Kutta'
    [y_n, nfevals]   = single_prk_step(y_nm1, h, ode_fun, opts.order);
  case 'Leapfrog'
    [y_n, nfevals]   = single_lf_step(y_nm1, h, ode_fun, opts.order);
  otherwise
    error('SOD_Evovle:symplectic_integrate_single_step:exception', ...
      'Only RKN and PRK are being considered!!');
end
end