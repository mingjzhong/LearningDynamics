function limitCycles = get_limit_cycles(traj, dtraj, total_energy, sys_info)
% function limitCycles = get_limit_cycles(traj, dtraj,  total_energy, sys_info)

% (C) M. Zhong

N                             = sys_info.N; 
d                             = sys_info.d;
switch sys_info.LC_type
  case 'Clustering'
    x                         = reshape(traj(1 : N * d), [d, N]);
    rij                       = sqrt(abs(sqdist_mod(x)));
    clusters                  = cell(1, N);
    agents                    = 1 : N;
    for ind = 1 : N
      agent_ind               = agents(1);                                                          % only the first one in the left-over list of agents
      ri                      = rij(agent_ind, :);
      clusters{ind}.agents    = find(ri == 0);
      clusters{ind}.loc       = x(:, agent_ind);
      agents                  = setdiff(agents, clusters{ind}.agents);
      if isempty(agents), break; end
    end
    limitCycles.num_clusters  = ind;
    limitCycles.cluster_info  = clusters(1 : ind);
    if isfield(sys_info, 'LC_subtype') && ~isempty(sys_info.LC_subtype) && strcmp(sys_info.LC_subtype, 'Consensus')
      if ind == 1
        limitCycles.emergence = true;
      else
        limitCycles.emergence = false;
      end
    else
      if ind < N
        limitCycles.emergence = true;
      else
        limitCycles.emergence = false;
      end
    end
  case 'Flocking'
    if sys_info.ode_order == 1
      v                       = reshape(dtraj(1 : N * d), [d, N]);
    elseif sys_info.ode_order == 2
      v                       = reshape(traj(N * d + 1 : 2 * N * d), [d, N]);
    end
    [I_flock, v_CM]           = get_flocking_info(v, sys_info);
    limitCycles.I_flock       = I_flock;
    limitCycles.v_bar         = v_CM;
    if I_flock < 0.1, limitCycles.emergence = true; else, limitCycles.emergence = false; end
  case 'Milling'
    x                         = reshape(traj(1 : N * d), [d, N]);
    v                         = reshape(traj(N * d + 1 : 2 * N * d), [d, N]);
    dv                        = reshape(dtraj(N * d + 1 : 2 * N * d), [d, N]);
    [I_flock, I_mill]         = get_flocking_and_milling_scores(x, v, dv, sys_info);
    limitCycles.I_s_vec       = [I_flock, I_mill];
    limitCycles.I_s           = limitCycles.I_s_vec(1) - limitCycles.I_s_vec(2);
    if limitCycles.I_s < -0.5, limitCycles.emergence = true; else, limitCycles.emergence = false; end
  case 'Synchronization'
    if sys_info.d ~= 2, error(''); end
    x                         = reshape(traj(1 : N * d), [d, N]);
    xi                        = traj(N * d + 1 : N * d + N)';
    xi                        = mod(xi + pi, 2 * pi) - pi;
    S_target                  = sys_info.LC_S_score;
    if isempty(S_target)
      error('SOD_Utils:get_limit_cycles:exception', ['S-test in Synchronization Oscillator ' ...
        'Dynamics can only be done on static states (sync, async, phase wave)!!']);
    else
      if S_target == -1
        limitCycles.S_vec    = zeros(1, 2);
        limitCycles.S_vec(2) = mean(xi);
        limitCycles.S_vec(1) = var(limitCycles.S_vec(2));
        if limitCycles.S_vec(1) < 0.01, limitCycles.S = -1; else, limitCycles.S = 0; end
      else
        theta                = atan2d(x(2, :), x(1, :));
        S_plus               = 1/N * abs(sum(exp(1i * (theta + xi))));
        S_minus              = 1/N * abs(sum(exp(1i * (theta - xi))));
        limitCycles.S_vec    = [S_plus, S_minus];
        limitCycles.S        = max(limitCycles.S_vec);        
      end
    end    
    if abs(S_target - limitCycles.S) < 0.01, limitCycles.emergence = true; else, limitCycles.emergence = false; end
  case 'Concentric'
    [limitCycles.energy_bar, limitCycles.energy_var] = calculate_energy_statistics(total_energy);
    if norm(limitCycles.energy_var, Inf) < 0.01, limitCycles.emergence = true; else, limitCycles.emergence = false; end
  otherwise
    error('SOD_Utils:compare_limit_cycles:exception', ...
      ['The following types of Limit Cycles are supported: Clustering, Flocking, Milling, ' ...
      'Synchronization, and Concentric!!']);
end
end