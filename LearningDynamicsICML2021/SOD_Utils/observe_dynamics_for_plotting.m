function output = observe_dynamics_for_plotting(y_init, sys_info, syshat_info, solver_info, time_vec)
% function output = observe_dynamics_for_plotting(y_init, sys_info, syshat_info, solver_info, time_vec)

% (C) M. Zhong (JHU)

dynamics            = self_organized_dynamics(y_init, sys_info,    solver_info);
dynamicshat         = self_organized_dynamics(y_init, syshat_info, solver_info);
[traj, dtraj]       = dense_output(dynamics,    time_vec);
[trajhat, dtrajhat] = dense_output(dynamicshat, time_vec);
output.traj         = traj;
output.dtraj        = dtraj;
output.trajhat      = trajhat;
output.dtrajhat     = dtrajhat;
end