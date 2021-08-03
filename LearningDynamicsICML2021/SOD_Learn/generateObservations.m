function obs_data = generateObservations(sys_info, solver_info, obs_info, M, obs_data)
% function obs_data = generateObservations(sys_info, solver_info, obs_info, M, obs_data)
%
% Generates trajectories from random initial conditions (as per sys_info) and returns observations
%   at specified times as per obs_info.
%
% IN : usual data structures with system, solver and observation info.
%       [M]     : Defaults to obs_info.M; otherwise number of trajectories to run (from M randomly
%                   drawn initial conditions (distributed as per sys_info.mu0)
%       [obs_data]  : When provided, if it contains ICs, this function will use those ICs,
%                       if it contains traj, this function will use those trajs.
%
% OUT:
%   obs_data    : data structure with following fields:
%       nFail               : how many times the integrator failed to generate a trajectory
%       traj                : M' x 1 cell for M' of trajectories, that may be evaluated at any point
%       x                   : (d*n) x L x M' tensor of state configurations. M' is M-nFail.
%       xp                  : (d*n) x L x M' tensor of derivatives
%       Timings             : timing information
%

% (c) M. Zhong, M. Maggioni, JHU

obs_data.Timings.total          = tic;

if nargin<4 || isempty(M), M    = obs_info.M;   end

comp_ICs                        = ~isfield(obs_data,'ICs') || isempty(obs_data.ICs);
comp_dyn                        = ~isfield(obs_data,'dyn') || isempty(obs_data.dyn);

sys_var_len                     = calculate_sys_var_len(sys_info);
y_obs                           = zeros(sys_var_len, obs_info.L, M);
if obs_info.use_derivative
  dy_obs                        = zeros(sys_var_len, obs_info.L, M);
end

flag                            = zeros(1, M, 'logical');

if comp_ICs
    obs_data.Timings.ICs        = tic;
    ICs                         = generateICs( M, sys_info );                                       % draw initial conditions
    obs_data.Timings.ICs        = toc(obs_data.Timings.ICs);
else
    ICs                         = obs_data.ICs;
end

Timingsobsdynamics              = zeros(M,1);

if ~comp_dyn, dyn = obs_data.dyn; else, dyn = cell(M, 1); end

parfor m = 1:M
  if comp_dyn, dyn{m} = self_organized_dynamics (ICs(:, m), sys_info, solver_info); end             % run the dynamics    
  flag(m)                     = dyn{m}.flag;
  if flag(m), continue; end
  [y_obs(:, :, m), dtraj, ~, Timingsobsdynamics(m)] = observe_dynamics(dyn{m}, obs_info);           % extract observations from trajectories stopping at T_L
  if obs_info.use_derivative, dy_obs(:, :, m) = dtraj; end
end

obs_data.nFail                  = sum(flag);                                                        % package return data
obs_data.ICs_fail               = ICs(flag);
ICs(:, flag)                    = [];
obs_data.ICs                    = ICs;
dyn(flag)                      = [];                                                                % remove failed trajectories
obs_data.traj                   = dyn;
y_obs(:,:,flag)                 = [];
obs_data.y                      = y_obs;
if obs_info.use_derivative
    obs_data.dy                 = dy_obs;
    obs_data.dy(:, :, flag)     = [];
else
  obs_data.dy                   = [];
end

obs_data.Timings.obsdynamics    = Timingsobsdynamics;
obs_data.Timings.total          = toc(obs_data.Timings.total);
end