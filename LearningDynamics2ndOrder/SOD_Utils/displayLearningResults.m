function displayLearningResults(learningOutput, sys_info, sys_info_Ntransfer, obs_info, plot_info)
% function displayLearningResults(learningOutput, sys_info, sys_info_Ntransfer, obs_info, plot_info)

% (c) M. Zhong, M. Maggioni (JHU)

% compare the true interactions vs. learned (and/or regularized) phis
num_figs                       = visualize_phis_and_rhos(learningOutput, sys_info, obs_info, plot_info);
% compare true trajectories vs. learned trajectories
plot_info.num_phi_figs         = num_figs;
if contains(sys_info.name, 'Gravitation')
  plot_info.colorbar_font_size = 16;
end
num_figs                       = visualize_trajs(learningOutput, sys_info, sys_info_Ntransfer, ...
                                 obs_info, plot_info);
if contains(sys_info.name, 'Gravitation')
  plot_info.num_figs           = plot_info.num_phi_figs + num_figs;
  plot_mass_and_phi_mean(sys_info, learningOutput, plot_info);
end
end