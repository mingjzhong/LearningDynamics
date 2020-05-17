function [trajs, dtrajs, trajErr, dynamicshat] = get_JPL_trajErr(obs_data, sys_info, solver_info, ...
          syshat_info, num_years, total_num_years, dynamics_type)
% function [trajs, dtrajs, trajErr, dynamicshat] = get_JPL_trajErr(obs_data, sys_info, solver_info, ...
%           syshat_info, num_years, total_num_years, dynamics_type)

% (C) M. Zhong

trajs              = cell(1, 2);
dtrajs             = cell(1, 2);
multiple           = floor(total_num_years/100);
test_years         = (1 : multiple) * 100;
test_years         = union(test_years, [num_years, total_num_years]);
block              = sys_info.N * sys_info.d;
trajfut            = obs_data.y_fut;
if ~isfield(obs_data, 'is_Einstein') || isempty(obs_data.is_Einstein) || ~obs_data.is_Einstein
  dynamicshat      = self_organized_dynamics(obs_data.ICs, syshat_info, solver_info);
else
  dynamicshat      = ode15i(obs_data.odefun, solver_info.time_span, obs_data.ICs, obs_data.yp0, ...
                     obs_data.ode_opts);
end
trajfuthat         = dense_output(dynamicshat, obs_data.day_vec_fut);
trajs{1}           = trajfut(1 : block, :);
dtrajs{1}          = trajfut(block + 1 : 2 * block, :);
trajs{2}           = trajfuthat(1 : block,             :);
dtrajs{2}          = trajfuthat(block + 1 : 2 * block, :);
agent_info         = getAgentInfo(sys_info);
fprintf('\nTrajectory Errors using %s:', dynamics_type);
for idx = 1 : length(test_years)
  day_vec          = get_time_vec_from_years(test_years(idx));
  traj             = trajfut(:,    day_vec + 1);
  trajhat          = trajfuthat(:, day_vec + 1);    
  errSup           = traj_norm(traj,     trajhat, sys_info, agent_info);
  errSup_JPL       = traj_norm_JPL(traj, trajhat, sys_info);
  fprintf('\nResults over %3d years.', test_years(idx));
  fprintf('\n\tTraj. Err. on x is: %10.4e.', errSup(1));
  fprintf('\n\tTraj. Err. on v is: %10.4e.', errSup(2));
  for N_idx = 1 : sys_info.N
    fprintf('\n\tFor %8s:', sys_info.AO_names{N_idx});
    fprintf('\n\tTraj. Err. on x is: %10.4e.', errSup_JPL(N_idx, 1));
    fprintf('\n\tTraj. Err. on v is: %10.4e.', errSup_JPL(N_idx, 2));   
  end
  if test_years(idx) == num_years
    trajErr.sup    = errSup;
  end
  if test_years(idx) == total_num_years
    trajErr.supfut = errSup;
  end
end
end