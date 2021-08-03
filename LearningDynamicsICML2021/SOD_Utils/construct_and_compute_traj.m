function result = construct_and_compute_traj(trajErr, sys_info, syshat_info, plot_info)
% function result = construct_and_compute_traj(trajErr, sys_info, plot_info)

% (c) M. Zhong

time_vec             = linspace(plot_info.solver_info.time_span(1), plot_info.solver_info.time_span(2), ...
                       plot_info.traj_L);
time_vec             = insert_time_vec(time_vec, trajErr.time_vec(end));
m                    = randi(size(trajErr.y_init, 2));
output               = observe_dynamics_for_plotting(trajErr.y_init(:, m), sys_info, syshat_info, ...
                       plot_info.solver_info, time_vec);
block_size           = sys_info.d * sys_info.N;
result.traj_true     = output.traj(1    : block_size, :);
result.traj_hat      = output.trajhat(1 : block_size, :);
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  if sys_info.ode_order == 1
    result.xi_true   = output.traj(block_size + 1    : block_size + sys_info.N, :);
    result.xi_hat    = output.trajhat(block_size + 1 : block_size + sys_info.N, :);
    if strcmp(sys_info.name, 'SynchronizedOscillatorDynamics')
      result.xi_true = mod(result.xi_true + pi, 2 * pi) - pi;
      result.xi_hat  = mod(result.xi_hat  + pi, 2 * pi) - pi;
    end
  elseif sys_info.ode_order == 2
    result.xi_true   = output.traj(2 * block_size + 1    : 2 * block_size + sys_info.N, :);
    result.xi_hat    = output.trajhat(2 * block_size + 1 : 2 * block_size + sys_info.N, :);
  end
end
result.time_vec      = time_vec;
% find out the velocity information for creating animation
if sys_info.ode_order == 2
  result.dtraj_true  = output.traj(block_size + 1    : 2 * block_size, :);
  result.dtraj_hat   = output.trajhat(block_size + 1 : 2 * block_size, :);
else 
  result.dtraj_true  = output.dtraj(1    : block_size, :);
  result.dtraj_hat   = output.dtrajhat(1 : block_size, :);
end
end