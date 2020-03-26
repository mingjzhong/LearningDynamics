function influence = OD_influence(r, type)
% influence = OD_influence(r, type)

% (c) M. Zhong (JHU)

persistent f_influence

influence = zeros(size(r));
cutoff    = 1/sqrt(2);
support   = 1;
switch type
  case 1
    ind            = 0 < r & r < cutoff;
    influence(ind) = 1;
    ind            = cutoff <= r & r < support;
    influence(ind) = 0.1;
  case 2
    ind            = 0 < r & r < cutoff;
    influence(ind) = 1;
    ind            = cutoff <= r & r < support;
    influence(ind) = 1;
  case 3
    ind            = 0 < r & r < cutoff;
    influence(ind) = 0.5;
    ind            = cutoff <= r & r < support;
    influence(ind) = 1;
  case 4
    ind            = 0 < r & r < cutoff;
    influence(ind) = 0.1;
    ind            = cutoff <= r & r < support;
    influence(ind) = 1;
  case 5
% a continuous version of case 1      
    delta          = 0.05;
    ind            = 0                 < r & r < (cutoff - delta);
    influence(ind) = 1;
    ind            = (cutoff - delta)  <= r & r < (cutoff + delta);
    y_1            = 1;
    y_2            = 0.1;
    influence(ind) = (y_2 - y_1)/(-2) * (cos(pi/(2 * delta) * (r(ind) - (cutoff - delta))) - 1) + y_1;
    ind            = (cutoff + delta)  <= r & r < (support - delta);
    influence(ind) = 0.1;
    ind            = (support - delta) <= r & r < (support + delta);
    y_1            = 0.1;
    y_2            = 0;
    influence(ind) = (y_2 - y_1)/(-2) * (cos(pi/(2 * delta) * (r(ind) - (support - delta))) - 1) + y_1;
  otherwise
    error('opinion_dynamics:OD_influence:exception', 'Only 5 kinds of influence functions are implemented!!');
end
end