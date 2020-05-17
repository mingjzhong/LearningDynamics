function Example = PredatorPrey1stOrder_def()
% function Example = PredatorPrey1stOrder_def()
% Define associated terms for PREDATOR-PREY 1st ORDER

% System
sys_info.name            = 'PredatorPrey1stOrder';
N_preys                  = 9;                                                                       % number of preys and single predator
N_predators              = 1;
prey_attract_prey        = 1;                                                                       % parameters for the 4 (k1, k2) pair of interaction kernel
predator_repulse_prey    = 2;
prey_attract_predator    = 3.5;
predator_sense_prey      = 3;
sys_info.d               = 2;                                                                       % the dimension for the position/velocity vecor
sys_info.N               = N_preys + N_predators;                                                   % the number of agents
sys_info.phiE{1,1}       = @(r) PS_1st_order_prey_on_prey(r, prey_attract_prey);                    % energy based influences
sys_info.phiE{1,2}       = @(r) PS_1st_order_predator_on_prey(r, predator_repulse_prey);                                   
sys_info.phiE{2,1}       = @(r) PS_1st_order_prey_on_predator(r, prey_attract_predator, predator_sense_prey);
sys_info.phiE{2,2}       = @(r) PS_1st_order_predator_on_predator(r);
sys_info.K               = 2;                                                                       % number of classes
sys_info.ode_order       = 1;                                                                       % order of the ODE system
sys_info.type_info       = [ones(1, N_preys),2*ones(1,N_predators)];                                % class function mapping agent index to it class index
sys_info.has_noise       = false;                                                                   % no stochastic noise
sys_info.mu0             = @() PS_init_config(sys_info.N, sys_info.type_info, 1);                   % distribution of initial conditions
sys_info.T_f             = 10;                                                                      % the time for integration, t = T_f should be (most likely) for the system to reach steady state

% ODE solver
solver_info.time_span    = [0, sys_info.T_f];                                                       % put it into the time_span vector, always starting from 0

% Observations 
obs_info.L               = 500;                                                                     % observe (equi-spaced) times
obs_info.M               = 250;                                                                     % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT          = 2000;                                                                    % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_0             = 0;                                                                       % Observation time interval [T_0, T]
obs_info.T               = sys_info.T_f/5;                                                          % Observation time interval [T_0, T]
obs_info.time_vec        = linspace(obs_info.T_0, obs_info.T, obs_info.L);                          % time instances at which discrete observation is made
obs_info.use_derivative  = true;                                                                    % indicator of the availability of derivative data
obs_info.hist_num_bins   = 10000;                                                                   % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise       = 0.0;
obs_info.mu_trajnoise    = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.mu_dtrajnoise   = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );

% Learning
degree                   = 1;
type                     = {'PW-polynomial'};
sub_type                 = {'Standard'};
basis_info               = construct_basis_info(sys_info, obs_info, degree, type, sub_type);
learn_info.Ebasis_info   = basis_info;
learn_info.hist_num_bins = obs_info.hist_num_bins;

% package the data
Example.sys_info         = sys_info;
Example.solver_info      = solver_info;
Example.obs_info         = obs_info;
Example.learn_info       = learn_info;
end