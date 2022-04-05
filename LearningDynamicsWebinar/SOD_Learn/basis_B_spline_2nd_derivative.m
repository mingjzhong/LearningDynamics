function ydprime = basis_B_spline_2nd_derivative(x, eta, p, knot_vec)
% ydprime = basis_B_spline_2nd_derivative(x, eta, p, knot_vec)
% finds the first derivative of the eta-th B-spline basis function of degree p (p >= 0, order = p + 1)
% at the point(s) x.  The B-spline functions are defined by the knots (knot_vec) and it is defined recursively.  The 
% knot vector contains a list of non-decreasing points (knots): x_1 <= x_2 <= ... <= x_{#|knot_vec|}.  
% Then the eta-th B-spline basis function is compactly support on the  interval: [x_i, x_{i + k + 1}), 
% it is right continuous. The basis functions are indexed by eta, starts from 1, and the degree p starts from 0.
% The 0-th degree (p = 0) B-spline basis function is a step function:
% B_{eta, 0}(x) = 0, if x_eta = x_{eta + 1}; = \chi_{[x_eta, x_{eta + 1})}(x) if x_eta < x_{eta + 1}
% \chi_{[x_eta, x_{eta + 1})} is a characteristic function on [x_eta, x_{eta + 1}).  For p >= 1:
% B_{eta, p}(x) = 0,               if x_eta = x_{eta + p + 1};
%               = S_1(x),          if x_eta < x_{eta + p} and x_{eta + 1} = x_{eta + p + 1};
%               = S_2(x),          if x_eta = x_{eta + p} and x_{eta + 1} < x_{eta + p + 1};
%               = S_1(x) + S_2(s), Otherwise.
% where:
% S_1(x) = (x - x_eta)/(x_{eta + p} - x_eta) * B_{eta, p - 1}(x)
% S_2(x) = (x_{eta + p + 1} - x)/(x_{eta + p + 1} - x_{eta + 1}) * B_{eta + 1, p - 1)(x)
% d/dx(B_{eta, p}(x) = 0,                   if x_eta = x_{eta + p + 1}
%                    = S^*_1(x),            if x_eta < x_{eta + p} and x_{eta + 1} = x_{eta + p + 1}
%                    = S^*_2(x),            if x_eta = x_{eta + p} and x_{eta + 1} < x_{eta + p + 1}
%                    = S^*_1(x) + S^*_2(s), Otherwise.
% where:
% S^*_1(x) = B_{eta,     p - 1}(x)/(x_{eta + p}     - x_eta)
% S^*_2(x) = B_{eta + 1, p - 1)(x)/(x_{eta + p + 1} - x_{eta + 1})
% The number of B-spline basis functions on a knot, denoted as n, and the number of elements in a knot vector, 
% denoted as #|knot_vec|, and the degree of the B-spline, denoted as p, satisfy the following formula:
% #|knot_vec| = n + p + 1
% Input:
%   x        - the point(s) to evaluate a B-spline basis function
%   i        - the eta-th B-spline basis function, 1 <= eta <= #|knot_vec| - p
%   p        - the degree of B-spline basis, p >= 0
%   knot_vec - the knot vector contains a list of increase points in an interval: [knot(1), knot(end)]
% Output:
%   y        - the value of the eta-th B-spline basis function of degree p

% (C) M. Zhong (JHU)

% check the parameters
validateattributes(eta,      {'numeric'}, {'positive',   'integer', 'scalar'});
validateattributes(p,        {'numeric'}, {'nonnegative','integer', 'scalar'});
validateattributes(knot_vec, {'numeric'}, {'real','vector'});
assert(all(knot_vec(2 : end) - knot_vec(1 : end - 1) >= 0), 'Knot vector values should be non-decreasing.');
% find out the number of elements in the knot vector
num_element  = length(knot_vec);
assert(num_element >= p + 2, 'knot vector should have at least %d elements.', p + 2);
assert(1 <= eta && eta <= num_element - p - 1, ['Invalid basis index eta = %d, expected 1 <= eta ' ...
  '<= %d (1 <= eta <= length(knot_vec) - p - 1).', eta, num_element - p - 1]);
% the first derivate yprime, should have the same size as input x
ydprime      = zeros(size(x));
% find the B-spline polynomial by its order
if p > 1 % second derivative of degree 0/1 B-splines are just zeo
% since we are using the same knot vector, simplify
  dB_spline  = @(x, eta, p) basis_B_spline_1st_derivative(x, eta, p, knot_vec);
% calculate the recursion formula by cases
  if knot_vec(eta) == knot_vec(eta + p + 1)
% do nothing, y and yprime are already initialized to 0
  elseif knot_vec(eta) < knot_vec(eta + p) && knot_vec(eta + 1) == knot_vec(eta + p + 1)
% yprime is p * B_{eta, p - 1}(x)/(x_{eta + p} - x_eta)
    ydprime   = p * dB_spline(x, eta, p - 1)/(knot_vec(eta + p) - knot_vec(eta));
  elseif knot_vec(eta) == knot_vec(eta + p) && knot_vec(eta + 1) < knot_vec(eta + p + 1)   
% yprime is -p * B_{eta + 1, p - 1}(x)/(x_{eta + p + 1} - x_{eta + 1})
    ydprime   = -p * dB_spline(x, eta + 1, p - 1)/(knot_vec(eta + p + 1) - knot_vec(eta + 1));
  else
% use the derivative B-spline recursion formula
    ydprime   = p * (dB_spline(x, eta, p - 1)/(knot_vec(eta + p) - knot_vec(eta)) - ...
      dB_spline(x, eta + 1, p - 1)/(knot_vec(eta + p + 1) - knot_vec(eta + 1)));
  end
end