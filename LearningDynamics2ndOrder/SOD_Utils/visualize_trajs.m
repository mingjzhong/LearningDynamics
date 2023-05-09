function num_figs = visualize_trajs(learningOutput, sys_info,sys_info_Ntransfer, obs_info, plot_info)
% function num_figs = visualize_trajs(learningOutput, sys_info,sys_info_Ntransfer, obs_info, plot_info)

% (c) M. Zhong

% go through the Initial Conditions from the training data set
num_figs             = plot_info.num_phi_figs;
syshat_info          = learningOutput{1}.syshatsmooth_info;
if isfield(plot_info, 'saved_traj') && ~isempty(plot_info.saved_traj) && plot_info.saved_traj
  traj_data          = plot_info.traj_data;
else
  plot_info.traj_L   = 150;                                                                         % observation time instances for plotting
  traj_data          = get_traj_data_from_scratch(learningOutput{1}, sys_info, syshat_info, ...
                       sys_info_Ntransfer, plot_info);
% save the traj data
  file_name          = sprintf('%s/%s_%s_trajPlot', plot_info.SAVE_DIR, sys_info.name, ...
                       plot_info.time_stamp);            
  save(file_name, '-v7.3', '-struct', 'traj_data');                     
end
% put the trajectories on one single window for comparison
scr_pos              = plot_info.scr_pos;
scr_pos(1)           = scr_pos(1) + num_figs * plot_info.scr_xgap;
traj_fig             = figure('Name', sprintf('Trajs (%dD): True vs. Learned', sys_info.d), ...
                       'NumberTitle', 'off', 'Position', scr_pos);
num_figs             = num_figs + 1;
plot_info.phases     = traj_data.phases;
if sys_info.d == 1
  visualize_traj_1D(traj_fig, traj_data.trajs, traj_data.time_vec, sys_info, sys_info_Ntransfer, ...
    obs_info, plot_info);
  if isfield(plot_info, 'make_movie') && plot_info.make_movie
    scr_pos          = plot_info.scr_pos;
    scr_pos(1)       = scr_pos(1) + num_figs * plot_info.scr_xgap;
    traj_fig         = figure('Name', sprintf('Trajs (%dD): True vs. Learned, movie', sys_info.d), ...
                       'NumberTitle', 'off', 'Position', scr_pos);
    make_traj_1D_animation(traj_fig, traj_data.trajs, traj_data.dtrajs, traj_data.time_vec, ...
      sys_info, sys_info_Ntransfer, obs_info, plot_info); 
    num_figs         = num_figs + 1;
  end  
elseif sys_info.d == 2 || sys_info.d == 3
  visualize_traj_multiD(traj_fig, traj_data.trajs, traj_data.time_vec, sys_info, ...
    sys_info_Ntransfer, obs_info, plot_info);
  if isfield(plot_info, 'make_movie') && plot_info.make_movie
    scr_pos          = plot_info.scr_pos;
    scr_pos(1)       = scr_pos(1) + num_figs * plot_info.scr_xgap;
    traj_fig         = figure('Name', sprintf('Trajs (%dD): True vs. Learned, movie', sys_info.d), ...
                       'NumberTitle', 'off', 'Position', scr_pos);    
    make_traj_multiD_animation(traj_fig, traj_data.trajs, traj_data.dtrajs, traj_data.time_vec, ...
      sys_info, sys_info_Ntransfer, obs_info, plot_info); 
    num_figs         = num_figs + 1;
  end    
end
end