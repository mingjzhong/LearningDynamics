function y_init = SPPD_init_config(d, N, ell_a)
% function y_init = SPPD_init_config(d, N, ell_a)

% (c) M. Zhong

if nargin < 3, ell_a = []; end
switch d
  case 2
    x_init = uniform_dist(d, N, 'rectangle', [0, 1]);              
    v_init = zeros(d, N);  
    y_init = [x_init(:); v_init(:)];
  case 3
    x_init = uniform_dist(d, N, 'cube',      [0, 3^(1/3) * ell_a]);                          
    v_init = zeros(d, N); 
    y_init = [x_init(:); v_init(:)];    
  otherwise
end
end