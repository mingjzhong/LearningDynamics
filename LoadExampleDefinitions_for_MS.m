function Examples = LoadExampleDefinitions_for_MS()

% function Examples = LoadExampleDefinitions_for_MS()

% (c) M. Zhong (JHU)

%% Common parameters
% ODE solver
solver_info.solver              = '15s';                                                            % use ode15s as the integrator
solver_info.rel_tol             = 1.0e-5;                                                           % the relative tolerance for adaptive integration
solver_info.abs_tol             = 1.0e-6;                                                           % the absolute tolerance for adaptive integration

% visualization
plot_info.legend_font_size      = 32;
plot_info.colorbar_font_size    = 20;
plot_info.title_font_size       = 20;
plot_info.title_font_name       = 'Helvetica';
plot_info.axis_font_size        = 32;
plot_info.axis_font_name        = 'Helvetica';
plot_info.traj_line_width       = 2.0;
plot_info.phi_line_width        = 1.5;
plot_info.phihat_line_width     = 1.5;
plot_info.rhotscalingdownfactor = 1;
plot_info.showplottitles        = false;
plot_info.display_phihat        = false;
plot_info.display_interpolant   = true;
plot_info.T_L_marker_size       = plot_info.traj_line_width;

% learning
learn_info.solver_type          = 'pinv';                                                           % use the MATLAB built-in LS solver, for single class case, Phi is never singular (?), so mldivide can do the job
learn_info.is_parallel          = false;                                                            % default
learn_info.is_adaptive          = false;                                                            % adaptive learning (basis) indicator                                                                
learn_info.keep_obs_data        = true;                                                             % indicator to keep the observation data
learn_info.Riemann_sum          = 2;

%% Model Selection 1: Energy Based Interactions (only) 
% System
sys_info.name                   = 'ModelSelection1';                                                % name of the dynamics
sys_info.d                      = 2;                                                                % dimension for the state vector (in this case, opinion vector)
sys_info.N                      = 10;                                                               % # of agents
sys_info.phiE                   = {@(r) MS_interactions(r, 1)};                                     % energy based interaction
sys_info.phiA                   = {@(r) zeros(size(r))};                                            % alignment based interaction
sys_info.K                      = 1;                                                                % # of types
sys_info.ode_order              = 2;                                                                % order of the ODE system
sys_info.type_info              = ones(1, sys_info.N);                                              % function mapping agent index to its type index
sys_info.agent_mass             = ones(sys_info.N, 1);                                              % mass constant of each agent
sys_info.kappa                  = 1;                                                                % coupling strength term, control interaction intensity
sys_info.RE                     = [];                                                               % energy    based regulation on interactoin beween agent i and agent i'
sys_info.RA                     = [];                                                               % alignment based regulation on interactoin beween agent i and agent i'
sys_info.Fv                     = @(v, xi) MS_friction(v, 1);                                       % non-collective change to v
sys_info.has_xi                 = false;                                                            % no xi
sys_info.has_noise              = false;                                                            % no stochastic noise
sys_info.mu0                    = @() MS_init_config(sys_info.d, sys_info.N, sys_info.type_info, 1);% distribution of initial conditions
sys_info.T_f                    = 10;                                                               % final time the system will reach steady state

% ODE solver
solver_info.time_span           = [0, sys_info.T_f];                                                % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                      = 200;                                                              % observe (equi-spaced) times
obs_info.M                      = 200;                                                              % # trajectories with random initial conditions for learning interaction kernel
obs_info.T_L                    = sys_info.T_f;                                                     % Observations will be up to this time
obs_info.time_vec               = linspace(0, obs_info.T_L, obs_info.L);                            % time instances at which discrete observation is made
obs_info.use_derivative         = false;                                                            % indicator of the availability of derivative data
obs_info.hist_num_bins          = 2000;                                                             % number of bins for estimating \rho^L_T for all three different interactions

% Learning
basis_info.n                    = max(300, ceil(obs_info.L*obs_info.M*sys_info.N*sys_info.d/1000)); % number of basis functions%max(600, ceil(obs_info.L*obs_info.M*sys_info.N*sys_info.d/1000)); % number of basis functions
basis_info.type                 = 'standard';                                                       % basis funciton kind, standard piecewise polynomial
basis_info.degree               = 1;                                                                % degree of those polynomials
learn_info.Ebasis_info          = basis_info;                                                       % save the information on constructing basis for energy based functions
learn_info.Abasis_info          = basis_info;

% package the data
Examples{1}.sys_info            = sys_info;
Examples{1}.solver_info         = solver_info;
Examples{1}.obs_info            = obs_info;
Examples{1}.learn_info          = learn_info;
Examples{1}.plot_info           = plot_info;

