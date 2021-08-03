function Example = SynchronizedOscillatorDynamics_LC_def()
% function Example = SynchronizedOscillatorDynamics_LC_def()
% Define associated terms for FishSchoolDynamics

% System
sys_info.name            = 'SynchronizedOscillatorDynamics';
sys_info.d               = 2;                                                                       % the dimension for the opinion (state) vecor
sys_info.N               = 20;                                                                      % the number of agents
A                        = 1;
B                        = 1;
[name, J, K, S]          = SOD_get_params(1);                                                       % get static async
sys_info.phiE            = {@(r, s) SOD_phiE(r, s, A, B, J)};                                       % energy based influence
sys_info.V_map           = {{@(state_i, state_j) SOD_feature_map(state_i, state_j)}};                 % the total feature map for both phiE and phiXi
sys_info.V_dim           = 1;
sys_info.projE           = {1};
sys_info.phiXi           = {@(r, s) SOD_phiXi(r, s, K)};                                            % xi based interaction
sys_info.projXi          = {1};
sys_info.phiXi_weight    = false;
sys_info.K               = 1;                                                                       % number of classes
sys_info.ode_order       = 1;                                                                       % order of the ODE system
sys_info.type_info       = ones(1, sys_info.N);                                                     % class function mapping agent index to it class index
vi                       = [0; 0];
omegai                   = 0;
sys_info.Fx              = @(x, xi) SOD_Fx(sys_info.d, sys_info.N, vi);                             % non-collective change to x
sys_info.Fxi             = @(x, xi) SOD_Fxi(sys_info.N, omegai);                                    % non-collective change to xi
sys_info.has_noise       = false;                                                                   % no stochastic noise
sys_info.mu0             = @() SOD_init_config(sys_info.d, sys_info.N);                             % distribution of initial conditions
sys_info.T_f             = 20;                                                                      % the time for integration, t = T_f should be (most likely) for the system to reach steady state
sys_info.LC_type         = 'Synchronization';
sys_info.LC_subtype      = name;
sys_info.LC_S_score      = S;

% ODE solver
solver_info.time_span    = [0, sys_info.T_f];                                                       % put it into the time_span vector, always starting from 0
solver_info.rel_tol      = 1e-8;
solver_info.abs_tol      = 1e-11;

% Observations
obs_info.L               = 500;                                                                     % observe (equi-spaced) times
obs_info.M               = 1000;                                                                    % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT          = 2000;                                                                    % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_0             = 0;                                                                       % Observation time interval [T_0, T]
obs_info.T               = 4;                                                                       % Observation time interval [T_0, T]
obs_info.time_vec        = linspace(obs_info.T_0, obs_info.T, obs_info.L);                          % time instances at which discrete observation is made
obs_info.use_derivative  = true;                                                                    % indicator of the availability of derivative data
obs_info.hist_num_bins   = 1000;                                                                    % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise       = 0.0;
obs_info.mu_trajnoise    = @(traj,sigma) trajUnifNoiseMultiplicative(traj, sigma);
obs_info.mu_dtrajnoise   = @(traj,sigma) trajUnifNoiseMultiplicative(traj, sigma);

% Learning
degree                   = [1, 1];
type                     = {'PW-polynomial', 'PW-polynomial'};
sub_type                 = {'Standard', 'Standard'};
period                   = [Inf, Inf];
basis_info               = construct_basis_info(sys_info, obs_info, degree, type, sub_type, period);
learn_info.Ebasis_info   = basis_info;
learn_info.Xibasis_info  = basis_info;
learn_info.hist_num_bins = obs_info.hist_num_bins;

% package the data
Example.sys_info         = sys_info;
Example.solver_info      = solver_info;
Example.obs_info         = obs_info;
Example.learn_info       = learn_info;
end
