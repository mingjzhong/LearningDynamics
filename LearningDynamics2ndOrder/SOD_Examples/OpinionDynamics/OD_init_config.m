function y_init = OD_init_config(d, N, choice)
% function y_init = OD_init_config(d, N, choice)

% (c) M. Zhong, JHU

if nargin < 3, choice = 1; end
switch d
  case 1
    y_init     = uniform_dist(d, N, 'line',      [0, 10]);
  case 2
    switch choice
      case 1
        y_init = uniform_dist(d, N, 'rectangle', [0, 5]);
        y_init = y_init(:);        
      case 2
        y_init = uniform_dist(d, N, 'disk', 0.5);
        y_init = y_init(:);           
      otherwise
    end
  case 3
    y_init     = uniform_dist(d, N, 'rectangle', [0, 5]);
  otherwise
    error('');
end
end