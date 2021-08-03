function Example = LennardJonesDynamicsTruncatedonPD_LDoM_def()
% function Example = LennardJonesDynamicsTruncatedonPD_LDoM_def()
% Define associated terms for truncated Lennard Jones DYNAMICs on Poincare Disk

% System
sys_info.name                = 'LennardJonesDynamicsTruncatedonPD';                                 % name of the dynamics
sys_info.d                   = 2;                                                                   % dimension for the state vector (in this case, opinion vector)
sys_info.N                   = 20;                                                                  % # of agents
sys_info.epsilon             = 10;                                                                  % depth of the potential well
sys_info.r_m                 = 1;                                                                   % distance at which the potential reaches its mininum
sys_info.IR                  = Inf;
sys_info.phiE                = {@(r) LJ_C1truncated_phiE(r, sys_info.epsilon, sys_info.r_m, ...
                                sys_info.IR)};                                                      % energy based influence
sys_info.K                   = 1;                                                                   % # of types
sys_info.ode_order           = 1;                                                                   % order of the ODE system
sys_info.type_info           = ones(1, sys_info.N);                                                 % function mapping agent index to its type index
sys_info.has_noise           = false;                                                               % no stochastic noise
sys_info.manifold_type       = 'PD';
sys_info.T_f                 = 1e-3;                                                                % final time the system will reach steady state
sys_info.on_manifold         = true;
sys_info.g_type              = sys_info.manifold_type;
sys_info.gx                  = @(x) riemannian_metric_on_poincare_disk(x, sys_info.d);
sys_info.level_set           = @(y) hyperbolic_level_set(y);
sys_info.level_grad          = @(y) hyperbolic_level_gradient(y);
sys_info.geodesic_dist       = @(xi, xj) geodesic_distance_on_poincare_disk(xi, xj, sys_info.d);
sys_info.geodesic_dist_mat   = @(x, xhat) geodesic_distance_on_poincare_disk_mat(x, xhat, sys_info.d);
sys_info.manifold_projection = @(y) y;
sys_info.weight_on_manifold  = @(y) geodesic_direction_on_poincare_disk(y, y, sys_info.d);
sys_info.mu0                 = @() poincare_disk_init_config(sys_info.d, sys_info.N);          % distribution of initial conditions

% ODE solver
solver_info.time_span        = [0, sys_info.T_f];                                                   % put it into the time_span vector, always starting from 0
solver_info.is_uniform       = true;
solver_info.order            = 4;
solver_info.multi_step       = true;
solver_info.h                = 1e-6;
solver_info.solver           = 'GNI';

% Observations
obs_info.L                   = 500;                                                                 % observe (equi-spaced) times
obs_info.M                   = 500;                                                                 % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT              = 3000;                                                                % # trajectories with random initial conditions to compute approximate \rho^L_T
obs_info.T_0                 = 0;                                                                   % Observation time interval [T_0, T]
obs_info.T                   = sys_info.T_f;                                                        % Observation time interval [T_0, T]
obs_info.time_vec            = linspace(obs_info.T_0, obs_info.T, obs_info.L);                      % time instances at which discrete observation is made
obs_info.use_derivative      = true;                                                                % indicator of the availability of derivative data
obs_info.hist_num_bins       = 1000;                                                                % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise           = 0;
obs_info.mu_trajnoise        = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.mu_dtrajnoise       = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );

% Learning
degree                       = 1;
type                         = {'B-spline'};
sub_type                     = {'Clamped'};
learn_info.Ebasis_info       = construct_basis_info(sys_info, obs_info, degree, type, sub_type);     % save the information on constructing basis for energy based functions                                                      
learn_info.hist_num_bins     = obs_info.hist_num_bins;

% package the data
Example.sys_info             = sys_info;
Example.solver_info          = solver_info;
Example.obs_info             = obs_info;
Example.learn_info           = learn_info;
end