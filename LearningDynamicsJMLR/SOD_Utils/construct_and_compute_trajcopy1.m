function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, y_init, T_L, L)
% function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, T_L, L)

% (c) M. Zhong

done                = false;
while ~done
    dynamics          = self_organized_dynamics(y_init, sys_info, solver_info);
    if ~dynamics.flag, done = true; end
end
done                = false;

time_vec            = linspace(0.001, solver_info.time_span(2), L);
time_vec            = insert_time_vec(time_vec, T_L);
traj                = deval(dynamics,    time_vec);

while ~done
    dynamicshat       = self_organized_dynamics(traj(:,1), syshat_info, solver_info);
    if ~dynamicshat.flag, done = true; end
end

trajhat             = deval(dynamicshat, time_vec-0.001);
result.traj_true    = traj(1 : sys_info.d * sys_info.N,    :);
result.traj_hat     = trajhat(1 : sys_info.d * sys_info.N, :);
result.time_vec     = time_vec;
% compute the trajectory error for this random pick from training data
time_vec            = linspace(0.001, T_L, L);
traj                = deval(dynamics,    time_vec);
trajhat             = deval(dynamicshat, time_vec-0.001);
result.trajErr      = traj_norm(traj(:, :), trajhat(:, :), 'Time-Maxed', sys_info);
time_vec            = linspace(T_L, solver_info.time_span(2), L);
traj                = deval(dynamics,    time_vec);
trajhat             = deval(dynamicshat, time_vec-0.001);
result.trajErrfut   = traj_norm(traj(:, :), trajhat(:, :), 'Time-Maxed', sys_info);

return