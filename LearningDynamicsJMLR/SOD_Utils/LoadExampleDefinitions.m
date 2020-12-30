function Examples = LoadExampleDefinitions()

% function Examples = LoadExampleDefinitions()

% (c) M. Maggioni, M. Zhong

%% Common parameters
% ODE solver
solver_info.solver              = '15s';                                                            % use ode15s as the integrator
solver_info.rel_tol             = 1.0e-10;                                                           % the relative tolerance for adaptive integration
solver_info.abs_tol             = 1.0e-12;                                                           % the absolute tolerance for adaptive integration

% visualization
% visualization
plot_info.scrsz                    = [1, 1, 1920, 1080];                                            % find the 3rd and 4th parameters for bigger size (width x height)
plot_info.legend_font_size         = 32;
plot_info.colorbar_font_size       = 26;
plot_info.title_font_size          = 32;
plot_info.title_font_name          = 'Helvetica';
plot_info.axis_font_size           = 32;
plot_info.axis_font_name           = 'Helvetica';
plot_info.tick_font_size           = 26;
plot_info.tick_font_name           = 'Helvetica';
plot_info.traj_line_width          = 2.0;
plot_info.phi_line_width           = 1.5;
plot_info.phihat_line_width        = 1.5;
plot_info.rhotscalingdownfactor    = 1;
plot_info.showplottitles           = false;
plot_info.display_phihat           = false;
plot_info.display_interpolant      = true;
plot_info.T_L_marker_size          = plot_info.traj_line_width;

% learning
learn_info.solver_type          = 'pinv';                                                           % use the MATLAB built-in LS solver, for single class case, Phi is never singular (?), so mldivide can do the job
learn_info.is_parallel          = false;                                                            % default
learn_info.is_adaptive          = false;                                                            % adaptive learning (basis) indicator                                                                
learn_info.keep_obs_data        = true;                                                             % indicator to keep the observation data
learn_info.Riemann_sum          = 2;
learn_info.N_ratio              = 4;                                                                % predict the dynamics with 4 times the original # of agents

%% OPINION DYNAMICS Continuous
% System
sys_info.name                   = 'OpinionDynamicsCont';                                            % name of the dynamics
sys_info.d                      = 1;                                                                % dimension for the state vector (in this case, opinion vector)
sys_info.N                      = 10;                                                               % # of agents
sys_info.phiE                   = {@(r) OD_influence(r, 1)};                                        % energy based interaction
sys_info.K                      = 1;                                                                % # of types
sys_info.ode_order              = 1;                                                                % order of the ODE system
sys_info.type_info              = ones(1, sys_info.N);                                              % function mapping agent index to its type index
sys_info.kappa                  = 1;                                                                % coupling strength term
sys_info.RE                     = [];                                                               % energy based reulation on interactoin beween agent i and agent i'
sys_info.has_noise              = false;                                                            % no stochastic noise
sys_info.mu0                    = @() OD_init_config(sys_info.d, sys_info.N, 1);                    % distribution of initial conditions
sys_info.T_f                    = 20;                                                               % final time the system will reach steady state

% ODE solver
solver_info.time_span           = [0, sys_info.T_f];                                                % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                      = 100;                                                              % observe (equi-spaced) times
obs_info.M                      = 200;  %                                                             % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT                 = 2000;                                                             % # trajectories with random initial conditions to compute approximate \rho^L_T
obs_info.T_L                    = 1;                                                   % Observations will be up to this time
obs_info.time_vec               = linspace(0, obs_info.T_L, obs_info.L);                            % time instances at which discrete observation is made
obs_info.use_derivative         = false;                                                            % indicator of the availability of derivative data
obs_info.hist_num_bins          = 1000000;                                                            % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise              = 0;
obs_info.mu_trajnoise           = @(traj) trajUnifNoiseMultiplicative( traj, obs_info.obs_noise );
obs_info.mu_dtrajnoise          = @(traj) trajUnifNoiseMultiplicative( traj, obs_info.obs_noise );
obs_info.L_rhoT                 = obs_info.L;                                                       % observe (equi-spaced) times to compute approximate \rho_T
obs_info.L_test                 = obs_info.L;                                                       % observe (equi_spaced) times to test trajectory accuracy 
obs_info.M_test                 = obs_info.M;                                                       % # trajectories with new initial conditions on which to test trajectory accuracy
obs_info.Rsupp.R                = [ ];                                                              % used for histograms


% Learning
learn_info.solver_type          = 'pinv';                                                           % use the MATLAB built-in LS solver, for single class case, Phi is never singular (?), so mldivide can do the job
learn_info.is_parallel          = false;                                                            % default
basis_info.n                    =  ceil(60*(obs_info.M/log(obs_info.M)).^(1/3));  % number of basis functions
basis_info.type                 = 'standard';                                                       % basis funciton kind, standard piecewise polynomial
basis_info.degree               = 0;                                                                % degree of those polynomials
learn_info.Ebasis_info          = basis_info;                                                       % save the information on constructing basis for energy based functions
learn_info.to_predict_LN        = false;
learn_info.Rsupp                = obs_info.Rsupp;                                                   % used for histograms

