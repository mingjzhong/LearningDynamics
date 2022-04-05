function Example = OpinionDynamicsDisc_def()
% function Example = OpinionDynamicsDisc_def()
% Define associated terms for OPINION DYNAMICS Discontinuous

% System
sys_info.name            = 'OpinionDynamicsDisc';                                                   % name of the dynamics
sys_info.d               = 1;                                                                       % dimension for the state vector (in this case, opinion vector)
sys_info.N               = 20;                                                                      % # of agents
sys_info.phiE            = {@(r) OD_phiE(r, 1)};                                                    % energy based interaction
sys_info.K               = 1;                                                                       % # of types
sys_info.ode_order       = 1;                                                                       % order of the ODE system
sys_info.type_info       = ones(1, sys_info.N);                                                     % function mapping agent index to its type index
sys_info.has_noise       = false;                                                                   % no stochastic noise
sys_info.mu0             = @() OD_init_config(sys_info.d, sys_info.N);                              % distribution of initial conditions
sys_info.T_f             = 20;                                                                      % final time the system will reach steady state

% ODE solver
solver_info.time_span    = [0, sys_info.T_f];                                                       % put it into the time_span vector, always starting from 0

% Observations
obs_info.L               = 500;                                                                     % observe (equi-spaced) times
obs_info.M               = 500;                                                                     % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT          = 2000;                                                                    % # trajectories with random initial conditions to compute approximate \rho^L_T
obs_info.T_0             = 0;                                                                       % Observation time interval [T_0, T]
obs_info.T               = sys_info.T_f/2;                                                          % Observation time interval [T_0, T]
obs_info.time_vec        = linspace(obs_info.T_0, obs_info.T, obs_info.L);                          % time instances at which discrete observation is made
obs_info.use_derivative  = false;                                                                   % indicator of the availability of derivative data
obs_info.hist_num_bins   = 1000;                                                                    % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise       = 0;
obs_info.mu_trajnoise    = @(traj,sigma) trajUnifNoiseAdditive( traj, sigma );
obs_info.mu_dtrajnoise   = @(traj,sigma) trajUnifNoiseAdditive( traj, sigma );

% Learning
degree                   = 0;
type                     = {'PW-polynomial'};
sub_type                 = {'Standard'};
basis_info               = construct_basis_info(sys_info, obs_info, degree, type, sub_type);
learn_info.Ebasis_info   = basis_info;                                                              % save the information on constructing basis for energy based functions                                                           
learn_info.hist_num_bins = obs_info.hist_num_bins;

% package data
Example.sys_info         = sys_info;
Example.solver_info      = solver_info;
Example.obs_info         = obs_info;
Example.learn_info       = learn_info;
end