function Example = PredatorPrey1stOrderonS2_LDoM_def()
% function Example = PredatorPrey1stOrderonS2_LDoM_def()
% Define associated terms for PREDATOR-PREY 1st ORDER on S^2

% System
sys_info.name                = 'PredatorPrey1stOrderonS2';
N_preys                      = 19;                                                                  % number of preys and single predator
N_predators                  = 1;
sys_info.d                   = 3;                                                                   % the dimension for the position/velocity vecor
sys_info.N                   = N_preys + N_predators;                                               % the number of agents
sys_info.R                   = 5/pi;                                                                % radius of S^1/S^2
sys_info.IR                  = sys_info.R * pi;
sys_info.r_cut               = 0.01;
sys_info.phiE{1,1}           = @(r) PS1_prey_on_prey(r, sys_info.r_cut, sys_info.IR);               % energy based influences
sys_info.phiE{1,2}           = @(r) PS1_predator_on_prey(r, sys_info.r_cut, sys_info.IR);                                   
sys_info.phiE{2,1}           = @(r) PS1_prey_on_predator(r, sys_info.r_cut, sys_info.IR);
sys_info.phiE{2,2}           = @(r) PS1_predator_on_predator(r, sys_info.r_cut, sys_info.IR);
sys_info.K                   = 2;                                                                   % number of classes
sys_info.ode_order           = 1;                                                                   % order of the ODE system
sys_info.type_info           = [ones(1, N_preys), 2 * ones(1,N_predators)];                         % class function mapping agent index to it class index
sys_info.has_noise           = false;                                                               % no stochastic noise
sys_info.manifold_type       = 'S2';
sys_info.g_type              = 'L2';
sys_info.mu0                 = @() sphere_init_config(sys_info.d, sys_info.N, sys_info.R, 2);       % distribution of initial conditions
sys_info.T_f                 = 0.5;                                                                 % final time the system will reach steady state
sys_info.on_manifold         = true;
sys_info.geodesic_dist       = @(xi, xj) geodesic_distance_on_sphere(xi, xj, sys_info.d, sys_info.R);
sys_info.geodesic_dist_mat   = @(x, xhat) geodesic_distance_on_sphere_mat(x, xhat, sys_info.d, sys_info.R);
sys_info.manifold_projection = @(y) projection_on_to_sphere(y, sys_info.d, sys_info.N, sys_info.R);
sys_info.weight_on_manifold  = @(y) geodesic_direction_on_sphere(y, y, sys_info.d, sys_info.R);

% ODE solver
solver_info.time_span        = [0, sys_info.T_f];                                                   % put it into the time_span vector, always starting from 0
solver_info.is_uniform       = true;
solver_info.order            = 4;
solver_info.multi_step       = true;
solver_info.h                = 1e-4;
solver_info.solver           = 'GNI';

% Observations 
obs_info.L                   = 500;                                                                 % observe (equi-spaced) times
obs_info.M                   = 500;                                                                 % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT              = 2000;                                                                % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_0                 = 0;                                                                   % Observation time interval [T_0, T]
obs_info.T                   = sys_info.T_f;                                                        % Observation time interval [T_0, T]
obs_info.time_vec            = linspace(obs_info.T_0, obs_info.T, obs_info.L);                      % time instances at which discrete observation is made
obs_info.use_derivative      = true;                                                                % indicator of the availability of derivative data
obs_info.hist_num_bins       = 1000;                                                                % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise           = 0.0;
obs_info.mu_trajnoise        = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.mu_dtrajnoise       = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );

% Learning
degree                       = 1;
type                         = {'B-spline'};
sub_type                     = {'Clamped'};
basis_info                   = construct_basis_info(sys_info, obs_info, degree, type, sub_type);
learn_info.Ebasis_info       = basis_info;
learn_info.hist_num_bins     = obs_info.hist_num_bins;

% package the data
Example.sys_info             = sys_info;
Example.solver_info          = solver_info;
Example.obs_info             = obs_info;
Example.learn_info           = learn_info;
end