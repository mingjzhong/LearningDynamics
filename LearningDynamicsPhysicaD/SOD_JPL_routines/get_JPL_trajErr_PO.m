function trajErr = get_JPL_trajErr_PO(x, v, syshat_info, solver_info, time_vec)
% function trajErr = get_JPL_trajErr_PO(x, v, syshat_info, solver_info, time_vec)

% (C) M. Zhong

M               = size(x, 3);
ICs             = [squeeze(x(:, 1, :)); squeeze(v(:, 1, :))];
trajs           = [x; v];
trajErr         = zeros(2, M); 
agent_info      = getAgentInfo(syshat_info);
parfor m = 1 : M
  dynamicshat   = self_organized_dynamics(ICs(:, m), syshat_info, solver_info);
  trajhat       = dense_output(dynamicshat, time_vec);
  trajErr(:, m) = traj_norm(squeeze(trajs(:, :, m)), trajhat, syshat_info, agent_info);
end
trajErr         = mean(trajErr, 2);
end