function PT_neighbors()
%
% Input:
%   none
% Output:
%   none

% Ming Zhong
% Version: 1.0.0

% set up the parameters for the test
I_0                              = 1;
% use a pre-set set of parameters for SOD simulation
sod_params                       = sod_params_set();
% unpack the parameters
% information on how to integrate the ODE from SOD
integrator_info                  = sod_params{1};
% information about the system
system_info                      = sod_params{2};
% the final time for the simulation    
T_f                              = 0.5;
% pick the interaction kernals for both v and xi interactions
phi_kind                         = 22;
param.beta                       = 0.25;
align_interactions               = @(r) scaled_influence(r, phi_kind, ...
param);
param.beta                       = 0.25;
xi_interactions                  = @(r) scaled_influence(r, phi_kind, ...
param);
%
system_info.align_interactions   = {align_interactions};
system_info.phiE  = [];
system_info.scaling              = 1;
system_info.xi_interactions      = {xi_interactions};
system_info.ode_order            = 2;
system_info.model                = 'Phototaxis';
% the dimension for the opinion (state) vecor
d                                = 2;
% the number of agents
N                                = 200;
%
v_terminal                       = [60; 0];
lambda_1                         = N;
lambda_2                         = N;
% generate the initial distrubtion in a hyper cube: [O, L]^d
L                                = 100;
x_init                           = L * rand(d, N);
v_init                           = L * rand(d, N);
L                                = 0.001;
xi_init                          = L * rand(N, 1);
% set up the initial configuration for x (the position), v (the velocity)
% and xi (the excitation)
y_initial                        = zeros(N * (2 * d + 1), 1);
y_initial(1 : d * N)             = reshape(x_init, [d * N, 1]);
y_initial(d * N + 1 : 2 * d * N) = reshape(v_init, [d * N, 1]);
y_initial(2 * d * N + 1 : end)   = xi_init;
% set up the critical exciation level (for light effect to activate in
% velocity)
xi_critical                      = 0.3;
% set up the capacity excitation level (for light effect to decay in
% excitation)
xi_capacity                      = 2 * xi_critical;
% calculate the number of time steps
m                                = 1000;
% do not use adaptive step size control
is_adaptive                      = 0;
% the range to plot the phi   
ranges                           = zeros(2, 1, 1, 2);
% only put the phi on [0, 4]   
ranges(1, 1, 1, :)               = [0, 8];
ranges(2, 1, 1, :)               = [0, 8];
% the name for the phi on plot   
v_names                          = {'Phototaxis - Velocity'};
xi_names                         = {'Phototaxis - Excitation'};
interation_file_names            = {'velocity', 'excitation'};
% save it in a movie
movie_flag                       = 0;
% change some of the parameters based on the user input
% end time of the simulation
integrator_info.final_time       = T_f;
%
integrator_info.num_time_steps   = m;
% 
integrator_info.is_adaptive      = is_adaptive;
% the size of the state vectors
system_info.d           = d;
% the number of agents
system_info.N          = N;
% 
system_info.init_config            = y_initial;
% store it in the system_info structure
system_info.v_kappa                = lambda_1;
system_info.xi_kappa               = lambda_2;
system_info.agent_mass             = ones(N, 1);
model_info.light_intensity         = I_0;
model_info.v_terminal              = v_terminal;
model_info.xi_capacity             = xi_capacity;
model_info.xi_critical             = xi_critical;
model_info.smooth_cutoff           = @(xi, cutoff) smooth_cutoff(xi, cutoff);
model_info.sub_type                = 2;
radius                             = 0.2;
model_info.neighbor_func           = @(x) find_neighbors(x, d, N, radius);
system_info.has_xi                 = 1;
movie_name                         = sprintf(['phototaxis_light_%s_' ...
'type_%d'], I_0);
system_info.model_info              = model_info;
% 
fprintf('Testing I_0 = %.2f.\n', I_0);
% time the performance, set up the starting time
tstart                           = tic;
% run the simulation
[trajectories, time_vec]         = self_organized_dynamics(system_info, ...
integrator_info);
% print out the length of time to run the simulation   
fprintf('It takes %5.1f seconds to run the simulation.\n', toc(tstart));
%
plot_info.to_plot_interactions = 0;
plot_info.to_plot_trajectory   = 1;
plot_info.ranges               = ranges;
plot_info.v_names              = v_names;
plot_info.xi_names             = xi_names;
plot_info.to_save_interactions = 1;
plot_info.interation_file_names = interation_file_names;
plot_info.movie_flag           = movie_flag;
plot_info.movie_name           = movie_name;
plot_info.xi_capacity          = xi_capacity;
plot_info.xi_critical          = xi_critical;
plot_info.light_intensity      = I_0;
plot_bacteria(trajectories, time_vec, system_info, plot_info);
return