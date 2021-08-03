function f_simple = simplifyfcn(f, knots, degree, basis_plan)
% function f_simple = simplifyfcn(f, knots, degree, basis_plan)

% (C) M. Zhong 

switch length(degree)
  case 1
    f_simple = construct_interpolant_1D(f, knots, degree);
  case 2
    f_simple = construct_interpolant_2D(f, knots, degree, basis_plan);
  case 3
    f_simple = construct_interpolant_3D(f, knots, degree, basis_plan);
  otherwise
    error('SOD_Learn:simplifyfcn:exception', ...
      'Dim. of the function can only be 1D/2D/3D!!');
end
end