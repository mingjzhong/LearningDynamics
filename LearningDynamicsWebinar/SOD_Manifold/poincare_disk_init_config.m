function y_init = poincare_disk_init_config(d, N, kind)
% function y_init = poincare_disk_init_config(d, N, kind)

% (c) M. Zhong, JHU

if nargin < 3, kind = 1; end
if d ~= 2, error(''); end
switch kind
  case 1
    b      = cosh(5) - 1;
    a      = (2 + 1/b - sqrt(4/b + 1/b^2))/2;
    y_init = uniform_dist(d, N, 'disk', a);
    y_init = y_init(:);    
  case 2
    b      = cosh(0.5) - 1;
    a      = (2 + 1/b - sqrt(4/b + 1/b^2))/2;
    y_pred = uniform_dist(d, 1, 'disk', a);
    b1     = cosh(1) - 1;
    a1     = (2 + 1/b1 - sqrt(4/b1 + 1/b1^2))/2;
    b2     = cosh(2) - 1;
    a2     = (2 + 1/b2 - sqrt(4/b2 + 1/b2^2))/2;
    y_prey = uniform_dist(d, N - 1, 'annulus', [a1, a2]);
    y_init = [y_prey, y_pred];
    y_init = y_init(:);
  otherwise
    error('');
end

end