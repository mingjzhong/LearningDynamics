function rhoT = generateRhoT( sys_info, solver_info, obs_info, reuse_flag )
%
% function rhoT = generateRhoT( sys_info, solver_info, obs_info )
%
% Construct an estimator for \rho^L_T, by running observations_info.M_rhoT trajectories of the system, 
% with obs_info.M_rho_T random initial conditions distributed according to system_info.mu0, and 
% returning the distribution of pairwise distances at L observation times that form an estimator of rhoLT
%
% IN: usual strutures defining the system, with obs_info.M_rhoT giving the number of MC simulations
%     to run, and reuse_flag==true meaning that the estimator will be loaded from file (default is
%     false).
%
% OUT:
%   rhoLT   : structure with an estimator of \rho_L^T, as defined in estimateRhoLT. Saves into outputs directory
%

% (c) M. Zhong, M. Maggioni (JHU)

if nargin<4, reuse_flag = false; end

VERBOSE        = obs_info.VERBOSE;
SAVE_DIR       = obs_info.SAVE_DIR;
filename       = sprintf('%s/%s_rhoT.mat',SAVE_DIR,sys_info.name);

if ~reuse_flag || ~exist(filename,'file')                                                           % compute estimator    
  tstart       = tic;                                                                               % generate observations
  obs_data     = generateObservations( sys_info, solver_info, obs_info, 'rhoT' );                   % estimate \rho_T
  rhoT         = estimateRhoT( obs_data, sys_info, obs_info );
  rhoT.Timings = toc(tstart);
  if VERBOSE>1,   fprintf('\n\tMC estimation of rhoT completed (%.2f seconds).', rhoT.Timings); end

%   if ~exist(sprintf('%s/outputs',SAVE_DIR),'dir') && ~exist(sprintf('%s/outputs',SAVE_DIR),'file'), mkdir(sprintf('%s/outputs',SAVE_DIR)); end                                               
  save(filename,  '-v7.3', 'sys_info', 'solver_info','obs_info','rhoT');    
else                                                                                                % load data
  if VERBOSE>1,   fprintf('\n\tgenerateRhoLT loading rhoT from file');   end
  load(filename,'sys_info', 'solver_info','obs_info','rhoT');
end

return