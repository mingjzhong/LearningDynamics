function result = compare_limit_cycles(LimitCycles, LimitCycleshat, sys_info)
% function result = compare_limit_cycles(LimitCycles, LimitCycleshat, sys_info)

% (C) M. Zhong (JHU)
result.cMatrix       = compute_confusion_matrix(LimitCycles.emergence, LimitCycleshat.emergence);
scores               = zeros(2, 1);
switch sys_info.LC_type
  case 'Clustering'
    if LimitCycleshat.num_clusters == LimitCycles.num_clusters
      scores(1)      = 1;
    else
      scores(1)      = 0;
    end
    X                = zeros(LimitCycles.num_clusters, sys_info.d);
    Xhat             = zeros(LimitCycleshat.num_clusters, sys_info.d);
    for ind = 1 : LimitCycles.num_clusters
      X(ind, :)      = LimitCycles.cluster_info{ind}.loc;
    end
    for ind = 1 : LimitCycleshat.num_clusters
      Xhat(ind, :)   = LimitCycleshat.cluster_info{ind}.loc;
    end    
    X_hdist          = calculate_Hausdorff_distance(X, zeros(size(X)));
    if X_hdist == 0, scores(2) = calculate_Hausdorff_distance(X, Xhat);
    else, scores(2) = calculate_Hausdorff_distance(X, Xhat)/X_hdist; end
  case 'Flocking'
    if LimitCycles.I_flock == 0, scores(1) = abs(LimitCycles.I_flock - LimitCycleshat.I_flock); 
    else, scores(1) = abs(LimitCycles.I_flock - LimitCycleshat.I_flock)/abs(LimitCycles.I_flock); end
    v_bar_norm       = norm(LimitCycles.v_bar);
    if v_bar_norm == 0, scores(2) = norm(LimitCycles.v_bar - LimitCycleshat.v_bar);
    else, scores(2) = norm(LimitCycles.v_bar - LimitCycleshat.v_bar)/v_bar_norm; end
  case 'Milling'
    if LimitCycles.I_s == 0, scores(1) = abs(LimitCycles.I_s - LimitCycleshat.I_s);
    else, scores(1) = abs(LimitCycles.I_s - LimitCycleshat.I_s)/abs(LimitCycles.I_s); end
    I_norm = norm(LimitCycles.I_s_vec);
    if I_norm == 0
      scores(2)      = norm(LimitCycles.I_s_vec - LimitCycleshat.I_s_vec); 
    else
      scores(2)      = norm(LimitCycles.I_s_vec - LimitCycleshat.I_s_vec)/I_norm; 
    end
  case 'Synchronization'
    if isempty(sys_info.LC_S_score)
      error('SOD_Utils:get_limit_cycles:exception', ['S-test in Synchronization Oscillator ' ...
        'Dynamics can only be done on static states (sync, async, phase wave)!!']);
    else
      if sys_info.LC_S_score == -1
        for idx = 1 : 2
          if LimitCycles.S_vec(idx) == 0, scores(idx) = abs(LimitCycles.S_vec(idx) - LimitCycleshat.S_vec(idx));
          else, scores(idx) = abs(LimitCycles.S_vec(idx) - LimitCycleshat.S_vec(idx))/abs(LimitCycles.S_vec(idx)); end
        end
      else
        if LimitCycles.S == 0, scores(1) = abs(LimitCycles.S - LimitCycleshat.S);
        else, scores(1) = abs(LimitCycles.S - LimitCycleshat.S)/abs(LimitCycles.S); end
        S_vec_norm       = norm(LimitCycles.S_vec);
        if S_vec_norm == 0, scores(2) = norm(LimitCycles.S_vec - LimitCycleshat.S_vec);
        else, scores(2) = norm(LimitCycles.S_vec - LimitCycleshat.S_vec)/S_vec_norm; end      
      end
    end   
  case 'Concentric'
    e_var_norm       = norm(LimitCycles.energy_var, Inf);
    if e_var_norm == 0, scores(1) = norm(LimitCycles.energy_var - LimitCycleshat.energy_var, Inf);
    else, scores(1) = norm(LimitCycles.energy_var - LimitCycleshat.energy_var, Inf)/e_var_norm; end
    e_bar_norm       = norm(LimitCycles.energy_bar, Inf);
    if e_bar_norm == 0, scores(2) = norm(LimitCycles.energy_bar - LimitCycleshat.energy_bar, Inf);
    else, scores(2) = norm(LimitCycles.energy_bar - LimitCycleshat.energy_bar, Inf)/e_bar_norm; end
  otherwise
    error('SOD_Utils:compare_limit_cycles:exception', ...
      ['The following types of Limit Cycles are supported: Clustering, Flocking, Milling, ' ...
      'Synchronization, and Concentric!!']);
end
result.scores        = scores;
end