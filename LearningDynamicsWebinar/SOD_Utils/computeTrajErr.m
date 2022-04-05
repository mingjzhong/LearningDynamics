function trajErr = computeTrajErr(y, sys_info, syshat_info, solver_info, obs_info, find_LC)
% function trajErr = computeTrajErr_serial(y, sys_info, syshat_info, solver_info, obs_info, find_LC)
%
% IN: the usual structure containing the system, estimated system and observations, plus a
%       sys_info.d*sys_info.N by M set of initial conditions in y_init
% OUT:
%   trajErr     : structure with the following fields:
%       sup     : sup distance on [0,obs_info.T_L]
%       supFut  : sup distance on [obs_info.T_L,solver_info.time_span(2)]

% (c) M. Zhong

Timings.trajErr                   = tic;
if length(size(y)) == 2
  M                               = size(y, 2);
  y_init                          = y;
% reshape y so that it can be partitioned by parfor (size issue)
  y                               = reshape(y, [size(y, 1), 1, M]);
  has_traj_data                   = false;
else
  M                               = size(y, 3);
  y_init                          = squeeze(y(:, 1, :));  
  if solver_info.time_span(2) > obs_info.T
    has_traj_data                 = false;
    y                             = reshape(y_init, [size(y, 1), 1, M]);
  else
    has_traj_data                 = true;  
  end
end
agent_info                        = getAgentInfo(sys_info);
time_vec                          = obs_info.time_vec;
if solver_info.time_span(2) > obs_info.T
  time_vec_fut                    = linspace(obs_info.T, solver_info.time_span(2), obs_info.L);
  need_dynamics                   = true;
  if solver_info.time_span(2) >= 3 * obs_info.T
    T_mid                         = 2 * obs_info.T;
  else
    T_mid                         = (solver_info.time_span(2) + obs_info.T)/2;
  end  
  time_vec_mid                    = linspace(obs_info.T, T_mid, obs_info.L);
elseif solver_info.time_span(2) == obs_info.T
  time_vec_fut                    = []; 
  time_vec_mid                    = [];
  if has_traj_data
    need_dynamics                 = false;
  else
    need_dynamics                 = true;
  end
else
  error('');
end
% Generate true trajectories        
sys_var_len                       = calculate_sys_var_len(sys_info);
num_states                        = calculate_sys_states(sys_info);
sup_err                           = zeros(num_states, M);
if ~isempty(time_vec_fut)
  sup_err_fut                     = zeros(num_states, M);
  sup_err_mid                     = zeros(num_states, M); 
else
  sup_err_fut                     = [];
  sup_err_mid                     = [];   
end
if find_LC
  if ~strcmp(sys_info.LC_type, 'Concentric')
    traj_T_f                      = zeros(sys_var_len, M);
    dtraj_T_f                     = zeros(sys_var_len, M);
    trajhat_T_f                   = zeros(sys_var_len, M);
    dtrajhat_T_f                  = zeros(sys_var_len, M);
  else
    total_E                       = zeros(sys_info.N - 1, obs_info.L, M);
    total_Ehat                    = zeros(sys_info.N - 1, obs_info.L, M);
  end
