function y_init = AD_init_config(d, N)
% function y_init = AD_init_config(d, N)

% (c) M. Zhong

switch d
  case 2
    x_init = uniform_dist(d, N, 'rectangle', [0, 5]);              
    v_init = uniform_dist(d, N, 'rectangle', [0, 5]);  
    y_init = [x_init(:); v_init(:)];
  case 3
    x_init = uniform_dist(d, N, 'cube',      [0, 5]);                          
    v_init = uniform_dist(d, N, 'cube',      [0, 5]);  
    y_init = [x_init(:); v_init(:)];    
  otherwise
end
end