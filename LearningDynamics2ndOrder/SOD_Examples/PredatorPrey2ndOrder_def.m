function Example = PredatorPrey2ndOrder_def()
% function Example = PredatorPrey2ndOrder_def()
% Define associated terms for PREDATOR-PREY 2nd ORDER

% System
sys_info.name            = 'PredatorPrey2ndOrder';
N_preys                  = 9;
N_predators              = 1;
N                        = N_preys + N_predators;
sys_info.d               = 2;                                                                       % the dimension for the opinion (state) vecor
sys_info.N               = N_preys + N_predators;                                                   % the number of agents
sys_info.phiE{1,1}       = @(r) PS_2nd_order_prey_on_prey(r);                                       % energy based prey on prey influence
sys_info.phiE{1,2}       = @(r) PS_2nd_order_predator_on_prey(r);                                   % energy based predator on prey influence  
sys_info.phiE{2,1}       = @(r) PS_2nd_order_prey_on_predator(r);                                   % energy based prey on predator influence
sys_info.phiE{2,2}       = @(r) PS_2nd_order_predator_on_predator(r);                               % energy based predator on predator influence
sys_info.K               = 2;                                                                       % number of classes
sys_info.ode_order       = 2;                                                                       % order of the ODE system
sys_info.agent_mass      = ones(N, 1);                                                              % mass constant of each agent
sys_info.type_info       = [ones(1, N_preys),2*ones(1,N_predators)];                                % class function mapping agent index to it class index
sys_info.nu              = [1; 1];
sys_info.Fv              = @(x, v, xi) PS_2nd_order_Fv(v, sys_info.nu, sys_info.K, sys_info.type_info);  % non-collective change to v
sys_info.has_noise       = false;                                                                   % no stochastic noise
sys_info.mu0             = @() PS_init_config(sys_info.N, sys_info.type_info, 2);                   % distribution of initial conditions
sys_info.T_f             = 20;                                                                      % the time for integration, t = T_f should be (most likely) for the system to reach steady state

% ODE solver
solver_info.time_span    = [0, sys_info.T_f];                                                       % put it into the time_span vector, always starting from 0

% Observations
obs_info.L               = 500;                                                                     % observe (equi-spaced) times
obs_info.M               = 500;                                                                     % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT          = 2000;                                                                    % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_0             = 0;                                                                       % Observation time interval [T_0, T]
obs_info.T               = sys_info.T_f/2;                                                          % Observation time interval [T_0, T]
obs_info.time_vec        = linspace(obs_info.T_0, obs_info.T, obs_info.L);                          % time instances at which discrete observation is made
obs_info.use_derivative  = false;                                                                   % indicator of the availability of derivative data
obs_info.hist_num_bins   = 1000;                                                                   % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise       = 0.1;
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
