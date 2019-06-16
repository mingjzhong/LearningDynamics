function Example = PhototaxisDynamics_def()
% function Example = PhototaxisDynamics_def()
% Define associated terms for Phototaxis Dynamics

% System
sys_info.name             = 'PhototaxisDynamics';
sys_info.d                = 2;                                                                      % the dimension for the opinion (state) vecor
sys_info.N                = 10;                                                                     % the number of agents
sys_info.phiE             = [];                                                                     % energy based interaction kernel
beta                      = 0.25;                                                                   % parameter for v_i and xi_i interaction kernels
sys_info.phiA             = {@(r) PT_interaction(r, beta)};                                         % alignment based interaction
sys_info.K                = 1;                                                                      % number of classes
sys_info.ode_order        = 2;                                                                      % order of the ODE system
sys_info.agent_mass       = ones(sys_info.N, 1);                                                    % mass constant of each agent
sys_info.type_info        = ones(1, sys_info.N);                                                    % class function mapping agent index to it class index
sys_info.kappa            = sys_info.N;                                                             % coupling strength term
sys_info.RE               = [];                                                                     % energy based regulation on collective influence on x_i
sys_info.RA               = [];                                                                     % alignment based regulation on collective influence on v_i
I_0                       = 0.1;                                                                    % light intensity
v_term                    = [60; 0];                                                                % terminal velocity (light direction at infinity)
xi_critical               = 0.3;                                                                    % critical excitation level (for light effect to activate)
cutoff_func               = @(xi, cutoff) smooth_cutoff(xi, cutoff);                                % the smooth cutoff function on light effect on xi and v
sys_info.Fv               = @(v, xi) PT_external_force(v, xi, I_0, cutoff_func, xi_critical, v_term); % non-collective change to v
sys_info.has_xi           = true;                                                                   % has xi
sys_info.phiXi            = {@(r) PT_interaction(r, beta)};                                         % interactional kernel on xi_i
sys_info.Rxi              = [];                                                                     % xi based regulation on interaction kernel
sys_info.kappaXi          = sys_info.N;                                                             % xi based coupling strength term
xi_capacity               = 2 * xi_critical;                                                        % excitation capacity (for light effect to decay)
num_neighbor              = 5;                                                                      % number of neighbors to have influence on the agent
kernel_type               = 'global';                                                               % search in the whole domain for neighbors
neighbor_func             = @(x, xi) find_neighbors(x, num_neighbor, kernel_type);                  % the functiont to find neighbors
sys_info.Fxi              = @(xi, x) PT_xi_external(x, xi, I_0, cutoff_func, xi_capacity, neighbor_func); % non-collective change on xi_i
sys_info.has_noise        = false;                                                                  % no stochastic noise
sys_info.mu0              = @() PT_init_condition(sys_info.d, sys_info.N, 100, 100, 0.001);         % distribution of initial conditions
sys_info.T_f              = 0.5;                                                                    % the time for integration, t = T_f should be (most likely) for the system to reach steady state

% ODE solver
solver_info.time_span     = [0, sys_info.T_f];                                                      % put it into the time_span vector, always starting from 0

% Observations
obs_info.L                = 200;                                                                    % observe (equi-spaced) times for learning interaction kernel(s)
obs_info.M                = 50;                                                                    % # trajectories with random initial conditions for learning interaction kernel(s)
obs_info.M_rhoT           = 2000;                                                                    % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_L              = sys_info.T_f/2;                                                         % Observations will be up to this time
obs_info.time_vec         = linspace(0, obs_info.T_L, obs_info.L);                                  % time instances at which discrete observation is made
obs_info.use_derivative   = false;                                                                  % indicator of the availability of derivative data
obs_info.hist_num_bins    = 1000;                                                                   % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise        = 0.1;
obs_info.mu_trajnoise     = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );
obs_info.mu_dtrajnoise    = @(traj,sigma) trajUnifNoiseMultiplicative( traj, sigma );

% Learning
learn_info.xi_solver_type = 'pinv';
basis_info.n              = ceil(sys_info.N * obs_info.L * obs_info.M * sys_info.d/500);            % number of basis functiosn for each (k1, k2) pair
basis_info.type           = 'standard';                                                             % basis type
basis_info.degree         = 1;                                                                      % polynomial degree
learn_info.Ebasis_info    = [];
learn_info.Abasis_info    = basis_info;
learn_info.Xibasis_info   = basis_info;

% package the data
Example.sys_info          = sys_info;
Example.solver_info       = solver_info;
Example.obs_info          = obs_info;
Example.learn_info        = learn_info;
end