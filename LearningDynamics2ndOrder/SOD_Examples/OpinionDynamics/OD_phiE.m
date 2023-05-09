function phi = OD_phiE(r, type, IR)
% phi = OD_phiE(r, type, IR)
% phi is defined piecewise;
% phi(r) = phi_1 if 0 <= r < a, and phi_2 if a <= r < b, and 0 if r >= b

% (c) M. Zhong (JHU)

if nargin < 3, IR = 1; end
if IR <= 1, b = IR; else, b = 1; end
a             = b/sqrt(2);
phi           = zeros(size(r));
switch type
  case 1
    ind       = 0 <= r & r < a;
    phi(ind)  = 1;
    ind       = a <= r & r < b;
    phi(ind)  = 0.1;
  case 2
    ind       = 0 <= r & r < a;
    phi(ind)  = 1;
    ind       = a <= r & r < b;
    phi(ind)  = 1;
  case 3
    ind       = 0 <= r & r < a;
    phi(ind)  = 0.5;
    ind       = a <= r & r < b;
    phi(ind)  = 1;
  case 4
    ind       = 0 <= r & r < a;
    phi(ind)  = 0.1;
    ind       = a <= r & r < b;
    phi(ind)  = 1;
  case 5
% a C^1 version of case 1, phi(r) = 0 for r >= IR 
    threshold = b/100;
    ind       = 0 <= r & r < (a - threshold);
    phi(ind)  = 1;
    ind       = (a - threshold) <= r & r < a;
    x         = [a - threshold, a];
    y         = [0, 1, 0.1, 0];
    phi(ind)  = ppval(spline(x, y), r(ind));
    ind       = a <= r & r < (b - threshold);
    phi(ind)  = 0.1;    
    ind       = (b - threshold) <= r & r < b;
    x         = [b - threshold, b];
    y         = [0, 0.1, 0, 0];
    phi(ind)  = ppval(spline(x, y), r(ind));   
  otherwise
    error('opinion_dynamics:OD_influence:exception', 'Only 6 kinds of influence functions are implemented!!');
end
end