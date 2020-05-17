function IndicErr = get_JPL_PO_indicator_error(solver_info, sys_info, time_vec, traj, phihats)
% function IndicErr = get_JPL_PO_indicator_error(solver_info, sys_info, time_vec, traj, phihats)

% (C) M. Zhong

syshat_info           = sys_info;
syshat_info.phiE      = phihats;
solver_info.time_span = [time_vec(1), time_vec(end)];
dynamicshat           = self_organized_dynamics(traj(:, 1), syshat_info, solver_info);
trajhat               = dense_output(dynamicshat, time_vec);
x                     = traj(1    : sys_info.N * sys_info.d, :);
xhat                  = trajhat(1 : sys_info.N * sys_info.d, :);
diff_norm             = zeros(sys_info.N, size(x, 2));
for idx = 1 : sys_info.N
  ind1                = (idx - 1) * sys_info.d + 1;
  ind2                = idx * sys_info.d;
  diff_norm(idx, :)   = sum((x(ind1 : ind2, :) - xhat(ind1 : ind2, :)).^2).^(0.5);
end
max_diff_norm         = max(diff_norm, [], 2);
[~, IndicErr]         = max(max_diff_norm);
end