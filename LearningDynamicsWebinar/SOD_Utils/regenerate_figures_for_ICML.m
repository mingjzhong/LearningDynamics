function regenerate_figures_for_ICML(SAVE_DIR, file_names, time_stamps)
% function regenerate_figures_for_ICML(SAVE_DIR, file_names, time_stamps)

% (C) M. Zhong

n_trials                                         = 10;
make_movie                                       = false;
for dyn_idx = 1 : length(file_names)
  dyn_name                                       = file_names{dyn_idx};
  time_stamp                                     = time_stamps{dyn_idx};
  fprintf('\nWorking on %s.', dyn_name);
  save_file = sprintf('%s/%s_%s_sharedVars.mat', SAVE_DIR, dyn_name, time_stamp);
  load(save_file, 'obs_info', 'solver_info', 'sys_info', 'sys_info_Ntransfer', 'learn_info');
  learningOutput = cell(1, n_trials);
  for idx = 1 : n_trials
    save_file                                    = sprintf('%s/%s_%s_%dth_trial_learningOutput.mat', ...
                                                   SAVE_DIR, dyn_name, time_stamp, idx);
    load(save_file, 'learn_out');
    learningOutput{idx}                          = learn_out;
  end
  learn_info.SAVE_DIR                            = SAVE_DIR;
  obs_info.SAVE_DIR                              = SAVE_DIR;
  plot_info                                      = get_plot_info;
  plot_info.SAVE_DIR                             = SAVE_DIR;
  plot_info.make_movie                           = make_movie;
  plot_info.time_stamp                           = time_stamp;
  if isempty(sys_info_Ntransfer)
    ratio                                        = 2;
    sys_info_Ntransfer                           = restructure_sys_info_for_larger_N(ratio, sys_info);
    learningOutput{1}.trajErr_Ntransfer.time_vec = learningOutput{1}.trajErr.time_vec;
    learningOutput{1}.trajErr_Ntransfer.y_init   = sys_info_Ntransfer.mu0();
    learningOutput{1}.syshat_info_Ntransfer      = restructure_sys_info_for_larger_N(ratio, ...
                                                   learningOutput{1}.syshatsmooth_info);
    if isfield(sys_info, 'on_manifold') && ~isempty(sys_info.on_manifold) && sys_info.on_manifold
      plot_info.use_new_ICs                      = false;
    end
  end
  traj_file                                      = sprintf('%s/%s_%s_trajPlot.mat', SAVE_DIR, ...
                                                   dyn_name, time_stamp);
  if exist(traj_file, 'file') == 2
    plot_info.saved_traj                         = true;
    load(traj_file, 'trajs', 'dtrajs', 'phases', 'time_vec');
    plot_info.traj_data                          = set_coarse_traj(trajs, dtrajs, phases, time_vec);
  else
    plot_info.saved_traj                         = false;
  end  
  plot_info.plot_name                            = sprintf('%s/%s_%s', learn_info.SAVE_DIR, ...
                                                   sys_info.name, plot_info.time_stamp);
  plot_info.solver_info                          = solver_info;
  if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
  plot_info.scr_pos                              = [scrsz(3) * 1/8, scrsz(4) * 1/8, ...
                                                    scrsz(3) * 3/4, scrsz(4) * 3/4];
  plot_info.scr_xgap                             = scrsz(3) * 1/48;           
% compare the true interactions vs. learned (and/or regularized) phis
  num_figs                                       = visualize_phis_and_rhos(learningOutput, ...
                                                   sys_info, obs_info, plot_info);
% compare true trajectories vs. learned trajectories
  plot_info.num_phi_figs                         = num_figs;
%  visualize_trajs(learningOutput, sys_info, sys_info_Ntransfer, obs_info, plot_info);
  close all; % close all the figures
end
end