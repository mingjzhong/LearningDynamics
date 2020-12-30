function [trajErr,trajErr_new] = estimateTrajAccuracies( sys_info, syshat_info, obs_data, obs_info, solver_info )

% function ETA_result = estimateTrajAccuracies( sys_info, syshat_info, obs_data, obs_info, solver_info )
%
% (c) M. Zhong, M. Maggioni, JHU
                
% Measure the performance in terms of errors on trajectories from the same initial conditions as training
trajErr                 = computeTrajectoryAccuracy( sys_info, syshat_info, solver_info, obs_info, obs_data.ICs );
% Measure the performance in terms of errors on trajectories from new initial conditions
y_init_new              = generateICs( obs_info.M_test, sys_info );                                              
trajErr_new             = computeTrajectoryAccuracy( sys_info, syshat_info, solver_info, obs_info, y_init_new ); 

return