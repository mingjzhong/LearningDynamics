function [trajErr, trajErr_new, y_init_new, trajErr_Ntransfer, y_init_Ntransfer, syshat_info_Ntransfer] = ...
         estimateTrajAccuracies(sys_info, syshat_info, obs_data, obs_info, solver_info, sys_info_Ntransfer)
% function ETA_result = estimateTrajAccuracies( sys_info, syshat_info, obs_data, obs_info, solver_info, sys_info_Ntransfer)
%
% (c) M. Zhong (JHU)
                
% do an input parameter list check
if nargin < 6, sys_info_Ntransfer = []; end
% Measure the performance in terms of errors on trajectories from the same initial conditions as training
trajErr                 = computeTrajErr(sys_info, syshat_info, solver_info, obs_info, obs_data.ICs);
% Measure the performance in terms of errors on trajectories from new initial conditions
y_init_new              = generateICs(obs_info.M, sys_info);                                              
trajErr_new             = computeTrajErr(sys_info, syshat_info, solver_info, obs_info, y_init_new); 
% Measure the performance in terms of errors on trajectories from systems with larger N
if ~isempty(sys_info_Ntransfer)
  syshat_info_Ntransfer = restructure_sys_info_for_larger_N(obs_info.N_ratio, syshat_info);
  y_init_Ntransfer      = generateICs(obs_info.M, sys_info_Ntransfer);
  trajErr_Ntransfer     = computeTrajErr(sys_info_Ntransfer, syshat_info_Ntransfer, solver_info, obs_info, y_init_Ntransfer); 
else
  syshat_info_Ntransfer = []; y_init_Ntransfer = []; trajErr_Ntransfer = []; 
end
end