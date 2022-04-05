function y_init = SOD_init_config(d, N)
% function y_init = SOD_init_config(d, N)

% (c) M. Zhong

switch d
  case 2
    x_init  = uniform_dist(d, N, 'rectangle', [-1,  1]);
    xi_init = uniform_dist(1, N, 'line',      [-pi, pi]);
    y_init = [x_init(:); xi_init'];    
  case 3
    x_init  = uniform_dist(d, N, 'cube', [-1,  1]);
    xi_init = uniform_dist(1, N, 'line',      [-pi, pi]);
    y_init = [x_init(:); xi_init'];      
  otherwise
    error('');
end
end