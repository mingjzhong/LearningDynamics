function Example = ModelSelection1_def()
% function Example = ModelSelection1_def()
% Define associated terms for Model Selection, energy vs. alignment, energy only

% System
sys_info.name            = 'MS1_EvA_Energy';                                                        % name of the dynamics
sys_info.d               = 2;                                                                       % dimension for the state vector (in this case, opinion vector)
sys_info.N               = 10;                                                                      % # of agents
sys_info.phiE            = {@(r) MS_interactions(r, 1)};                                            % energy based interaction
sys_info.phiA            = {@(r) zeros(size(r))};                                                   % alignment based interaction
sys_info.K               = 1;                                                                       % # of types
sys_info.ode_order       = 2;                                                                       % order of the ODE system
sys_info.type_info       = ones(1, sys_info.N);                                                     % function mapping agent index to its type index
sys_info.agent_mass      = ones(sys_info.N, 1);                                                     % mass constant of each agent
sys_info.Fv              = @(x, v, xi) MS_friction(v, 1);                                           % non-collective change to v
sys_info.has_noise       = false;                                                                   % no stochastic noise
sys_info.mu0             = @() MS_init_config(sys_info.d, sys_info.N, sys_info.type_info, 1);       % distribution of initial conditions
sys_info.T_f             = 10;                                                                      % final time the system will reach steady state

% ODE solver
solver_info.time_span    = [0, sys_info.T_f];                                                       % put it into the time_span vector, always starting from 0

% Observations
obs_info.L               = 500;                                                                     % observe (equi-spaced) times
obs_info.M               = 250;                                                                     % # trajectories with random initial conditions for learning interaction kernel
obs_info.T_0             = 0;                                                                       % Observation time interval [T_0, T]
obs_info.T               = sys_info.T_f;                                                            % Observation time interval [T_0, T]
obs_info.time_vec        = linspace(obs_info.T_0, obs_info.T, obs_info.L);                          % time instances at which discrete observation is made
obs_info.use_derivative  = false;                                                                   % indicator of the availability of derivative data
obs_info.hist_num_bins   = 1000;                                                                    % number of bins for estimating \rho^L_T for all three different interactions

% Learning
degree                   = 1;
type                     = {'PW-polynomial'};
sub_type                 = {'Standard'};
basis_info               = construct_basis_info(sys_info, obs_info, degree, type, sub_type);
learn_info.Ebasis_info   = basis_info;                                                              % basis info. for Ebasis
learn_info.Abasis_info   = basis_info;                                                              % basis info. for Absis
learn_info.hist_num_bins = obs_info.hist_num_bins;                                                  % number of bins for estimating \rho_T^{L, M} for all three different interactions

% package the data
Example.sys_info         = sys_info;
Example.solver_info      = solver_info;
Example.obs_info         = obs_info;
Example.learn_info       = learn_info;
end