function f_simple = construct_interpolant_2D(f, knots, degree, basis_plan)
% function f_simple = construct_interpolant_2D(f, knots, degree, basis_plan)

% (C) M. Zhong

if length(knots) == length(degree)
% the first dimension
  r_pts          = get_sample_points_for_interpolant(knots{1});
% the second dimension
  s_pts          = get_sample_points_for_interpolant(knots{2});
% form the 2D grid, use only ndgrid due to the ordering issue
  [R, S]         = ndgrid(r_pts, s_pts);  
else
  [R, S]         = build_nd_grid(knots, degree, basis_plan);
end
extra_method     = 'nearest';
theDegree        = min(degree);
switch theDegree
  case 0
    inter_method = 'nearest'; % discontinuous
  case 1
    inter_method = 'linear';  % C^0
  case 2
    inter_method = 'makima';  % C^1
  otherwise
    inter_method = 'spline';  % C^2
end
try
  f_simple       = griddedInterpolant(R, S, f(R, S), inter_method, extra_method);
catch
  f_simple       = f;
end
end