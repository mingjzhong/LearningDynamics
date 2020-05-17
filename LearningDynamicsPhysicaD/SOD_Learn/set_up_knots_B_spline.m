function knots = set_up_knots_B_spline(range, p, n, type, knots_ext, knot_size)
% knots = set_up_knots_B_spline(range, p, n, type)
% construct a B-spline knots on the interval [a, b], given by range.
% Input:
%   p:     degree of the B-spline basis functions, start from 
%          p = 0, corresponding to constant B-spline
%   n:     number of basis function
%   range: the interval of support, of size 1x2
%   type:  'Clamped' or not
% Output:
%   knots: the points where the basis is built

% (C) M. Zhong

% construct the B-spline knots, the degree of the B-spline, p starts from 0, with p = 0 referring to 
% constant step function, p = 1 to linear function
if p < 0
  error('SOD_Learn:set_up_knots_B_spline:exception', ...
    'The degree for B-spline basis has to be non-negative!!');
end
if nargin < 6, knot_size = []; end
switch type
  case 'Clamped'
    if isempty(knots_ext)
% In order to match the first and last control points, we will use Clamped B-spline, that is, for B-spline 
% of degree p supported on [a, b], the first knot points in the knot vector get repeated (p + 1) more times, 
% and the last knot points in the knot vector get repeated (p + 1) more times, i.e.,
% knot_vec = [x_1, x_2, \ldots, x_m], then x_1 = x_2 = \ldots = x_{p + 1} = a, and 
% x_{m - p - 1} = x_{m - p} = \ldots = x_m = b.  Given an increasing knot on [a, b], we should add 
% to the left of the kont vector, p copies of a, and to the right of the knot, p copies of b.    
% B-spline basis functions are all supported on [a, b]
      a          = range(1);
      b          = range(2);
% since we are using clamped B-spline, the number of basis functions, has to be bigger than p
  validateattributes(n, {'numeric'}, {'integer', 'positive', '>', p}, 'spline_info', 'num_basis');
% construct a knot vector (or a knot sequence) of increasing knots from the  interval [a, b], since 
% the knot spans are of the same size, it is an uniform knot vector, and the number of (non-repeated) 
% knots on [a, b] are n - p + 1
      if ~isempty(knot_size)
        n_thresh = ceil((b - a)/knot_size) + p;
      else
        n_thresh = n;
      end
      n          = min([n, n_thresh]);
      basic_knot = linspace(a, b, n - p + 1);
% in order to reach the last and first control points, we have clamped B-splines, which means the first 
% and last knots each gets repeated p + 1 times.
      knots = [a * ones(1, p),  basic_knot, b * ones(1, p)];
    else
% if we are given knot vector (especially used in the adaptive learning case), then we generate the 
% clamped B-spline using that.  Making sure the left end point and right end point do not get repeated
% to begin with, repated points in the interior of the knot is ok
      num_knots  = length(knots_ext);
      validateattributes(num_knots, {'numeric'}, {'integer', 'positive', '>=', 2});
% making sure knot_vec is a row vector with increasing values
      validateattributes(knots_ext, {'numeric'}, {'vector', 'row', 'nondecreasing'});
% since a knot vector is already given, use it to find the interval on which the B-spline functions are 
% supported, a is the left end point, and b is the right end point
      a          = knots_ext(1);
      b          = knots_ext(end);
% now we can begin to put the clamped-ness into the knots_ext
      knots = [a * ones(1, p),  knots_ext, b * ones(1, p)];     
    end
  otherwise
    error('');
end
end