function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, obs_info, ICs)
% function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, obs_info, ICs)

% (c) M. Zhong

% choose from existing sets of stable Initial Conditions
for m = 1 : size(ICs, 2)
  y_init           = ICs(:, m);
  dynamics         = self_organized_dynamics(y_init, sys_info, solver_info);
  dynamicshat      = self_organized_dynamics(y_init, syshat_info, solver_info);
  if ~dynamics.flag && ~dynamicshat.flag, break; end
end
time_vec           = obs_info.time_vec(1) : obs_info.time_vec(2) - obs_info.time_vec(1) : solver_info.time_span(2);
time_vec           = insert_time_vec(time_vec, obs_info.T_L);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec);
result.traj_true   = traj(1 :    sys_info.d * sys_info.N, :);
result.traj_hat    = trajhat(1 : sys_info.d * sys_info.N, :);
result.time_vec    = time_vec;
% compute the trajectory error first from observed time instances
time_vec           = obs_info.time_vec;
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec);
result.trajErr     = traj_norm(traj, trajhat, 'Time-Maxed', sys_info);
% then compare the prediction time interval [T_L, T_f]
time_vec           = obs_info.T_L : obs_info.time_vec(2) - obs_info.time_vec(1) : solver_info.time_span(2);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec);
result.trajErrfut  = traj_norm(traj, trajhat, 'Time-Maxed', sys_info);
result.m           = m;                                                                             
result.dynamics    = dynamics;
result.dynamicshat = dynamicshat;
end


