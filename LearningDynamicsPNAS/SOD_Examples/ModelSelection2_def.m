function Example = ModelSelection2_def()
% function Example = ModelSelection2_def()
% Define associated terms for Model Selection 2: Alignment Based Interactions (only) 

% System
sys_info.name           = 'ModelSelection2';                                                        % name of the dynamics
sys_info.d              = 2;                                                                        % dimension for the state vector (in this case, opinion vector)
sys_info.N              = 10;                                                                       % # of agents
sys_info.phiE           = {@(r) zeros(size(r))};                                                    % energy based interaction
sys_info.phiA           = {@(r) MS_interactions(r, 2)};                                             % alignment based interaction
sys_info.K              = 1;                                                                        % # of types
sys_info.ode_order      = 2;                                                                        % order of the ODE system
sys_info.type_info      = ones(1, sys_info.N);                                                      % function mapping agent index to its type index
sys_info.agent_mass     = ones(sys_info.N, 1);                                                      % mass constant of each agent
sys_info.kappa          = 1;                                                                        % coupling strength term, control interaction intensity
sys_info.RE             = [];                                                                       % energy    based regulation on interactoin beween agent i and agent i'
sys_info.RA             = [];                                                                       % alignment based regulation on interactoin beween agent i and agent i'
sys_info.Fv             = @(v, xi) MS_friction(v, 1);                                               % non-collective change to v
sys_info.has_xi         = false;                                                                    % no xi
sys_info.has_noise      = false;                                                                    % no stochastic noise
sys_info.mu0            = @() MS_init_config(sys_info.d, sys_info.N, sys_info.type_info, 1);        % distribution of initial conditions
sys_info.T_f            = 10;                                                                       % final time the system will reach steady state

% ODE solver
solver_info.time_span   = [0, sys_info.T_f];                                                        % put it into the time_span vector, always starting from 0

% Observations
obs_info.L              = 200;                                                                      % observe (equi-spaced) times
obs_info.M              = 200;                                                                      % # trajectories with random initial conditions for learning interaction kernel
obs_info.T_L            = sys_info.T_f;                                                             % Observations will be up to this time
obs_info.time_vec       = linspace(0, obs_info.T_L, obs_info.L);                                    % time instances at which discrete observation is made
obs_info.use_derivative = false;                                                                    % indicator of the availability of derivative data
obs_info.hist_num_bins  = 2000;                                                                     % number of bins for estimating \rho^L_T for all three different interactions

% Learning
basis_info.n            = max(300, ceil(obs_info.L*obs_info.M*sys_info.N*sys_info.d/1000));         % number of basis functions%max(600, ceil(obs_info.L*obs_info.M*sys_info.N*sys_info.d/1000)); % number of basis functions
basis_info.type         = 'standard';                                                               % basis funciton kind, standard piecewise polynomial
basis_info.degree       = 1;                                                                        % degree of those polynomials
learn_info.Ebasis_info  = basis_info;                                                               % save the information on constructing basis for energy based functions
learn_info.Abasis_info  = basis_info;

% package the data
Example.sys_info        = sys_info;
Example.solver_info     = solver_info;
Example.obs_info        = obs_info;
Example.learn_info      = learn_info;
end