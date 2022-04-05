function Example = Gravitation_LC_def()
% function Example = Gravitation_PF_def()
% Define associated terms for GRAVITATION

% System
sys_info.name               = 'Gravitation';
sys_info.d                  = 2;                                                                    % the dimension for the opinion (state) vecor
% names of the Astronomical Objects (AO) in our Solar system
AO_names                    = {'Sun',   'Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'}; 
% NASA data, in unit: 10^24 kg
AO_mass                     = [1.9885e6,    0.330,    4.87,    5.97,  0.642,      1898,      568,     86.8,       102, 0.0146];  
% NASA data, in unit: 10^6 km
perihelions                 = [0,            46.0,   107.5,   147.1,  206.6,     740.5,   1352.6,   2741.3,    4444.5, 4436.8];  
% NASA data, in unit: 10^6 km
aphelions                   = [0,            69.8,   108.9,   152.1,  249.2,     816.6,   1514.5,   3003.6,    4545.7, 7375.9];  
% NASA data, in unit: day
orbitalPeriods              = [0,            88.0,   224.7,   365.2,  687.0,      4331,    10747,   30688.5,    60182,  90560];  
% NASA data, in unit: 10^6 km/day
orbitalSpeeds               = [0,            47.4,      35,    29.8,   24.1,      13.1,      9.7,      6.8,       5.4,    4.7] * 8.64e-2;  
selection_idx               = [1, 2, 3, 4, 5];                                                      % choose the indices of wanted planets (Sun is always included)
sys_info.selection_idx      = selection_idx;
sys_info.AO_names           = AO_names(selection_idx);
sys_info.N                  = length(selection_idx);
sys_info.known_mass         = AO_mass(selection_idx);
sys_info.K                  = sys_info.N;                                                           % different tpyes of agents
sys_info.G                  = 8.64^2 * 6.67408e-6;                                                  % normalized to (10^6 km)^3/(10^24 kg * (day)^3)
sys_info.c                  = 2.99792458 * 8.64e3;                                                  % speed of light in unit: 10^6 km/day
sys_info.perihelions        = perihelions(selection_idx);
sys_info.aphelions          = aphelions(selection_idx);
sys_info.orbitalPeriods     = orbitalPeriods(selection_idx);
sys_info.orbitalSpeeds      = orbitalSpeeds(selection_idx);
sys_info.agent_mass         = ones(sys_info.N, 1);
sys_info.phiE               = cell(sys_info.N);
for k1 = 1 : sys_info.N
  for k2 = 1 : sys_info.N
% to turn off planet on planet interactions: (k1 == 1 && k2 > 1) || (k1 > 1 && k2 == 1)    
    if k1 ~= k2 
      sys_info.phiE{k1, k2} = @(r) gravity_phiE(r, sys_info.known_mass(k2), sys_info.G);            % parametrized gravitation
    else
      sys_info.phiE{k1, k2} = @(r) zeros(size(r));
    end
  end
end
sys_info.ode_order          = 2;                                                                    % order of the ODE system
sys_info.type_info          = 1 : sys_info.K;                                                       % class function mapping agent index to it class index
sys_info.has_noise          = false;                                                                % no stochastic noise
sys_info.mu0                = @() gravitation_init_config(sys_info.d, sys_info.N, sys_info.known_mass(1), ...
                              sys_info.G, sys_info.aphelions, sys_info.perihelions);                % distribution of initial conditions
sys_info.T_f                = orbitalPeriods(4) * 2;                                                % 2 Earth years  
sys_info.LC_type            = 'Concentric';

% ODE solver
solver_info.solver          = '15s';                                                                % use ode15s as the integrator, due to stiffness of the system
solver_info.time_span       = [0, sys_info.T_f];                                                    % put it into the time_span vector, always starting from 0
solver_info.rel_tol         = 1.0e-8;                                                               % the relative tolerance for adaptive integration
solver_info.abs_tol         = 1.0e-11;                                                              % the absolute tolerance for adaptive integration

% Observations
obs_info.L                  = 500;                                                                  % observe (equi-spaced) times
obs_info.M                  = 500;                                                                  % # trajectories with random initial conditions for learning interaction kernel
obs_info.M_rhoT             = 2000;                                                                 % # trajectories with random initial conditions to compute approximate \rho_T
obs_info.T_0                = 0;                                                                    % Observation time interval [T_0, T]
obs_info.T                  = orbitalPeriods(4)/2;                                                  % Observation time interval [T_0, T]
obs_info.time_vec           = linspace(obs_info.T_0, obs_info.T, obs_info.L);                       % time instances at which discrete observation is made
obs_info.use_derivative     = true;                                                                 % indicator of the availability of derivative data
obs_info.hist_num_bins      = 1000;                                                                 % number of bins for estimating \rho^L_T for all three different interactions
obs_info.obs_noise          = 0.0;
obs_info.mu_trajnoise       = @(traj,sigma) trajUnifNoiseMultiplicative(traj, sigma);
obs_info.mu_dtrajnoise      = @(traj,sigma) trajUnifNoiseMultiplicative(traj, sigma);

% Learning
degree                      = 1;
type                        = {'B-spline'};
sub_type                    = {'Clamped'};
basis_info                  = construct_basis_info(sys_info, obs_info, degree, type, sub_type);
learn_info.Ebasis_info      = basis_info;                                                           % basis info. for Ebasis
learn_info.Abasis_info      = [];                                                                   % basis info. for Abasis
learn_info.hist_num_bins    = obs_info.hist_num_bins;                                               % number of bins for estimating \rho_T^{L, M} for all three different interactions

% package the data
Example.sys_info            = sys_info;
Example.solver_info         = solver_info;
Example.obs_info            = obs_info;
Example.learn_info          = learn_info;
end