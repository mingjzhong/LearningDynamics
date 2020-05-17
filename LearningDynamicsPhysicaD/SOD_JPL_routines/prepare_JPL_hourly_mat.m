% function prepare_JPL_hourly_mat()
% function prepare_JPL_hourly_mat()

% (C) M. Zhong

% Load the gravity horly data
load_time                          = tic;
selection_idx                      = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];                                    
total_num_years                    = 400;                                                                
num_years                          = 400;                                                            
data_kind                          = 3;                                                                  
use_v                              = true;                                                               
[Example, obs_data]                = Gravitation_JPL_def(selection_idx, num_years, ...
                                     total_num_years, use_v, data_kind);
sys_info                           = Example.sys_info;
solver_info                        = Example.solver_info;
oneBlock                           = sys_info.d * sys_info.N;
fprintf('\nIt takes %6.2f secs to load the data.', toc(load_time));

% turn on parallel for calculating acceleration in parallel
JPL_time                           = tic;
time_out                           = 60;
num_workers                        = feature('numcores');                                           % actual physical cores
pool                               = gcp('nocreate');
if isempty(pool)
  pool                             = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                                     'SpmdEnabled', true);
else
  if pool.NumWorkers ~= num_workers || pool.IdleTimeout ~= time_out || ~pool.SpmdEnabled
    pool                           = parpool('local', num_workers, 'IdleTimeout', time_out, ...
                                     'SpmdEnabled', true);  
  end
end
fprintf('\nThere are %d workers in the pool.', pool.NumWorkers);
fprintf('\nThe idel timeout is %d minutes.',   pool.IdleTimeout);
fprintf('\nSPMD is enabled?: %s.',             mat2str(pool.SpmdEnabled));
% retrieve the JPL hourly data from obs_data
x_JPL                              = obs_data.y(1 : oneBlock, :);
v_JPL                              = obs_data.y(oneBlock + 1 : 2 * oneBlock, :);
time_vec                           = obs_data.time_vec;
a_JPL_hourly                       = approximate_derivative(v_JPL, time_vec, 1);
a_JPL_minutely                     = obs_data.dy(oneBlock + 1 : 2 * oneBlock, :);
rel_tol                            = 1e-13;
abs_tol                            = 1e-16;
a_EIH                              = compute_JPL_EIH_acceleration(x_JPL, v_JPL, a_JPL_minutely, ...
                                     time_vec, rel_tol, abs_tol, sys_info);
a_Newton                           = compute_JPL_Newton_acceleration(x_JPL, sys_info);
PI_JPL                             = get_JPL_planet_information_over_time(x_JPL, time_vec, sys_info);
fprintf('\nThe Precession Rate of Mercury is: %6.2f arc-second per 100 Earth-year.', PI_JPL(1, 4, 1));
fprintf('\nIt takes %6.2f secs to finish preparing the JPL data.', toc(JPL_time));

% calculate the EIH hourly data
EIH_time                           = tic;
y0                                 = [x_JPL(:, 1); v_JPL(:, 1)];
yp0                                = [v_JPL(:, 1); a_EIH(:, 1)];
t0                                 = time_vec(1);
ode_opts                           = odeset('RelTol', rel_tol, 'AbsTol', abs_tol);                  
EIH_ode                            = @(t, y, yp) get_JPL_EIH_RHS(y, yp, sys_info);
% improve it further with decic
[~, yp0]                           = decic(EIH_ode, t0, y0, true(size(y0)), yp0, ...
                                     false(size(yp0)), ode_opts);
dyn_EIH                            = ode15i(EIH_ode, solver_info.time_span, y0, yp0, ode_opts);
[y, yp]                            = dense_output(dyn_EIH, time_vec);
x_EIH                              = y(1 : oneBlock, :);
v_EIH                              = y(oneBlock + 1 : 2 * oneBlock, :);
a_EIH_true                         = yp(oneBlock + 1 : 2 * oneBlock, :);
PI_EIH                             = get_JPL_planet_information_over_time(x_EIH, time_vec, sys_info);
fprintf('\nThe Precession Rate of Mercury is: %6.2f arc-second per 100 Earth-year.', PI_EIH(1, 4, 1));
fprintf('\nIt takes %6.2f secs to finish preparing the EIH data.', toc(EIH_time));

% calculate the Newton Hourly data
Newton_time                        = tic;
sys_info_Newton                    = sys_info;
for k1 = 1 : sys_info.N
  for k2 = 1 : sys_info.N
    if k1 == k2
      sys_info_Newton.phiE{k1, k2} = @(r) zeros(size(r, 1), size(r, 2));
    else
      sys_info_Newton.phiE{k1, k2} = @(r) sys_info_Newton.G * sys_info_Newton.known_mass(k2) ...
                                     * r.^(-3);
    end
  end
end
solver_info.rel_tol                = rel_tol;
solver_info.abs_tol                = abs_tol;
dyn_Newton                         = self_organized_dynamics(y0, sys_info_Newton, solver_info);
[y, yp]                            = dense_output(dyn_Newton, time_vec);
x_Newton                           = y(1 : oneBlock, :);
v_Newton                           = y(oneBlock + 1 : 2 * oneBlock, :);
a_Newton_true                      = yp(oneBlock + 1 : 2 * oneBlock, :);
PI_Newton                          = get_JPL_planet_information_over_time(x_Newton, time_vec, ...
                                     sys_info_Newton);
fprintf('\nThe Precession Rate of Mercury is: %6.2f arc-second per 100 Earth-year.', ...
  PI_Newton(1, 4, 1));
fprintf('\nIt takes %6.2f secs to finish preparing the Newton data.', toc(Newton_time));

% save the results
save_time                          = tic;
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                                                  
time_stamp                         = datestr(now, 30);
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end
save_file                          = sprintf('%s/JPL_hdata_%s.mat', SAVE_DIR, time_stamp);
save(save_file, '-v7.3', 'Example', 'x_JPL', 'v_JPL', 'a_JPL_hourly', 'a_JPL_minutely', ...
  'a_EIH', 'a_Newton', 'time_vec', 'PI_JPL');
fprintf('\nIt takes %6.2f secs to save the JPL data.', toc(save_time));
save_time                          = tic;
save_file                          = sprintf('%s/EIH_hdata_%s.mat', SAVE_DIR, time_stamp);
save(save_file, '-v7.3', 'ode_opts', 'EIH_ode', 'dyn_EIH', 'x_EIH', 'v_EIH', 'a_EIH_true', ...
  'time_vec', 'PI_EIH');
fprintf('\nIt takes %6.2f secs to save the EIH data.', toc(save_time));
save_time                          = tic;
save_file                          = sprintf('%s/Newton_hdata_%s.mat', SAVE_DIR, time_stamp);
save(save_file, '-v7.3', 'sys_info_Newton', 'solver_info', 'dyn_Newton', 'x_Newton', 'v_Newton', ...
  'a_Newton_true', 'time_vec', 'PI_Newton');
fprintf('\nIt takes %6.2f secs to save to the Newton data.', toc(save_time));
return