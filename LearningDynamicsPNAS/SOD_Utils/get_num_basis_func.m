function ns = get_num_basis_func(sys_info)
% function ns = get_num_basis_func(sys_info)

% (c) M. Zhong

switch sys_info.name
  case 'Gravitation'
    Rs      = [0, 60, 110, 150, 230, 780, 2880, 4500, 5910];                                        % estimation of the max|x_i| for each planet
    Rs_cut  = Rs(1 : sys_info.N);
    max_Rs  = repmat(Rs_cut, [sys_info.N, 1]) + repmat(Rs_cut', [1, sys_info.N]);
    ns      = 2 * max_Rs;
    ind     = logical(eye(sys_info.N));
    ns(ind) = 1;
  otherwise
    error('SOD_Utils:get_num_basis_func:exception', 'Other systems are not yet implemented!!')
end
end