end
failtraj                          = zeros(1, M, 'logical');   
failtrajhat                       = zeros(1, M, 'logical');  
if obs_info.VERBOSE > 1,   fprintf('\nGenerating %d trajectories for testing...', M); end
parfor m = 1 : M
  dynamics                        = [];
  if need_dynamics
    dynamics                      = self_organized_dynamics(y_init(:, m), sys_info, solver_info);   % run the simulation from m-th initial condition used in training
    failtraj(m)                   = dynamics.flag;
  else
    failtraj(m)                   = false;
    dynamics.flag                 = false;     
  end
  if ~dynamics.flag
    if ~has_traj_data
      traj                        = dense_output(dynamics, time_vec);                               % observe the traj. L equispaced times from T_0 to T
      if ~isempty(time_vec_mid)
        trajmid                   = dense_output(dynamics, time_vec_mid);                           % observe the traj. L equispaced times from T   to T_m
      else
        trajmid                   = [];
      end
    else
      traj                        = y(:, :, m);
      trajmid                     = [];
    end
    dtrajfut                      = [];
    if find_LC
      [trajfut, dtrajfut]         = dense_output(dynamics, time_vec_fut);                           % observe the traj. L equispaced times from T   to T_f    
    else
      if ~isempty(time_vec_fut)
        trajfut                   = dense_output(dynamics, time_vec_fut);
      else 
        trajfut                   = [];
      end
    end
    dynamicshat                   = self_organized_dynamics(y_init(:, m), syshat_info, solver_info);% run the simulation from m-th initial condition used in training  
    failtrajhat(m)                = dynamicshat.flag;
    if ~dynamicshat.flag
      trajhat                     = dense_output(dynamicshat, time_vec);
      if ~isempty(time_vec_mid)
        trajmidhat                = dense_output(dynamicshat, time_vec_mid);
      else
        trajmidhat                = [];
      end
      dtrajfuthat                 = [];
      if find_LC
        [trajfuthat, dtrajfuthat] = dense_output(dynamicshat, time_vec_fut);
      else
        if ~isempty(time_vec_fut)
          trajfuthat              = dense_output(dynamicshat, time_vec_fut);
        else
          trajfuthat              = [];
        end
      end
      sup_err(:, m)               = traj_norm(traj,    trajhat,    sys_info, agent_info);
      if ~isempty(time_vec_mid)
        sup_err_mid(:, m)         = traj_norm(trajmid, trajmidhat, sys_info, agent_info);
      end
      if ~isempty(time_vec_fut)
        sup_err_fut(:, m)         = traj_norm(trajfut, trajfuthat, sys_info, agent_info);
      end
      if find_LC
        if ~strcmp(sys_info.LC_type, 'Concentric')
          traj_T_f(:, m)          = trajfut(:, end);
          dtraj_T_f(:, m)         = dtrajfut(:, end);
          trajhat_T_f(:, m)       = trajfuthat(:, end);
          dtrajhat_T_f(:, m)      = dtrajfuthat(:, end);
        else
          total_E(:, :, m)        = calculate_energy(trajfut,    sys_info);
          total_Ehat(:, :, m)     = calculate_energy(trajfuthat, syshat_info);
        end
      end
    end
  end
end
fail_idxs                         = (failtraj | failtrajhat);
if obs_info.VERBOSE > 1 && sum(fail_idxs) > 0
  fprintf('\n\t Failed simulations with original  system: %d/%d', sum(failtraj),               M);
  fprintf('\n\t Failed simulations with estimated system: %d/%d', sum(failtrajhat),            M);
  fprintf('\n\t Common failures = %d / Total failures = %d',      sum(failtraj & failtrajhat), sum(fail_idxs));
end   
sup_err(:,     fail_idxs)         = [];
if ~isempty(time_vec_fut)
  sup_err_mid(:, fail_idxs)       = [];
  sup_err_fut(:, fail_idxs)       = [];
end
y_init(:,      fail_idxs)         = [];
trajErr.sup                       = sup_err;
trajErr.sup_mid                   = sup_err_mid;
trajErr.sup_fut                   = sup_err_fut;
trajErr.time_vec                  = time_vec;
trajErr.time_vec_mid              = time_vec_mid;
trajErr.time_vec_fut              = time_vec_fut;
trajErr.y_init                    = y_init;
if find_LC
  if ~strcmp(sys_info.LC_type, 'Concentric')
    traj_T_f(:,     fail_idxs)    = [];
    dtraj_T_f(:,    fail_idxs)    = [];
    trajhat_T_f(:,  fail_idxs)    = [];
    dtrajhat_T_f(:, fail_idxs)    = [];
    trajErr.traj_T_f              = traj_T_f;
    trajErr.dtraj_T_f             = dtraj_T_f;
    trajErr.trajhat_T_f           = trajhat_T_f;
    trajErr.dtrajhat_T_f          = dtrajhat_T_f;
  else
    total_E(:,    :, fail_idxs)   = [];
    total_Ehat(:, :, fail_idxs)   = [];
    trajErr.total_energy          = total_E;
    trajErr.total_energyhat       = total_Ehat;
  end
end
trajErr.Timings.trajErr           = toc(Timings.trajErr);
end