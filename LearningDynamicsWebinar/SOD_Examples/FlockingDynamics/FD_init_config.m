function y_init = FD_init_config(sys_info)
% function y_init = FD_init_config(sys_info)

% (c) M. Zhong

switch sys_info.d
  case 2
    if sys_info.ode_order == 1
      x_init  = uniform_dist(sys_info.d, sys_info.N, 'rectangle', [0, sys_info.L]);
      xi_init = uniform_dist(1,          sys_info.N, 'line',      [-pi, pi]);
      y_init  = [x_init(:); xi_init(:)];
    elseif sys_info.ode_order == 2
      x_init  = uniform_dist(sys_info.d, sys_info.N, 'rectangle', [-5, 5]);
      v_init  = uniform_dist(sys_info.d, sys_info.N, 'rectangle', [-5, 5]);
      y_init  = [x_init(:); v_init(:)];  
    end
  otherwise
    error('SOD_Examples:FD_init_config:exception', 'Only 2D x and v are supported!!');
end
end