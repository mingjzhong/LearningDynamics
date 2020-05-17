function final_visualization_JPL(obs_info, obs_data, sys_info, plot_info, learn_info, learn_out, ...
         trajs, dtrajs)
% function final_visualization_JPL(obs_info, obs_data, sys_info, plot_info, learn_info, learn_out, trajs, dtrajs)

% (C) M. Zhong 

plot_info.plot_name  = sprintf('%s/%s_%s', learn_info.SAVE_DIR, sys_info.name, plot_info.time_stamp);
if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
plot_info.scr_pos    = [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4];
plot_info.scr_xgap   = scrsz(3) * 1/48; 
visualize_phis_and_rhos({learn_out}, sys_info, obs_info, plot_info);
if ~isempty(trajs)
  scr_pos            = plot_info.scr_pos;
  scr_pos(1)         = scr_pos(1) + plot_info.scr_xgap;
  traj_fig           = figure('Name', sprintf('Trajs (%dD): True vs. Learned', sys_info.d), ...
                      'NumberTitle', 'off', 'Position', scr_pos);
  visualize_traj_multiD(traj_fig, trajs, obs_data.day_vec_fut, sys_info, [], obs_info, plot_info);
  plot_info.num_figs = 2;
else
  plot_info.num_figs = 1;
end
% show the phihat_m and masses
plot_mass_and_phi_mean(sys_info, {learn_out}, plot_info);

% make a movie
if plot_info.make_movie 
  scr_pos           = plot_info.scr_pos;
  scr_pos(1)        = scr_pos(1) + 4 * plot_info.scr_xgap;
  mov_fig           = figure('Name', sprintf('Trajs (%dD): True vs. Learned, movie', sys_info.d), ...
                      'NumberTitle', 'off', 'Position', scr_pos);    
  make_traj_multiD_animation(mov_fig, trajs, dtrajs, obs_data.day_vec_fut, sys_info, [], obs_info, ...
    plot_info); 
end
end