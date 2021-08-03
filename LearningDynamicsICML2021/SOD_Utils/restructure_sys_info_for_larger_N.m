function sys_info = restructure_sys_info_for_larger_N(N_ratio, sys_info)

% function result = restructure_sys_info_for_larger_N(N_ratio, sys_info)

% (c) M. Zhong

if contains(sys_info.name, 'OpinionDynamics')
  sys_info.N          = sys_info.N * N_ratio;
  sys_info.type_info  = ones(1, sys_info.N);
  if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold)
    switch sys_info.manifold_type
      case 'S2'
        sys_info.manifold_projection ...
                      = @(y) projection_on_to_sphere(y, sys_info.d, sys_info.N, sys_info.R);
        sys_info.mu0  = @() sphere_init_config(sys_info.d, sys_info.N, sys_info.R);
      case 'PD'
        sys_info.mu0  = @() poincare_disk_init_config(sys_info.d, sys_info.N); 
      case 'H2'
      otherwise
        error('');
    end
  else
    sys_info.mu0      = @() OD_init_config(sys_info.d, sys_info.N, 1); 
  end
elseif contains(sys_info.name, 'LennardJonesDynamics')
  sys_info.N          = sys_info.N * N_ratio;
  sys_info.type_info  = ones(1, sys_info.N);
  if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold)
    switch sys_info.manifold_type
      case 'S2'
        sys_info.manifold_projection ...
                      = @(y) projection_on_to_sphere(y, sys_info.d, sys_info.N, sys_info.R);
        sys_info.mu0  = @() sphere_init_config(sys_info.d, sys_info.N, sys_info.R);
      case 'PD'
        sys_info.mu0  = @() poincare_disk_init_config(sys_info.d, sys_info.N); 
      case 'H2'
      otherwise
        error('');
    end
  else
    sys_info.mu0      = @() LJ_init_config([], sys_info.d, sys_info.N, 2);
  end
elseif contains(sys_info.name, 'PredatorPrey1stOrder')
  N                   = sys_info.N * N_ratio;
  N_predators         = 1;
  N_preys             = N - N_predators;
  sys_info.N          = N;
  sys_info.type_info  = [ones(1, N_preys), 2 * ones(1,N_predators)];
  if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold)
    switch sys_info.manifold_type
      case 'S2'
        sys_info.manifold_projection ...
                      = @(y) projection_on_to_sphere(y, sys_info.d, sys_info.N, sys_info.R);
        sys_info.mu0  = @() sphere_init_config(sys_info.d, sys_info.N, sys_info.R, 2);
      case 'PD'
        sys_info.mu0  = @() poincare_disk_init_config(sys_info.d, sys_info.N, 2); 
      case 'H2'
      otherwise
        error('');
    end
  else
    sys_info.mu0      = @() PS_init_config(sys_info.N, sys_info.type_info, 1);
  end  
elseif contains(sys_info.name, 'PredatorPrey2ndOrder')
  N                   = sys_info.N * N_ratio;
  N_predators         = 1;
  N_preys             = N - N_predators;
  sys_info.N          = N;
  sys_info.type_info  = [ones(1, N_preys), 2 * ones(1,N_predators)];
  sys_info.mu0        = @() PS_init_config(sys_info.N, sys_info.type_info, 2);
  sys_info.agent_mass = ones(N, 1);
  sys_info.Fv         = @(v, xi) PS_2nd_order_friction(v, [1; 1], 2, sys_info.type_info);  
elseif contains(sys_info.name, 'PhototaxisDynamics')
  sys_info.N          = sys_info.N * N_ratio;
  sys_info.type_info  = ones(1, sys_info.N);
  sys_info.mu0        = @() OD_init_config(sys_info.d, sys_info.N, 1);
  sys_info.agent_mass = ones(sys_info.N, 1);
  sys_info.mu0        = @() PT_init_condition(sys_info.d, sys_info.N, 100, 100, 0.001);  
end
end