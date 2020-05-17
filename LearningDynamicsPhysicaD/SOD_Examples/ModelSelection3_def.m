function Example = ModelSelection3_def()
% function Example = ModelSelection3_def()
% Define associated terms for Model Selection 3: First Order Heterogeneous Dynamics (missing order information)

% System
sys_info.name            = 'ModelSelection3';                                                       % name of the dynamics
sys_info.d               = 2;                                                                       % dimension for the state vector (in this case, opinion vector)
N_preys                  = 9;                                                                       % number of preys
N_predators              = 1;                                                                       % single predator
sys_info.N               = N_preys + N_predators;                                                   % # of agents
sys_info.phiE{1,1}       = @(r) MS_interactions(r, 3);                                              % energy based influences, prey on prey
sys_info.phiE{1,2}       = @(r) MS_interactions(r, 4);                                              % energy based influences, predator on prey                                   
sys_info.phiE{2,1}       = @(r) MS_interactions(r, 5);                                              % energy based influences, prey on predator
sys_info.phiE{2,2}       = @(r) MS_interactions(r, 6);                                              % energy based influences, predator on predator
sys_info.phiA            = [];                                                                      % alignment based interaction
sys_info.K               = 2;                                                                       % # of types
sys_info.ode_order       = 1;                                                                       % order of the ODE system
sys_info.type_info       = [ones(1, N_preys),2*ones(1,N_predators)];                                % function mapping agent index to its type index
sys_info.agent_mass      = ones(sys_info.N, 1);                                                     % mass constant of each agent
sys_info.Fv              = @(v, xi, sys_info) MS_friction(v, 1);                                    % non-collective change to v
sys_info.has_noise       = false;                                                                   % no stochastic noise
sys_info.mu0             = @() MS_init_config(sys_info.d, sys_info.N, sys_info.type_info, 2);       % distribution of initial conditions
sys_info.T_f             = 1;                                                                       % final time the system will reach steady state

% ODE solver
solver_info.time_span    = [0, sys_info.T_f];                                                       % put it into the time_span vector, always starting from 0

% Observations
obs_info.L               = 250;                                                                     % observe (equi-spaced) times
obs_info.M               = 250;                                                                     % # trajectories with random initial conditions for learning interaction kernel
obs_info.T_0             = 0;                                                                       % Observation time interval [T_0, T]
obs_info.T               = sys_info.T_f;                                                            % Observation time interval [T_0, T]
obs_info.time_vec        = linspace(obs_info.T_0, obs_info.T, obs_info.L);                          % time instances at which discrete observation is made
obs_info.time_vec        = linspace(0, obs_info.T_L, obs_info.L);                                   % time instances at which discrete observation is made
obs_info.use_derivative  = false;                                                                   % indicator of the availability of derivative data
obs_info.hist_num_bins   = 1000;                                                                    % number of bins for estimating \rho^L_T for all three different interactions

% Learning
degree                   = 1;
type                     = {'PW-polynomial'};
sub_type                 = {'Standard'};
basis_info               = construct_basis_info(sys_info, obs_info, degree, type, sub_type);
learn_info.Ebasis_info   = basis_info;                                                              % save the information on constructing basis for energy based function
learn_info.hist_num_bins = obs_info.hist_num_bins;                                                  % number of bins for estimating \rho_T^{L, M} for all three different interactions

% package the data
Example.sys_info         = sys_info;
Example.solver_info      = solver_info;
Example.obs_info         = obs_info;
Example.learn_info       = learn_info;
end