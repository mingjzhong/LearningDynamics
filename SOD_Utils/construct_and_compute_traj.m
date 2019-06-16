function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, ICs, T_L, L)
% function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, T_L, L)

% (c) M. Zhong

for m = 1 : size(ICs, 2)
  y_init           = ICs(:, m);
  dynamics         = self_organized_dynamics(y_init, sys_info, solver_info);
  dynamicshat      = self_organized_dynamics(y_init, syshat_info, solver_info);
  if ~dynamics.flag && ~dynamicshat.flag, break; end
end
c                  = floor(solver_info.time_span(2)/T_L);
time_vec           = linspace(solver_info.time_span(1), solver_info.time_span(2), c * L - c + 1);
time_vec           = insert_time_vec(time_vec, T_L);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec);
result.traj_true   = traj(1 : sys_info.d * sys_info.N,    :);
result.traj_hat    = trajhat(1 : sys_info.d * sys_info.N, :);
result.time_vec    = time_vec;
% compute the trajectory error for this random pick from training data
time_vec           = linspace(0, T_L, L);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec);
result.trajErr     = traj_norm(traj, trajhat, 'Time-Maxed', sys_info);
time_vec           = linspace(T_L, solver_info.time_span(2), L);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec);
result.trajErrfut  = traj_norm(traj, trajhat, 'Time-Maxed', sys_info);
result.m           = m;
result.dynamics    = dynamics;
result.dynamicshat = dynamicshat;
end