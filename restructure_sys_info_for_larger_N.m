function sys_info = restructure_sys_info_for_larger_N(N_ratio, sys_info)

% function result = restructure_sys_info_for_larger_N( sys_info )

% (c) M. Zhong

switch sys_info.name
    case 'OpinionDynamicsCont'
        sys_info.N          = sys_info.N * N_ratio;
        sys_info.type_info  = ones(1, sys_info.N);
        sys_info.mu0        = @() OD_init_config(sys_info.d, sys_info.N, 1);
    case 'OpinionDynamicsDisc'
        sys_info.N          = sys_info.N * N_ratio;
        sys_info.type_info  = ones(1, sys_info.N);
        sys_info.mu0        = @() OD_init_config(sys_info.d, sys_info.N, 1);
    case 'LennardJonesDynamics'
        sys_info.N          = sys_info.N * N_ratio;
        sys_info.type_info  = ones(1, sys_info.N);
        sys_info.mu0        = @() LJ_init_config([], sys_info.d, sys_info.N, 2);
    case 'LennardJonesDynamicsTruncated'
        sys_info.N          = sys_info.N * N_ratio;
        sys_info.type_info  = ones(1, sys_info.N);
        sys_info.mu0        = @() LJ_init_config([], sys_info.d, sys_info.N, 2);
    case 'PredatorPrey1stOrderSplines'
        N                   = sys_info.N * N_ratio;
        N_predators         = 1;
        N_preys             = N - N_predators;
        sys_info.N          = N;
        sys_info.type_info  = [ones(1, N_preys), 2 * ones(1,N_predators)];
        sys_info.mu0        = @() PS_init_config(sys_info.N, sys_info.type_info, 1);      
    case 'PredatorPrey1stOrder'
        N                   = sys_info.N * N_ratio;
        N_predators         = 1;
        N_preys             = N - N_predators;
        sys_info.N          = N;
        sys_info.type_info  = [ones(1, N_preys), 2 * ones(1,N_predators)];
        sys_info.mu0        = @() PS_init_config(sys_info.N, sys_info.type_info, 1);
    case 'PredatorPrey2ndOrder'
        N                   = sys_info.N * N_ratio;
        N_predators         = 1;
        N_preys             = N - N_predators;
        sys_info.N          = N;
        sys_info.type_info  = [ones(1, N_preys), 2 * ones(1,N_predators)];
        sys_info.mu0        = @() PS_init_config(sys_info.N, sys_info.type_info, 2);
        sys_info.agent_mass = ones(N, 1);
        sys_info.Fv         = @(v, xi) PS_2nd_order_friction(v, [1; 1], 2, sys_info.type_info);
    case 'PhototaxisDynamics'
        sys_info.N          = sys_info.N * N_ratio;
        sys_info.type_info  = ones(1, sys_info.N);
        sys_info.mu0        = @() OD_init_config(sys_info.d, sys_info.N, 1);
        sys_info.agent_mass = ones(sys_info.N, 1);
        sys_info.kappa      = sys_info.N;
        sys_info.kappaXi    = sys_info.N;
        sys_info.mu0        = @() PT_init_condition(sys_info.d, sys_info.N, 100, 100, 0.001);
    otherwise
end

end