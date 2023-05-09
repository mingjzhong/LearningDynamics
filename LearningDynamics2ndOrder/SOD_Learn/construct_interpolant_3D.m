function f_simple = construct_interpolant_3D(f, knots, degree)
% function f_simple = construct_interpolant_3D(f, knots, degree)

% (C) M. Zhong

% the first dimension
r_pts            = get_sample_points_for_interpolant(knots{1});
% the second dimension
s_pts            = get_sample_points_for_interpolant(knots{2});
% the third dimension
z_pts            = get_sample_points_for_interpolant(knots{3});
% form the 2D grid, use only ndgrid due to the ordering issue
[R, S, Z]        = ndgrid(r_pts, s_pts, z_pts);  
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
  f_simple       = griddedInterpolant(R, S, Z, f(R, S, Z), inter_method, extra_method);
catch
  f_simple       = f;
end
end