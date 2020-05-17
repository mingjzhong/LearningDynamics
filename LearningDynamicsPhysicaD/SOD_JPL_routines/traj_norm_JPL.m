function sup_err = traj_norm_JPL(traj1, traj2, sys_info)
% function sup_err = traj_norm_JPL(traj1, traj2, sys_info)

% (C) M. Zhong

oneBlock      = sys_info.N * sys_info.d;
x1            = traj1(1 : oneBlock, :);
v1            = traj1((oneBlock + 1) : (2 * oneBlock), :);
x2            = traj2(1 : oneBlock, :);
v2            = traj2((oneBlock + 1) : (2 * oneBlock), :);
sup_err       = zeros(sys_info.N, 2);
sup_err(:, 1) = compare_traj_agent_wise_JPL(x1, x2, sys_info.N, sys_info.d);
sup_err(:, 2) = compare_traj_agent_wise_JPL(v1, v2, sys_info.N, sys_info.d);
end