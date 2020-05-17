function f_simple = construct_interpolant_1D(f, knots, degree)
% function f_simple = construct_interpolant_1D(f, knots, degree)

% (C) M. Zhong

r_pts            = get_sample_points_for_interpolant(knots, degree);
extra_method     = 'nearest';
switch degree
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
  f_simple       = griddedInterpolant(r_pts, f(r_pts), inter_method, extra_method);
catch
  f_simple       = f;
end
end