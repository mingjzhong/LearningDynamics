function [rhoLT, obs_data] = generateRhoLT(sys_info, solver_info, obs_info, reuse_flag)
% function [rhoLT, obs_data] = generateRhoLT(sys_info, solver_info, obs_info, reuse_flag)
%
% Construct an estimator for \rho^L_T, by running observations_info.M_rhoLT  trajectories of the system,
% with obs_info.M_rho_T random initial conditions distributed according to system_info.mu0, and
% returning the distribution of pairwise distances at L observation times that form an estimator of rhoLT
%
% IN: usual strutures defining the system, with obs_info.M_rhoLT  giving the number of MC simulations
%     to run, and reuse_flag==true meaning that the estimator will be loaded from file (default is
%     false).
%
% OUT:
%   rhoLT    : structure with an estimator of \rho_L^T, as defined in estimateRhoLT. Saves into outputs directory
%

% (c) M. Zhong, M. Maggioni (JHU)

if nargin < 4, reuse_flag = false; end
VERBOSE                    = obs_info.VERBOSE;
SAVE_DIR                   = obs_info.SAVE_DIR;
filename                   = sprintf('%s/%s_rhoT.mat', SAVE_DIR, sys_info.name);
if ~reuse_flag || ~exist(filename, 'file')                                                          % compute estimator                                                                   % generate observations
  solver_info.time_span(2) = obs_info.T;                                                            % only simulate to [0, T]
  obs_data                 = generateObservations(sys_info, solver_info, obs_info, obs_info.M_rhoT);% estimate \rho_T
  rhoLT                    = estimateRhoLT(obs_data, sys_info, obs_info);
  if ~exist(sprintf('%s',SAVE_DIR),'dir'),    mkdir(sprintf('%s',SAVE_DIR)); end
  if reuse_flag, save(filename,  '-v7.3', 'rhoLT'); end
else                                                                                                % load data
  if VERBOSE > 1, fprintf('\n\tgenerateRhoLT loading rhoLT  from file');   end
  load(filename, 'rhoLT');
end
end