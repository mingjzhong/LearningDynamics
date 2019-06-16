function [traj, dtraj, time_vec, Timings] = observe_dynamics( solution, obs_info )

% function [traj, time_vec, dtraj] = observe_dynamics( solution, obs_info )
%

% (c) Ming Zhong, Mauro Maggioni, JHU

Timings       = tic;

if ~isfield(obs_info,'time_vec') || isempty(obs_info.time_vec)
    if obs_info.L == 1
        obs_info.time_vec      = 0;                                                                 % when we only want one observation, we take the initial time
    else
        obs_info.time_vec      = linspace(0, obs_info.T_L, L);                                      % default to (equi-distance) times in [0,obs_info.T_L]
    end
else
    if length(obs_info.time_vec)~=obs_info.L
        fprintf('\n\tWarning:observe_dynamics:length of obs_info.timevec~=L. Using timevec.');
    end
end

try
    [traj, dtraj]   = deval( solution, obs_info.time_vec );                                         % find out the trajectory position and derivative at those time instances
    if isfield(obs_info,'obs_noise') && obs_info.obs_noise>0
        traj = obs_info.mu_trajnoise(traj,obs_info.obs_noise);
        dtraj= obs_info.mu_dtrajnoise(dtraj,obs_info.obs_noise);
    end
catch
    traj            = NaN;
    dtraj           = NaN;
end

time_vec    = obs_info.time_vec;

Timings     = toc(Timings);

return