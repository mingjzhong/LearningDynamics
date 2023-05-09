function [trajErr, trajErr_new, trajErr_Ntransfer, syshat_info_Ntransfer] = estimateTrajAccuracies(...
          sys_info, syshat_info, sys_info_Ntransfer, y_train, y_new, obs_info, solver_info, ...
          find_LC)
% function [trajErr, trajErr_new, trajErr_Ntransfer, syshat_info_Ntransfer] = estimateTrajAccuracies(...
%           sys_info, syshat_info, sys_info_Ntransfer, obs_data, obs_data_new, obs_info, solver_info, ...
%           find_LC)

% (c) M. Zhong (JHU)

% trajectory-error performance measured from the same initial conditions as training
trajErr                 = computeTrajErr(y_train, sys_info, syshat_info, solver_info, obs_info, ...
                          find_LC);
% trajectory-error performance measured from new initial conditions  
if ~isempty(y_new)
   trajErr_new          = computeTrajErr(y_new, sys_info, syshat_info, solver_info, obs_info, ...
                          find_LC); 
else
  trajErr_new           = trajErr;  
end
% trajectory-error performance measured from system with larger N
if ~isempty(sys_info_Ntransfer)
  syshat_info_Ntransfer = restructure_sys_info_for_larger_N(obs_info.N_ratio, syshat_info);
  y_init_Ntransfer      = generateICs(obs_info.M, sys_info_Ntransfer);
  trajErr_Ntransfer     = computeTrajErr(y_init_Ntransfer, sys_info_Ntransfer, syshat_info_Ntransfer, ...
                          solver_info, obs_info, find_LC); 
else
  syshat_info_Ntransfer = []; 
  trajErr_Ntransfer     = []; 
end
end