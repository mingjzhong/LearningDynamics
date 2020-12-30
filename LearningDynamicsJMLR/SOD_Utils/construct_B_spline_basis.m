function basis = construct_B_spline_basis(spline_info)
% basis = construct_B_spline_basis(spline_info)
% construct a B-spline basis on the interval [a, b].
% Input:
%   spline_info  - informaiton about the clamped B-spline basis, with the following fields:
%     degree:        degree of the B-spline basis functions, start from 
%                    p = 0, corresponding to constant B-spline
%     num_basis:     number of basis function
%     left_end_pt:   left end point of [a, b]
%     right_end_pt:  right end point of [a, b]
%     knot_vec:      empty or the knots where the splines are built
% Output:
%   basis        - a struct which contains: f (the basis functions), knots, knotIdxs

% Ming Zhong
% Postdoc Research at JHU

% construct the B-spline basis
% the degree of the B-spline, k starts from 0, with p = 0 referring to 
% constant step function, k = 1 to linear function
p                 = spline_info.degree;
% the degree p has to be non-negative
if p < 0
  error('Utils:construct_basis', ...
    'The degree for B-spline basis has to be non-negative!!\n');
end
% find out what k (the degree), D_of_N (the total number of basis functions), 
% and the knot vector (the knots to place the B-spline basis functions on)
if spline_info.is_clamped
% In order to match the first and last control points, we will use Clamped
% B-spline, that is, for B-spline supported on [a, b], the first knot
% points in the knot vector get repeated (k + 1) more times, and the last
% knot points in the knot vector get repeated (k + 1) more times, i.e.,
% knot_vec = [x_1, x_2, \ldots, x_m], then x_1 = x_2 = \ldots = x_{p + 1} =
% a, and x_{m - p - 1} = x_{m - p} = \ldots = x_m = b.
% so given an increasing knot on [a, b], we should add to the left of the
% kont, (k + 1) copies of a, and to the right of the knot, (k + 1) copies
% of b.    
  if strcmp(spline_info.how_to_create, 'num_basis_first')
% B-spline basis functions are all supported on [a, b]
    a             = spline_info.left_end_pt;
    b             = spline_info.right_end_pt;      
% we generate the knot vector using the number of basis functions
% first, find out the number of basis functions
    D_of_N        = spline_info.num_basis;
% since we are using clamped B-spline, the number of basis functions,
% has to be bigger than p
    validateattributes(D_of_N, {'numeric'}, {'integer', 'positive', ...
    '>', p}, 'spline_info', 'num_basis');
% construct a knot vector (or a knot sequence) of increasing knots from the 
% interval [a, b], since the knot spans are of the same size, it is an 
% uniform knot vector, and the number of (non-repeated) knots on [a, b] are
% D_of_N - p + 1
    basic_knot    = linspace(a, b, D_of_N - p + 1);
% in order to reach the last and first control points, we have clamped
% B-splines, which means the first and last knots each gets repeated p + 1
% times.
    if p > 0
% for degree p > 0, we have to repeat the end points      
      knot_vec    = [a * ones(1, p),  basic_knot, b * ones(1, p)];
    else
% for degree p = 0, the control points are reachable      
      knot_vec    = basic_knot;  
    end
  elseif strcmp(spline_info.how_to_create, 'knot_vec_first')
% if we are given knot vector (especially used in the adaptive learning 
% case), then we generate the clamped B-spline using that.  Making sure the
% left end point and right end point do not get repeated to begin with,
% repated points in the interior of the knot is ok
    knot_vec      = spline_info.knot_vec;
% we need at least two knots in the knot_vec
    num_knots     = length(knot_vec);
    validateattributes(num_knots, {'numeric'}, {'integer', 'positive', ...
    '>=', 2}, 'spline_info', 'knot_vec');
% making sure knot_vec is a row vector with increasing values
    validateattributes(knot_vec, {'numeric'}, {'vector', 'row', ...
    'nondecreasing'}, 'spline_info', 'knot_vec');
% since a knot vector is already given, use it to find the interval on
% which the B-spline functions are supported, a is the left end point, and
% b is the right end point
    a             = knot_vec(1);
    b             = knot_vec(end);
% now we can begin to need the clamped-ness to the knot_vec
    basic_knot    = knot_vec;
    if p > 0
% for degree p > 0, we have to repeat the end points      
      knot_vec    = [a * ones(1, p),  basic_knot, b * ones(1, p)];
    else
% for degree p = 0, the control points are reachable      
      knot_vec    = basic_knot;  
    end
% the total number of knots (number of elements in the knot vector) and the
% number of basis functions and the degree of a B-spline basis function
% satisfy the following relation
    D_of_N           = length(knot_vec) - p - 1;
  end
else
% use the standard B-spline will have the function values at the two end 
% points mapped to 0.  The generation process depends on which route we
% take first
  if strcmp(spline_info.how_to_create, 'num_basis_first')
% B-spline basis functions are all supported on [a, b]
    a             = spline_info.left_end_pt;
    b             = spline_info.right_end_pt;     
% we genereat the knot vector based on the number of basis given
    D_of_N        = spline_info.num_basis;
% check the parameters
    validateattributes(a, {'numeric'}, {'scalar', 'nonnegative'}, ...
    'spline_info', 'left_end_pt');
    validateattributes(b, {'numeric'}, ...
    {'scalar', 'nonnegative', '>=', a}, 'spline_info', 'right_end_pt');
    validateattributes(D_of_N, {'numeric'}, {'integer', '>=', 1}, ...
    'spline_info', 'num_basis');
% the number of knots (strictly increasing) on [a, b] is
    num_knots     = D_of_N + p + 1;
% now we can generate the knot vector, with equally spaced points
    knot_vec      = linspace(a, b, num_knots);
  elseif strcmp(spline_info.how_to_create, 'knot_vec_first')
% find out if we have a strictly increasing knot
    knot_vec      = spline_info.knot_vec; 
% we need at least two knots in the knot_vec
    num_knots     = length(knot_vec);
    if num_knots < 2
      error('Utils:construct_basis', ...
        ['The number of knots (elements) in the given knot vector ' ...
        'has to be at least 2!!\n']);
    end
% we need the knot vector has non-decreasing knots
    validateattributes(knot_vec, {'numeric'}, ...
    {'vector', 'row', 'nondecreasing'}, 'spline_info', 'knot_vec');
% find out the number of basis functions
    D_of_N        = num_knots - p - 1;
  end
end
% once we have k, D_of_N, and knot_vec, we can generate the B-spline basis  
% the cell array which contains all the basis functions
basis_funs        = cell(1, D_of_N); 
% declare v_basis depends on the point x and also the order l  
for l = 1 : D_of_N  
  basis_funs{l}   = @(x) B_spline_basis(x, l, p, knot_vec);
end  
% save the basic part of the knot vector, when the spline is clamped
if spline_info.is_clamped
  knot_vec        = basic_knot;
end
% package the data
basis.f           = basis_funs;
basis.knots       = knot_vec;
basis.knotIdxs    = 1 : (length(knot_vec) - 1);
end