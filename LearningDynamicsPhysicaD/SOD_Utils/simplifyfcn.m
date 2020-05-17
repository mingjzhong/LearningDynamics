function f_simple = simplifyfcn(f, knots, degree)
% function f_simple = simplifyfcn(f, knots, degree)

% (C) M. Zhong 

if ~iscell(knots)
  f_simple     = construct_interpolant_1D(f, knots, degree);
else
  switch length(knots)
    case 2
      f_simple = construct_interpolant_2D(f, knots, degree);
    case 3
      f_simple = construct_interpolant_3D(f, knots, degree);
    otherwise
      error('');
  end
end
end