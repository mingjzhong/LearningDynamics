function traj_data = get_traj_data_from_scratch(learningOutput, sys_info, syshat_info, ...
                     sys_info_Ntransfer, plot_info)
% function traj_data = get_traj_data_from_scratch(learningOutput, sys_info, syshat_info, ...
%                      sys_info_Ntransferplot_info)

% (C) M. Zhong

% initialize
if ~isempty(sys_info_Ntransfer), num_trajs = 6; else, num_trajs  = 4; end
trajs                = cell(1, num_trajs); 
dtrajs               = cell(1, num_trajs);
% use xi when there is xi information
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  phases             = cell(1, num_trajs);
else
  phases             = [];
end
result               = construct_and_compute_traj(learningOutput.trajErr, sys_info, syshat_info, plot_info);
trajs{1}             = result.traj_true;
dtrajs{1}            = result.dtraj_true;
trajs{2}             = result.traj_hat;
dtrajs{2}            = result.dtraj_hat;
time_vec             = result.time_vec;
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  phases{1}          = result.xi_true;
  phases{2}          = result.xi_hat;
end
% if isfield(obs_info, 'obs_noise') && obs_info.obs_noise > 0
%  error('SOD_Utils:visualize_trajs:exception', 'Noisy Observation data is not implemented yet!!');  % retrieve the noisy data from saved data file
%   traj_noise         = squeeze(learningOutput{1}.obs_data.x(1 : sys_info.d * sys_info.N, :, result.m));    
%   scr_pos            = plot_info.scr_pos;
%   scr_pos(1)         = scr_pos(1) + num_figs * plot_info.scr_xgap;
%   traj_fig           = figure('Name', sprintf('Trajs (%dD): True vs. Learned', sys_info.d), 'NumberTitle', 'off', 'Position', scr_pos);
%   if sys_info.d == 1    
%     visualize_traj_1D_wnoise(traj_fig, traj_noise, result.traj_true, result.traj_hat, time_vec, sys_info, obs_info, plot_info);
%   else
%     visualize_traj_multiD_wnoise(traj_fig, traj_noise, result.traj_true, result.traj_hat, time_vec, sys_info, obs_info, plot_info); 
%   end
%   num_figs           = num_figs + 1;
% end
% randomly pick another initial data
result               = construct_and_compute_traj(learningOutput.trajErr_new, sys_info, syshat_info, plot_info);
trajs{3}             = result.traj_true;
dtrajs{3}            = result.dtraj_true;
trajs{4}             = result.traj_hat;
dtrajs{4}            = result.dtraj_hat;
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  phases{3}          = result.xi_true;
  phases{4}          = result.xi_hat;
end
% randomly pick another initial data for larger N
if ~isempty(sys_info_Ntransfer)
  result             = construct_and_compute_traj(learningOutput.trajErr_Ntransfer, ...
                       sys_info_Ntransfer, learningOutput.syshat_info_Ntransfer, plot_info);
  trajs{5}           = result.traj_true;
  dtrajs{5}          = result.dtraj_true;
  trajs{6}           = result.traj_hat;
  dtrajs{6}          = result.dtraj_hat;
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    phases{5}        = result.xi_true;
    phases{6}        = result.xi_hat;
  end   
end
traj_data.trajs      = trajs;
traj_data.dtrajs     = dtrajs;
traj_data.phases     = phases;
traj_data.time_vec   = time_vec;
end