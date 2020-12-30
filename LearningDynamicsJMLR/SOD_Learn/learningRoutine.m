  function learn_out = learningRoutine( solver_info, obs_info, learn_info, obs_data )

%
% function learn_out = learningRoutine( solver_info, obs_info, learn_info, obs_data )
%

% IN: structures of parameters for the system, observations and learning.
%   [obs_data]  : use the given observations
%
% OUT: structure with learned system
% 

% (c) M. Maggioni, M. Zhong (JHU)

if nargin<4,    obs_data = [];  end

if ~isfield(learn_info,'VERBOSE'),        learn_info.VERBOSE       = 2;    end
if ~isfield(learn_info,'keep_obs_data') , learn_info.keep_obs_data = true; end

% Generate dynamics and observations
if learn_info.VERBOSE>1
    fprintf('\n--------------------------------------------------------------------------------');
    fprintf('\nGenerating %d trajectories with %d observations each...',obs_info.M,obs_info.L);
end

if isempty(obs_data) || isempty(obs_data.x)
    obs_data                =  generateObservations( learn_info.sys_info, solver_info, obs_info, obs_info.M, obs_data );
    
    if learn_info.VERBOSE>1,   fprintf('done (%.2f sec).',obs_data.Timings.total); end
end

% Learn the dynamics from observations
if learn_info.VERBOSE>1
    fprintf('\n--------------------------------------------------------------------------------');
    fprintf('\nLearning...');
end

learn_out                             = learn_from_dynamics( learn_info.sys_info,obs_info,learn_info, obs_data );

learn_out.rhoLTemp                    = estimateRhoLT( obs_data, learn_info.sys_info, obs_info );

if learn_info.VERBOSE>1
    fprintf('done (%6.2f sec).',learn_out.Timings.total);
end
if learn_info.VERBOSE>=1
    fprintf('\nThe empirical error from learning phis on x/v is: %10.4e.',                                   learn_out.Estimator.emp_err);
    if ~isempty(learn_out.Estimator.emp_err_xi), fprintf('\nThe empirical error from learning phis on xi is: %10.4e.', learn_out.Estimator.emp_err_xi); end
end

%% Measure performance in terms of the L2_rho norm
if learn_info.VERBOSE >= 1
    fprintf('\n--------------------------------------------------------------------------------');
    fprintf('\nComputing L^2(rho^L_T) accuracy of estimator...');
end

%% Regularize interaction(s) and compute relative errors
if ~isempty(learn_out.Estimator.phiEhat)
    learn_out                           = regularize_and_computer_relative_error(learn_out, learn_info, obs_info, 'energy');
else
    learn_out.Estimator.phiEhatsmooth   = []; learn_out.Estimator.Ebasis2  = []; learn_out.EErr  = []; learn_out.EErrSmooth  = [];
end
if ~isempty(learn_out.Estimator.phiAhat)
    learn_out                           = regularize_and_computer_relative_error(learn_out, learn_info, obs_info, 'alignment');
else
    learn_out.Estimator.phiAhatsmooth   = []; learn_out.Estimator.Abasis2  = []; learn_out.AErr  = []; learn_out.AErrSmooth  = [];
end
if ~isempty(learn_out.Estimator.phiXihat)
    learn_out                           = regularize_and_computer_relative_error(learn_out, learn_info, obs_info, 'xi');
else
    learn_out.Estimator.phiXihatsmooth  = []; learn_out.Estimator.Xibasis2 = []; learn_out.XiErr = []; learn_out.XiErrSmooth = [];
end

%% Package outputs
syshat_info                     = learn_info.sys_info;
syshat_info.phiE                = learn_out.Estimator.phiEhat;
syshat_info.phiA                = learn_out.Estimator.phiAhat;
syshat_info.phiXi               = learn_out.Estimator.phiXihat;
learn_out.syshat_info           = syshat_info;

syshatsmooth_info               = learn_info.sys_info;
syshatsmooth_info.phiE          = learn_out.Estimator.phiEhatsmooth;
syshatsmooth_info.phiA          = learn_out.Estimator.phiAhatsmooth;
syshatsmooth_info.phiXi         = learn_out.Estimator.phiXihatsmooth;
learn_out.syshatsmooth_info     = syshatsmooth_info;

if learn_info.keep_obs_data
    learn_out.obs_data          = obs_data;
else
    learn_out.obs_data.Timings  = obs_data.Timings;
end

return