function basis_info = set_JPL_basis_info(basis_info, num_sub_intervals, degree)
% function basis_info = set_JPL_basis_info(basis_info, num_sub_intervals, degree)

% (C) M. Zhong

K                                 = size(basis_info, 1);          
for k1 = 1 : K
  for k2 = 1 : K
    if k1 ~= k2
      basis_info{k1, k2}.degree   = degree;
      basis_info{k1, k2}.n        = num_sub_intervals + degree;
      basis_info{k1, k2}.dim      = 1;
      basis_info{k1, k2}.type     = {'B-spline'};
      basis_info{k1, k2}.sub_type = {'Clamped'};
      basis_info{k1, k2}.period   = Inf;
    end
  end
end
end