%% Model Selection 2: Alignment Based Interactions (only) 
% System
sys_info.name                   = 'ModelSelection2';                                                % name of the dynamics
sys_info.d                      = 2;                                                                % dimension for the state vector (in this case, opinion vector)
sys_info.N                      = 10;                                                               % # of agents
sys_info.phiE                   = {@(r) zeros(size(r))};                                            % energy based interaction
sys_info.phiA                   = {@(r) MS_interactions(r, 2)};                                     % alignment based interaction
sys_info.K                      = 1;                                                                % # of types
sys_info.ode_order              = 2;                                                                % order of the ODE system
sys_info.type_info              = ones(1, sys_info.N);                                              % function mapping agent index to its type index
sys_info.agent_mass             = ones(sys_info.N, 1);                                              % mass constant of each agent
sys_info.kappa                  = 1;                                                                % coupling strength term, control interaction intensity
sys_info.RE                     = [];                                                               % energy    based regulation on interactoin beween agent i and agent i'
sys_info.RA                     = [];                                                               % alignment based regulation on interactoin beween agent i and agent i'
sys_info.Fv                     = @(v, xi) MS_friction(v, 1);                                       % non-collective change to v
sys_info.has_xi                 = false;                                                            % no xi
sys_info.has_noise              = false;                                                            % no stochastic noise
sys_info.mu0                    = @() MS_init_config(sys_info.d, sys_info.N, sys_info.type_info, 1);% distribution of initial conditions
sys_info.T_f                    = 10;                                                               % final time the system will reach steady state

% ODE solver
solver_info.time_span           = [0, sys_info.T_f];                                                % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                      = 200;                                                              % observe (equi-spaced) times
obs_info.M                      = 200;                                                              % # trajectories with random initial conditions for learning interaction kernel
obs_info.T_L                    = sys_info.T_f;                                                     % Observations will be up to this time
obs_info.time_vec               = linspace(0, obs_info.T_L, obs_info.L);                            % time instances at which discrete observation is made
obs_info.use_derivative         = false;                                                            % indicator of the availability of derivative data
obs_info.hist_num_bins          = 2000;                                                             % number of bins for estimating \rho^L_T for all three different interactions

% Learning
basis_info.n                    = max(300, ceil(obs_info.L*obs_info.M*sys_info.N*sys_info.d/1000)); % number of basis functions%max(600, ceil(obs_info.L*obs_info.M*sys_info.N*sys_info.d/1000)); % number of basis functions
basis_info.type                 = 'standard';                                                       % basis funciton kind, standard piecewise polynomial
basis_info.degree               = 1;                                                                % degree of those polynomials
learn_info.Ebasis_info          = basis_info;                                                       % save the information on constructing basis for energy based functions
learn_info.Abasis_info          = basis_info;

% package the data
Examples{2}.sys_info            = sys_info;
Examples{2}.solver_info         = solver_info;
Examples{2}.obs_info            = obs_info;
Examples{2}.learn_info          = learn_info;
Examples{2}.plot_info           = plot_info;

%% Model Selection 3: First Order Heterogeneous Dynamics (missing order information)
% System
sys_info.name                   = 'ModelSelection3';                                                % name of the dynamics
sys_info.d                      = 2;                                                                % dimension for the state vector (in this case, opinion vector)
N_preys                         = 9;                                                                % number of preys
N_predators                     = 1;                                                                % single predator
sys_info.N                      = N_preys + N_predators;                                            % # of agents
sys_info.phiE{1,1}              = @(r) MS_interactions(r, 3);                                       % energy based influences, prey on prey
sys_info.phiE{1,2}              = @(r) MS_interactions(r, 4);                                       % energy based influences, predator on prey                                   
sys_info.phiE{2,1}              = @(r) MS_interactions(r, 5);                                       % energy based influences, prey on predator
sys_info.phiE{2,2}              = @(r) MS_interactions(r, 6);                                       % energy based influences, predator on predator
sys_info.phiA                   = [];                                                               % alignment based interaction
sys_info.K                      = 2;                                                                % # of types
sys_info.ode_order              = 1;                                                                % order of the ODE system
sys_info.type_info              = [ones(1, N_preys),2*ones(1,N_predators)];                         % function mapping agent index to its type index
sys_info.agent_mass             = ones(sys_info.N, 1);                                              % mass constant of each agent
sys_info.kappa                  = ones(1, sys_info.K);                                              % coupling strength term, control interaction intensity
sys_info.RE                     = [];                                                               % energy    based regulation on interactoin beween agent i and agent i'
sys_info.RA                     = [];                                                               % alignment based regulation on interactoin beween agent i and agent i'
sys_info.Fv                     = @(v, xi) MS_friction(v, 1);                                       % non-collective change to v
sys_info.has_xi                 = false;                                                            % no xi
sys_info.has_noise              = false;                                                            % no stochastic noise
sys_info.mu0                    = @() MS_init_config(sys_info.d, sys_info.N, sys_info.type_info, 2);% distribution of initial conditions
sys_info.T_f                    = 1;                                                                % final time the system will reach steady state

