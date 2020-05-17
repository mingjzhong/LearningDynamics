function y_init = OD_init_config(d, N)
% function y_init = OD_init_config(d, N)

% (c) M. Zhong, JHU

switch d
  case 1
    y_init = uniform_dist(d, N, 'line',      [0, 10]);
  case 2
    y_init = uniform_dist(d, N, 'rectangle', [0, 5]);
    y_init = y_init(:);
  otherwise
end
end