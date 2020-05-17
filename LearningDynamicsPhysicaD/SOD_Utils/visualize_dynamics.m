function visualize_dynamics(dynamics, sys_info, solver_info, obs_info, plot_info)
% function visualize_dynamics(sys_info, dynamics, plot_info)

% (c) M. Zhong

sys_info_Ntransfer  = [];
block_size          = sys_info.N * sys_info.d;
time_vec            = linspace(solver_info.time_span(1), solver_info.time_span(2), obs_info.L);
[traj, dtraj]       = dense_output(dynamics,    time_vec);
trajs               = {traj(1  : block_size, :)};
if sys_info.ode_order == 1
  dtrajs          = {dtraj(1 : block_size, :)};
  if contains(sys_info.name, 'SynchronizedOscillatorDynamics')
    phases          = {mod(traj(block_size + 1 : block_size + sys_info.N, :), 2 * pi) - pi};
  else
    phases          = {};
  end
else
  dtrajs            = {traj(block_size + 1    : 2 * block_size, :)};
  if contains(sys_info.name, 'PhototaxisDynamics')
    phases          = {traj(2 * block_size + 1 : 2 * block_size + sys_info.N, :)};
  else
    phases          = {};
  end
end
plot_info.phases    = phases;
plot_info.plot_name = sprintf('%s/%s_learningOutput_%s', plot_info.SAVE_DIR, sys_info.name, plot_info.time_stamp);
% put the trajectories on one single window for comparison
if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
scr_pos             = [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4];
scr_xgap            = scrsz(3) * 1/48;
traj_fig            = figure('Name', 'Trajectory', 'NumberTitle', 'off', 'Position', scr_pos);
if sys_info.d == 1
  visualize_traj_1D(traj_fig, trajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info);
  if isfield(plot_info, 'make_movie') && plot_info.make_movie
    scr_pos(1)      = scr_pos(1) + scr_xgap;
    move_fig        = figure('Name', 'PhiEs: True vs. Learned', 'NumberTitle', 'off', 'Position', scr_pos);
    make_traj_1D_animation(move_fig, trajs, dtrajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info); 
  end  
else
  if sys_info.d > 3
    error('');
  end
  visualize_traj_multiD(traj_fig, trajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info);
  if isfield(plot_info, 'make_movie') && plot_info.make_movie
    scr_pos(1)      = scr_pos(1) + scr_xgap;
    move_fig        = figure('Name', 'PhiEs: True vs. Learned', 'NumberTitle', 'off', 'Position', scr_pos);    
    make_traj_multiD_animation(move_fig, trajs, dtrajs, time_vec, sys_info, sys_info_Ntransfer, obs_info, plot_info); 
  end    
end
end