% package the data
Examples{3}.sys_info            = sys_info;
Examples{3}.solver_info         = solver_info;
Examples{3}.obs_info            = obs_info;
Examples{3}.learn_info          = learn_info;
Examples{3}.plot_info           = plot_info;


%% PREDATOR-PREY 1st ORDER
% System
sys_info.name                   = 'PredatorPrey1stOrder';
N_preys                         = 5;                                                                % number of preys and single predator
N_predators                     = 1;
prey_attract_prey       = 1;                                                                        % parameters for the 4 (k1, k2) pair of interaction kernel
predator_repulse_prey   = 2;
prey_attract_predator   = 3.5;
predator_sense_prey     = 3;

sys_info.d                      = 2;                                                                % the dimension for the position/velocity vecor
sys_info.N                      = N_preys + N_predators;                                            % the number of agents
sys_info.phiE{1,1}              = @(r) PS_1st_order_prey_on_prey(r, prey_attract_prey );             % energy based influences
sys_info.phiE{1,2}              = @(r) PS_1st_order_predator_on_prey(r,predator_repulse_prey);                                   
sys_info.phiE{2,1}              = @(r) PS_1st_order_prey_on_predator(r, prey_attract_predator, predator_sense_prey);
sys_info.phiE{2,2}              = @(r) PS_1st_order_predator_on_predator(r);
sys_info.K                      = 2;                                                                % number of classes
sys_info.ode_order              = 1;                                                                % order of the ODE system
sys_info.type_info              = [ones(1, N_preys),2*ones(1,N_predators)];                         % class function mapping agent index to it class index
sys_info.kappa                  = ones(1, sys_info.K);                                              % coupling strength term
sys_info.RE                     = [];                                                               % regulation on collective influence on x
sys_info.has_noise              = false;                                                            % no stochastic noise
sys_info.mu0                    = @() PS_init_config(sys_info.N, sys_info.type_info, 1);            % distribution of initial conditions
sys_info.T_f                    = 20;                                                               % the time for integration, t = T_f should be (most likely) for the system to reach steady state

% ODE solver
solver_info.rel_tol             = 1.0e-5;                                                          % the relative tolerance for adaptive integration
solver_info.abs_tol             = 1.0e-6;                                                          % the absolute tolerance for adaptive integration
solver_info.time_span           = [0, sys_info.T_f];                                                % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                      = 101;                                                              % observe (equi-spaced) times
obs_info.M                      = 100;                                                               % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT                 = 2000;                                                             % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_L                    = 1;%sys_info.T_f/2;                                                   % Observations will be up to this time
obs_info.time_vec               = linspace(0, obs_info.T_L, obs_info.L);                            % time instances at which discrete observation is made
obs_info.use_derivative         = true;                                                             % indicator of the availability of derivative data
obs_info.hist_num_bins          = 10000;                                                            % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise              = 0.0;
obs_info.mu_trajnoise           = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.mu_dtrajnoise          = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.L_rhoT                 = obs_info.L;                                                       % observe (equi-spaced) times to compute approximate \rho_T
obs_info.L_test                 = obs_info.L;                                                       % observe (equi_spaced) times to test trajectory accuracy 
obs_info.M_test                 = obs_info.M;                                                       % # trajectories with new initial conditions on which to test trajectory accuracy
obs_info.Rsupp.R                = [];                                                              % used for histograms

% Learning
learn_info.solver_type          = 'pinv';                                                           % use the MATLAB built-in pseudo inverse (which does an automatic SVD with cutoff for roundoff errors)
learn_info.is_parallel          = false;                                                            % default
% basis_info.n                    = max(64 * ones(sys_info.K, sys_info.K), ...
% [ceil(obs_info.L * obs_info.M * N_preys * sys_info.d/500),                     ceil(obs_info.L * obs_info.M * sqrt(N_preys * N_predators) * sys_info.d/500); ...
%  ceil(obs_info.L * obs_info.M * sqrt(N_preys * N_predators) * sys_info.d/500), ceil(obs_info.L * obs_info.M * N_predators * sys_info.d/500)]); % number of basis functions for each (k1, k2) pair
basis_info.n =[2*ceil(35*(obs_info.M/log(obs_info.M))^(1/5)),2*ceil(35*(obs_info.M/log(obs_info.M))^(1/5));2*ceil(35*(obs_info.M/log(obs_info.M))^(1/5)),2*ceil(1*(obs_info.M/log(obs_info.M))^(1/5))];

basis_info.type                 = 'standard';                                                       % basis type
basis_info.degree               = [1, 1; 1, 1];   % polynomial degree
basis_info.is_splines           = false;     
learn_info.Ebasis_info          = basis_info;
learn_info.to_predict_LN        = true;
learn_info.Rsupp                = obs_info.Rsupp;                                                   % used for basis functions

