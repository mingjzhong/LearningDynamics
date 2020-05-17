function [trajErr, trajErr_new, trajErr_Ntransfer, syshat_info_Ntransfer] ...
                        = estimateTrajAccuracies(sys_info, syshat_info, sys_info_Ntransfer, ...
                          y_init_training, obs_info, solver_info, find_LC)
% function [trajErr, trajErr_new, trajErr_Ntransfer] = estimateTrajAccuracies(sys_info, syshat_info, ...
%          ICs, obs_info, solver_info, sys_info_Ntransfer)

% (c) M. Zhong (JHU)
                
% Measure the performance in terms of errors on trajectories from the same initial conditions as training
trajErr                 = computeTrajErr(y_init_training, sys_info, syshat_info, solver_info, ...
                          obs_info, find_LC);
% Measure the performance in terms of errors on trajectories from new initial conditions
y_init_new              = generateICs(obs_info.M, sys_info);                                              
trajErr_new             = computeTrajErr(y_init_new, sys_info, syshat_info, solver_info, obs_info, ...
                          find_LC); 
% Measure the performance in terms of errors on trajectories from systems with larger N
if ~isempty(sys_info_Ntransfer)
  syshat_info_Ntransfer = restructure_sys_info_for_larger_N(obs_info.N_ratio, syshat_info);
  y_init_Ntransfer      = generateICs(obs_info.M, sys_info_Ntransfer);
  trajErr_Ntransfer     = computeTrajErr(y_init_Ntransfer, sys_info_Ntransfer, syshat_info_Ntransfer, ...
                          solver_info, obs_info, find_LC); 
else
  syshat_info_Ntransfer = []; trajErr_Ntransfer = []; 
end
end