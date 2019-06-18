function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, ICs, T_L, L)
% function result = construct_and_compute_traj(solver_info, sys_info, syshat_info, T_L, L)

% (c) M. Zhong
% add the parameters T_0 by S. Tang, T_0 is the starting time of the observation

if isfield(sys_info,'T_0')
    T_0=sys_info.T_0;
else
    T_0=0;
end


for m = 1 : size(ICs, 2)
  y_init           = ICs(:, m);
  dynamics         = self_organized_dynamics(y_init, sys_info, solver_info);
  dynamicshat      = self_organized_dynamics(deval(dynamics,T_0), syshat_info, solver_info);
  if ~dynamics.flag && ~dynamicshat.flag, break; end
end
c                  = floor(solver_info.time_span(2)/T_L);
time_vec           = linspace(T_0, solver_info.time_span(2), c * L - c + 1);
time_vec           = insert_time_vec(time_vec, T_L);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec-T_0);
result.traj_true   = traj(1 : sys_info.d * sys_info.N,    :);
result.traj_hat    = trajhat(1 : sys_info.d * sys_info.N, :);
result.time_vec    = time_vec;
% compute the trajectory error for this random pick from training data
time_vec           = linspace(T_0, T_L, L);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec-T_0);
result.trajErr     = traj_norm(traj, trajhat, 'Time-Maxed', sys_info);
time_vec           = linspace(T_L, solver_info.time_span(2), L);
traj               = deval(dynamics,    time_vec);
trajhat            = deval(dynamicshat, time_vec-T_0);
result.trajErrfut  = traj_norm(traj, trajhat, 'Time-Maxed', sys_info);
result.m           = m;
result.dynamics    = dynamics;
result.dynamicshat = dynamicshat;
end


