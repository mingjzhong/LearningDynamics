function obs_data = generateObservations( sys_info, solver_info, obs_info, M, obs_data )

%
% function obs_data = generateObservations( sys_info, solver_info, obs_info )
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
%               obs_data    : data structure with following fierivatives
%       Timings             : timing informationelds:
%       nFail               : how many times the integrator failed to generate a trajectory
%       traj                : M' x 1 cell for M' of trajectories, that may be evaluated at any point
%       x                   : (d*n) x L x M' tensor of state configurations. M' is M-nFail.
%       xp                  : (d*n) x L x M' tensor of d
%

% (c) M. Zhong, M. Maggioni, JHU

obs_data.Timings.total          = tic;

if nargin<4 || isempty(M), M    = obs_info.M;   end

comp_ICs                        = ~isfield(obs_data,'ICs') || isempty(obs_data.ICs);
comp_traj                       = ~isfield(obs_data,'traj') || isempty(obs_data.traj);

statesp_size                    = sys_info.d * sys_info.N;
if sys_info.ode_order == 1
  x_obs                         = zeros(statesp_size, obs_info.L, M);  
elseif sys_info.ode_order == 2
  if sys_info.has_xi
    x_obs                       = zeros(2 * statesp_size + sys_info.N, obs_info.L, M);
  else
    x_obs                       = zeros(2 * statesp_size, obs_info.L, M);
  end
end

if obs_info.use_derivative
  if sys_info.ode_order == 1
    xp_obs                      = zeros(statesp_size, obs_info.L, M);  
  elseif sys_info.ode_order == 2
    if sys_info.has_xi
      xp_obs                    = zeros(2 * statesp_size + sys_info.N, obs_info.L, M);
    else
      xp_obs                    = zeros(2 * statesp_size, obs_info.L, M);
    end
  end                
end

flag                            = zeros(1,M,'logical');

if comp_ICs
    obs_data.Timings.ICs        = tic;
    ICs                         = generateICs( M, sys_info );                                       % draw initial conditions
    obs_data.Timings.ICs        = toc(obs_data.Timings.ICs);
else
    ICs                         = obs_data.ICs;
end

Timingsobsdynamics              = zeros(M,1);

if ~comp_traj,          traj    = obs_data.traj;                                    
else,                   traj    = cell(M,1);                                                    end

parfor m = 1:M
    if comp_traj,   traj{m}     = self_organized_dynamics (ICs(:,m), sys_info, solver_info);    end % run the dynamics    
    
    flag(m)                     = traj{m}.flag;
    if flag(m),                   continue;                                                     end
    
    [x_obs(:, :, m),dobstraj,~,Timingsobsdynamics(m)] = observe_dynamics( traj{m}, obs_info );      % extract observations from trajectories stopping at T_L
    
    if obs_info.use_derivative, xp_obs(:, :, m) = dobstraj;                                     end
end

obs_data.nFail                  = sum(flag);                                                        % package return data
obs_data.ICs_fail               = ICs(flag);
ICs(:,flag)                     = [];
obs_data.ICs                    = ICs;
traj(flag)                      = [];                                                               % remove failed trajectories
obs_data.traj                   = traj;
x_obs(:,:,flag)                 = [];
obs_data.x                      = x_obs;
if obs_info.use_derivative
    obs_data.xp                 = xp_obs;
    obs_data.xp(:,:,flag)       = [];
end

obs_data.Timings.obsdynamics    = Timingsobsdynamics;
obs_data.Timings.total          = toc(obs_data.Timings.total);

return