% ODE solver
solver_info.time_span           = [0, sys_info.T_f];                                                % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                      = 250;                                                              % observe (equi-spaced) times
obs_info.M                      = 250;                                                              % # trajectories with random initial conditions for learning interaction kernel
obs_info.L_test                 = obs_info.L;                                                       % observe (equi-spaced) times for testing trajectory error
obs_info.T_L                    = sys_info.T_f;                                                     % Observations will be up to this time
obs_info.time_vec               = linspace(0, obs_info.T_L, obs_info.L);                            % time instances at which discrete observation is made
obs_info.use_derivative         = false;                                                            % indicator of the availability of derivative data
obs_info.hist_num_bins          = 1000;                                                            % number of bins for estimating \rho^L_T for all three different interactions

% Learning
basis_info.n                    = [298, 150; 150, 2];                                               % number of basis functions
basis_info.type                 = 'standard';                                                       % basis funciton kind, standard piecewise polynomial
basis_info.degree               = [1, 1; 1, 0];                                                     % degree of those polynomials
learn_info.Ebasis_info          = basis_info;                                                       % save the information on constructing basis for energy based functions
learn_info.Abasis_info          = [];

% package the data
Examples{3}.sys_info            = sys_info;
Examples{3}.solver_info         = solver_info;
Examples{3}.obs_info            = obs_info;
Examples{3}.learn_info          = learn_info;
Examples{3}.plot_info           = plot_info;

%% Model Selection 4: Second Order Heterogeneous Dynamics (missing order information)
% System
sys_info.name                   = 'ModelSelection4';                                                % name of the dynamics
sys_info.d                      = 2;                                                                % dimension for the state vector (in this case, opinion vector)
N_preys                         = 9;                                                                % number of preys
N_predators                     = 1;                                                                % single predator
sys_info.N                      = N_preys + N_predators;                                            % # of agents
sys_info.phiE{1,1}              = @(r) MS_interactions(r, 3);                                       % energy based influences, prey on prey
sys_info.phiE{1,2}              = @(r) MS_interactions(r, 7);                                       % energy based influences, predator on prey                                   
sys_info.phiE{2,1}              = @(r) MS_interactions(r, 8);                                       % energy based influences, prey on predator
sys_info.phiE{2,2}              = @(r) MS_interactions(r, 6);                                       % energy based influences, predator on predator
sys_info.phiA                   = [];                                                               % alignment based interaction
sys_info.K                      = 2;                                                                % # of types
sys_info.ode_order              = 2;                                                                % order of the ODE system
sys_info.type_info              = [ones(1, N_preys), 2*ones(1,N_predators)];                         % function mapping agent index to its type index
sys_info.agent_mass             = ones(sys_info.N, 1);                                              % mass constant of each agent
sys_info.kappa                  = ones(1, sys_info.K);                                              % coupling strength term, control interaction intensity
sys_info.RE                     = [];                                                               % energy    based regulation on interactoin beween agent i and agent i'
sys_info.RA                     = [];                                                               % alignment based regulation on interactoin beween agent i and agent i'
sys_info.Fv                     = @(v, xi) MS_friction(v, 1);                                       % non-collective change to v
sys_info.has_xi                 = false;                                                            % no xi
sys_info.has_noise              = false;                                                            % no stochastic noise
sys_info.mu0                    = @() MS_init_config(sys_info.d, sys_info.N, sys_info.type_info, 3);% distribution of initial conditions
sys_info.T_f                    = 1;                                                                % final time the system will reach steady state

% ODE solver
solver_info.time_span           = [0, sys_info.T_f];                                                % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                      = 250;                                                              % observe (equi-spaced) times
obs_info.M                      = 250;                                                              % # trajectories with random initial conditions for learning interaction kernel
obs_info.L_test                 = obs_info.L;                                                       % observe (equi-spaced) times for testing trajectory error
obs_info.T_L                    = sys_info.T_f;                                                     % Observations will be up to this time
obs_info.time_vec               = linspace(0, obs_info.T_L, obs_info.L);                            % time instances at which discrete observation is made
obs_info.use_derivative         = false;                                                            % indicator of the availability of derivative data
obs_info.hist_num_bins          = 1000;                                                             % number of bins for estimating \rho^L_T for all three different interactions

% Learning
basis_info.n                    = [298, 150; 150, 2];                                               % number of basis functions
basis_info.type                 = 'standard';                                                       % basis funciton kind, standard piecewise polynomial
basis_info.degree               = [1, 1; 1, 0];                                                     % degree of those polynomials                                                                % degree of those polynomials
learn_info.Ebasis_info          = basis_info;                                                       % save the information on constructing basis for energy based functions
learn_info.Abasis_info          = [];

% package the data
Examples{4}.sys_info            = sys_info;
Examples{4}.solver_info         = solver_info;
Examples{4}.obs_info            = obs_info;
Examples{4}.learn_info          = learn_info;
Examples{4}.plot_info           = plot_info;

return