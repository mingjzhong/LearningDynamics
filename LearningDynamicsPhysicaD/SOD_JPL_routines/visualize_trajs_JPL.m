function visualize_trajs_JPL(obs_info, sys_info, plot_info, obs_data, trajs, dtrajs)
% function visualize_trajs_JPL(obs_info, sys_info, plot_info, obs_data, trajs, dtrajs)

% (C) M. Zhong

if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else,    SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end 

plot_info.plot_name  = sprintf('%s/%s_%s', SAVE_DIR, sys_info.name, plot_info.time_stamp);
if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
plot_info.scr_pos    = [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4];
plot_info.scr_xgap   = scrsz(3) * 1/48;
kinds                = {'EarthMoon',         'inner',              'outer'};
win_names            = {'Earth-Moon System', 'Inner Solar System', 'Outer Solar System'};
plot_info.make_movie  = true;
if ~isempty(trajs)
  for idx = 3 %length(kinds)
    [sys_info_sub, trajs_sub, dtrajs_sub, time_vec, T] ...
                     = get_subset_sys_info(sys_info, trajs, dtrajs, obs_data, kinds{idx}); 
    obs_info.T       = T;
    scr_pos          = plot_info.scr_pos;
    scr_pos(1)       = scr_pos(1) + (2 * idx - 2) * plot_info.scr_xgap;
    traj_fig         = figure('Name', [win_names{idx}, sprintf(' (%dD): True vs. Learned', sys_info.d)], ...
                       'NumberTitle', 'off', 'Position', scr_pos); 
    visualize_traj_multiD(traj_fig, trajs_sub, time_vec, sys_info_sub, [], obs_info, ...
      plot_info);    
% make a movie
    if plot_info.make_movie 
      scr_pos        = plot_info.scr_pos;
      scr_pos(1)     = scr_pos(1) + (2 * idx - 1) * plot_info.scr_xgap;
      mov_fig        = figure('Name', [win_names{idx}, sprintf(' Movie (%dD): True vs. Learned', sys_info.d)], ...
                       'NumberTitle', 'off', 'Position', scr_pos);    
      make_traj_multiD_animation(mov_fig, trajs_sub, dtrajs_sub, time_vec, sys_info_sub, ...
        [], obs_info, plot_info); 
    end     
  end
end    

end