% package the data
Examples{1}.sys_info            = sys_info;
Examples{1}.solver_info         = solver_info;
Examples{1}.obs_info            = obs_info;
Examples{1}.learn_info          = learn_info;
Examples{1}.plot_info           = plot_info;


%%Multi-Lennard-Jones 1st ORDER
% System
sys_info.name                   = 'MultiLennardJones1stOrder';
N_A                         = 5;                                                                % number of preys and single predator
N_B                         = 5;
sys_info.d                      = 2;                                                                % the dimension for the position/velocity vecor
sys_info.N                      = N_A + N_B;                                            % the number of agents
sys_info.phiE{1,1}              = @(r) MLJ_1st_order_A_on_A(r);             % energy based influences
sys_info.phiE{1,2}              = @(r) MLJ_1st_order_B_on_A(r);                                   
sys_info.phiE{2,1}              = @(r) MLJ_1st_order_A_on_B(r);
sys_info.phiE{2,2}              = @(r) MLJ_1st_order_B_on_B(r);
sys_info.K                      = 2;                                                                % number of classes
sys_info.ode_order              = 1;                                                                % order of the ODE system
sys_info.type_info              = [ones(1, N_A),2*ones(1,N_B)];                         % class function mapping agent index to it class index
sys_info.kappa                  = ones(1, sys_info.K);                                              % coupling strength term
sys_info.RE                     = [];                                                               % regulation on collective influence on x
sys_info.has_noise              = false;                                                            % no stochastic noise
sys_info.mu0                    = @() MLJ_init_config(sys_info.N, sys_info.type_info, 1);            % distribution of initial conditions
sys_info.T_f                    = 1;                                                               % the time for integration, t = T_f should be (most likely) for the system to reach steady state

% ODE solver
solver_info.rel_tol             = 1.0e-5;                                                          % the relative tolerance for adaptive integration
solver_info.abs_tol             = 1.0e-6;                                                          % the absolute tolerance for adaptive integration
solver_info.time_span           = [0, sys_info.T_f];                                                % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                      = 11;                                                              % observe (equi-spaced) times
obs_info.M                      = 10^2;                                                               % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT                 = 2000;                                                             % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_L                    = 0.05;%sys_info.T_f/2;                                                   % Observations will be up to this time
obs_info.time_vec               = linspace(0, obs_info.T_L, obs_info.L);                            % time instances at which discrete observation is made
obs_info.use_derivative         = true;                                                             % indicator of the availability of derivative data
obs_info.hist_num_bins          = 10000;                                                            % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise              = 0.0;
obs_info.mu_trajnoise           = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.mu_dtrajnoise          = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.L_rhoT                 = obs_info.L;                                                       % observe (equi-spaced) times to compute approximate \rho_T
obs_info.L_test                 = obs_info.L;                                                       % observe (equi_spaced) times to test trajectory accuracy 
obs_info.M_test                 = obs_info.M;                                                       % # trajectories with new initial conditions on which to test trajectory accuracy
obs_info.Rsupp.R                = [];                                                              % used for histograms
obs_info.h                      = 1e-6;                                                              % observe (equi-spaced) times

% Learning
learn_info.solver_type          = 'pinv';                                                           % use the MATLAB built-in pseudo inverse (which does an automatic SVD with cutoff for roundoff errors)
learn_info.is_parallel          = false;                                                            % default
% basis_info.n                    = max(64 * ones(sys_info.K, sys_info.K), ...
% [ceil(obs_info.L * obs_info.M * N_preys * sys_info.d/500),                     ceil(obs_info.L * obs_info.M * sqrt(N_preys * N_predators) * sys_info.d/500); ...
%  ceil(obs_info.L * obs_info.M * sqrt(N_preys * N_predators) * sys_info.d/500), ceil(obs_info.L * obs_info.M * N_predators * sys_info.d/500)]); % number of basis functions for each (k1, k2) pair
basis_info.n =[2*ceil(50*(obs_info.M/log(obs_info.M))^(1/5)),2*ceil(50*(obs_info.M/log(obs_info.M))^(1/5));2*ceil(50*(obs_info.M/log(obs_info.M))^(1/5)),2*ceil(50*(obs_info.M/log(obs_info.M))^(1/5))];

basis_info.type                 = 'standard';                                                       % basis type
basis_info.degree               = [1, 1; 1, 1];   % polynomial degree
basis_info.is_splines           = false;     
learn_info.Ebasis_info          = basis_info;
learn_info.to_predict_LN        = false;
learn_info.Rsupp                = obs_info.Rsupp;                                                   % used for basis functions

% package the data
Examples{2}.sys_info            = sys_info;
Examples{2}.solver_info         = solver_info;
Examples{2}.obs_info            = obs_info;
Examples{2}.learn_info          = learn_info;
Examples{2}.plot_info           = plot_info;

end