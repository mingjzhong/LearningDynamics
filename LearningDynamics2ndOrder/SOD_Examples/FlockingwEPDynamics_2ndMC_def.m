function Example = FlockingwEPDynamics_2ndMC_def()
% function Example = FlockingwEPDynamics_2ndMC_def()
% Define associated terms for Flocking with External Potential dynamics

% System
sys_info.name            = 'FlockingwExternalPotential';
sys_info.d               = 2;                                                                       % the dimension for the opinion (state) vecor
sys_info.N               = 20;                                                                      % the number of agents          
strength                 = 0.1;                                                                     % ''a'' in the paper
sys_info.phiE            = {@(r) strength * ones(size(r))};                                         % energy based influence
beta                     = 1/2;
sys_info.phiA            = {@(r) FD_phiA(r, 1, beta)};                                              % alignment based interaction
sys_info.K               = 1;                                                                       % number of classes
sys_info.ode_order       = 2;                                                                       % order of the ODE system
sys_info.type_info       = ones(1, sys_info.N);                                                     % class function mapping agent index to it class index
sys_info.agent_mass      = ones(sys_info.N, 1);
sys_info.has_noise       = false;                                                                   % no stochastic noise
sys_info.mu0             = @() AD_init_config(sys_info.d, sys_info.N);                              % distribution of initial conditions
sys_info.T_f             = 10;                                                                       % the time for integration, t = T_f should be (most likely) for the system to reach steady state

% ODE solver
solver_info.time_span    = [0, sys_info.T_f];                                                       % put it into the time_span vector, always starting from 0
solver_info.rel_tol      = 1e-8;
solver_info.abs_tol      = 1e-11;

% Observations
obs_info.L               = 500;                                                                     % observe (equi-spaced) times
obs_info.M               = 500;                                                                     % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT          = 2000;                                                                    % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_0             = 0;                                                                       % Observation time interval [T_0, T]
obs_info.T               = sys_info.T_f/2;                                                          % Observation time interval [T_0, T]
obs_info.time_vec        = linspace(obs_info.T_0, obs_info.T, obs_info.L);                          % time instances at which discrete observation is made
obs_info.use_derivative  = true;                                                                    % indicator of the availability of derivative data
obs_info.hist_num_bins   = 1000;                                                                    % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise       = 0.0;
obs_info.mu_trajnoise    = @(traj,sigma) trajUnifNoiseMultiplicative(traj, sigma);
obs_info.mu_dtrajnoise   = @(traj,sigma) trajUnifNoiseMultiplicative(traj, sigma);

% Learning
degree                   = 1;
type                     = {'PW-polynomial'};
sub_type                 = {'Standard'};
period                   = Inf;
learn_info.Ebasis_info   = construct_basis_info(sys_info, obs_info, degree, type, sub_type, period);
learn_info.Abasis_info   = learn_info.Ebasis_info;
learn_info.hist_num_bins = obs_info.hist_num_bins;

% package the data
Example.sys_info         = sys_info;
Example.solver_info      = solver_info;
Example.obs_info         = obs_info;
Example.learn_info       = learn_info;
end
