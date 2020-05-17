function y = basis_B_spline(x, eta, p, knots)
% y = basis_B_spline(x, eta, p, knots)
% finds the value of the eta-th B-spline basis function of degree p (p >= 0, order = p + 1) at the point(s) x. 
% The B-spline functions are defined by the knots (knot_vec) and it is defined recursively.  The 
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
%   x     - the point(s) to evaluate a B-spline basis function
%   i     - the eta-th B-spline basis function, 1 <= eta <= #|knot_vec| - p
%   p     - the degree of B-spline basis, p >= 0
%   knots - the knot vector contains a list of increase points in an interval: [knots(1), knots(end)]
% Output:
%   y     - the value of the eta-th B-spline basis function of degree p

% (C) M. Zhong (JHU)

% check the parameters
validateattributes(eta,   {'numeric'}, {'positive',   'integer', 'scalar'});
validateattributes(p,     {'numeric'}, {'nonnegative','integer', 'scalar'});
validateattributes(knots, {'numeric'}, {'real','vector'});
assert(all(knots(2 : end) - knots(1 : end - 1) >= 0), 'Knot vector values should be non-decreasing.');
% find out the number of elements in the knot vector
num_element  = length(knots);
assert(num_element >= p + 2, 'knot vector should have at least %d elements.', p + 2);
assert(1 <= eta && eta <= num_element - p - 1, ['Invalid basis index eta = %d, expected 1 <= eta ' ...
  '<= %d (1 <= eta <= length(knot_vec) - p - 1).', eta, num_element - p - 1]);
% the returned value, y, should have the same size as input x
y            = zeros(size(x));
% find the B-spline polynomial by its order
if p == 0
  if knots(eta) ~= knots(eta + 1)
% the eta-th degree 0 B-spline is supported on [x_i, x_{i + 1}); when x_{i + 1} is the end point of
% the whole interval, then make it supported on [x_i, x_{i + 1}].
    if knots(eta + 1) == knots(end), ind = knots(eta) <= x & x <= knots(eta + 1); 
    else, ind = knots(eta) <= x & x < knots(eta + 1); end
    y(ind)   = 1;
  end
else
% since we are using the same knot vector, simplify
  B_spline   = @(x, eta, p) basis_B_spline(x, eta, p, knots);
% calculate the recursion formula by cases
  if knots(eta) == knots(eta + p + 1)
% do nothing, y and yprime are already initialized to 0
  elseif knots(eta) < knots(eta + p) && knots(eta + 1) == knots(eta + p + 1)
    y        = (x - knots(eta))/(knots(eta + p) - knots(eta)) .* B_spline(x, eta, p - 1);
  elseif knots(eta) == knots(eta + p) && knots(eta + 1) < knots(eta + p + 1)   
    y        = (knots(eta + p + 1) - x)/(knots(eta + p + 1) - knots(eta + 1)) .* ...
      B_spline(x, eta + 1, p - 1);
  else
    y        = (x - knots(eta))/(knots(eta + p) - knots(eta)) .* B_spline(x, eta, p - 1) + ...
      (knots(eta + p + 1) - x)/(knots(eta + p + 1) - knots(eta + 1)) .* B_spline(x, eta + 1, p - 1);
  end
end