function Example = OpinionDynamicsCont_def()
% function Example = OpinionDynamicsCont_def()
% Define associated terms for OPINION DYNAMICS Continuous

% (c) M. Zhong

% System
sys_info.name           = 'OpinionDynamicsCont';                                                    % name of the dynamics
sys_info.d              = 1;                                                                        % dimension for the state vector (in this case, opinion vector)
sys_info.N              = 10;                                                                       % # of agents
sys_info.phiE           = {@(r) OD_influence(r, 5)};                                                % energy based interaction
sys_info.K              = 1;                                                                        % # of types
sys_info.ode_order      = 1;                                                                        % order of the ODE system
sys_info.type_info      = ones(1, sys_info.N);                                                      % function mapping agent index to its type index
sys_info.kappa          = 1;                                                                        % coupling strength term
sys_info.RE             = [];                                                                       % energy based reulation on interactoin beween agent i and agent i'
sys_info.has_noise      = false;                                                                    % no stochastic noise
sys_info.mu0            = @() OD_init_config(sys_info.d, sys_info.N, 1);                            % distribution of initial conditions
sys_info.T_f            = 30;                                                                       % final time the system will reach steady state

% ODE solver
solver_info.time_span   = [0, sys_info.T_f];                                                        % put it into the time_span vector, always starting from 0

% Observations
obs_info.L              = 200;                                                                      % observe (equi-spaced) times
obs_info.M              = 50;                                                                       % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT         = 2000;                                                                     % # trajectories with random initial conditions to compute approximate \rho^L_T
obs_info.T_L            = sys_info.T_f/2;                                                           % Observations will be up to this time
obs_info.time_vec       = linspace(0, obs_info.T_L, obs_info.L);                                    % time instances at which discrete observation is made
obs_info.use_derivative = false;                                                                    % indicator of the availability of derivative data
obs_info.hist_num_bins  = 10000;                                                                    % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise      = 0;
obs_info.mu_trajnoise   = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.mu_dtrajnoise  = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );

% Learning
basis_info.n            = max(64, ceil(obs_info.L*obs_info.M*sys_info.N*sys_info.d/500));           % number of basis functions
basis_info.type         = 'standard';                                                               % basis funciton kind, standard piecewise polynomial
basis_info.degree       = 1;                                                                        % degree of those polynomials
learn_info.Ebasis_info  = basis_info;                                                               % save the information on constructing basis for energy based functions

% package the data
Example.sys_info        = sys_info;
Example.solver_info     = solver_info;
Example.obs_info        = obs_info;
Example.learn_info      = learn_info;
end