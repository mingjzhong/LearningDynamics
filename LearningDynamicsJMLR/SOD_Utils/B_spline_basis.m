function [y, yprime] = B_spline_basis(x, i, k, knot_vec)
% [y, yprime] = B_spline_basis(x, i, k, knot_vec)
% finds the value of the i-th B-spline basis function of degree k (k >= 0)
% at the point(s) x.  The B-spline functions are defined by the knot vector
% (knot_vec) and it is defined recursively.  The knot vector contains a 
% list of non-decreasing points (knots): 
% x_1 <= x_2 <= ... <= x_{#|knot_vec|}.  
% Then the i-th B-spline basis function is compactly support on the 
% interval: [x_i, x_{i + k + 1}), it is right continuous. 
% The basis index i, starts from 1, and the degree index k starts from 0.
% The 0-th degree (k = 0) B-spline basis function is a step function:
% B_{i, 1}(x) = 0                          if x_i = x_{i + 1}
%             = \chi_{[x_i, x_{i + 1})}(x) if x_i < x_{i + 1}
% \chi_{[x_i, x_{i + 1})} is a characteristic function on [x_i, x_{i + 1})
% for k >= 1, the relationship is defined recursively:
% B_{i, k}(x) ...
%    = 0               if x_i = x_{i + k + 1}
%    = S_1(x)          if x_i < x_{i + k} and x_{i + 1} = x_{i + k + 1}
%    = S_2(x)          if x_i = x_{i + k} and x_{i + 1} < x_{i + k + 1}
%    = S_1(x) + S_2(s) otherwise
% where:
% S_1(x) = (x - x_i)/(x_{i + k} - x_i) * B_{i, k - 1}(x)
% S_2(x) = ...
%   (x_{i + k + 1} - x)/(x_{i + k + 1} - x_{i + 1}) * B_{i + 1, k - 1)(x)
% d/dx(B_{i, k}(x) ...
%    = 0                   if x_i = x_{i + k + 1}
%    = S^*_1(x)            if x_i < x_{i + k} and x_{i + 1} = x_{i + k + 1}
%    = S^*_2(x)            if x_i = x_{i + k} and x_{i + 1} < x_{i + k + 1}
%    = S^*_1(x) + S^*_2(s) otherwise
% where:
% S^*_1(x) = B_{i, k - 1}(x)/(x_{i + k} - x_i)
% S^*_2(x) = B_{i + 1, k - 1)(x)/(x_{i + k + 1} - x_{i + 1})
% The number of B-spline basis functions on a knot, denoted as D, and the
% number of elements in a knot vector, denoted as #|knot_vec|, and the 
% degree of the B-spline (k), satisfy the following formula:
% #|knot_vec| = D + k + 1
% Input:
%   x        - the point(s) to evaluate a B-spline basis function
%   i        - the i-th B-spline basis function, 1 <= i <= num_elm - k
%   k        - the degree index, 0 <= k
%   knot_vec - the knot vector contains a list of increase points in an
%              interval: [knot(1), knot(end)]
% Output:
%   y        - the value of the i-th B-spline basis function of order k

% Ming Zhong
% Postdoc Research

% check the parameters
validateattributes(i,        {'numeric'}, {'positive',   'integer', 'scalar'});
validateattributes(k,        {'numeric'}, {'nonnegative','integer', 'scalar'});
validateattributes(knot_vec, {'numeric'}, {'real','vector'});
assert(all(knot_vec(2 : end) - knot_vec(1 : end - 1) >= 0), 'Knot vector values should be non-decreasing.');
% find out the number of elements in the knot vector
num_element  = length(knot_vec);
assert(num_element >= k + 2, 'knot vector should have at least %d elements.', k + 2);
assert(1 <= i && i <= num_element - k - 1, 'Invalid basis index i = %d, expected 1 <= i <= %d (1 <= i <= length(knot_vec) - k - 1).', i, num_element - k - 1);
% the returned value, y, should have the same size as input x
y            = zeros(size(x));
% the first derivate yprime, should have the same size as input x
yprime       = zeros(size(x));
% calculate x_i and x_{i + 1}
x_i          = knot_vec(i);
x_ip1        = knot_vec(i + 1);
% find the B-spline polynomial by its order
if k == 0
% the step function, B-spline
% the base case for the recursion
% do it when x_i is different from x_{i + 1}
  if x_i == x_ip1
% do nothing, y is already initialized to 0    
  else
% find out the interval [x_i, x_{i + 1}), where the i-th B-spline belongs
% in MATLAB the index starts out from 1
    indices    = x_i <= x & x < x_ip1;
% for the first order, B-splines are characteristic functions on interval
% [x_i, x_{i + 1}]
    y(indices) = 1;
% for k = 0, constant B-spline functions, its derivative is zero
% do nothing, yprime is already initialized to 0
  end
else
% since we are using the same knot vector, simplify
  B_spline   = @(x, i, k) B_spline_basis(x, i, k, knot_vec);
% calculate x_{i + k - 1} and x_{i + k}
  x_ipkp1    = knot_vec(i + k + 1);
  x_ipk      = knot_vec(i + k);
% do it by cases
  if x_i == x_ipkp1
% do nothing, y      is already initialized to 0
% do nothing, yprime is already initialized to 0
  elseif x_i < x_ipk && x_ip1 == x_ipkp1
% calculate S_1(x)
    y        = (x - x_i)/(x_ipk - x_i) .* B_spline(x, i, k - 1);
% yprime is k * B_{i, k - 1}(x)/(x_{i + k} - x_i)
    yprime   = k * B_spline(x, i, k - 1)/(x_ipk - x_i);
  elseif x_i == x_ipk && x_ip1 < x_ipkp1
% Calculuate S_2(x)    
    y        = (x_ipkp1 - x)/(x_ipkp1 - x_ip1) .* ...
      B_spline(x, i + 1, k - 1);
% yprime is -k * B_{i + 1, k - 1}(x)/(x_{i + k + 1} - x_{i + 1})
    yprime   = -k * B_spline(x, i + 1, k - 1)/(x_ipkp1 - x_ip1);
  else
% use the B-spline recursion formula  
    y        = (x - x_i)/(x_ipk - x_i) .* B_spline(x, i, k - 1) + ...
      (x_ipkp1 - x)/(x_ipkp1 - x_ip1) .* B_spline(x, i + 1, k - 1);
% use the derivative B-spline recursion formula
    yprime   = k * (B_spline(x, i, k - 1)/(x_ipk - x_i) - ...
      B_spline(x, i + 1, k - 1)/(x_ipkp1 - x_ip1));
  end
end