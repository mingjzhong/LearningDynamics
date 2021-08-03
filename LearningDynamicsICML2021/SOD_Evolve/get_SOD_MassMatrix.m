function M_of_ty = get_SOD_MassMatrix(sys_info)
% function M_of_ty = get_SOD_MassMatrix(sys_info)

% (C) M. Zhong

% M_of_ty         = eye(sys_info.N * sys_info.d);
% ind             = (1 : sys_info.N) * sys_info.d;
% M_of_ty(ind, :) = 0;
M_of_ty         = eye(sys_info.N * sys_info.d);
M_of_ty(end, :) = 0;
end