function displayLearningResults( learningOutput, sys_info, sys_info_approx, obs_info, learn_info, ICs, plot_info )
% displayLearningResults( learningOutput, sys_info, obs_info, learn_info, obs_data, plot_name )

% (c) M. Zhong, M. Maggioni (JHU)

% compare the true interactions vs. learned (and/or regularized) phis
if strcmp(sys_info.name, 'PhototaxisDynamics')
    visualize_phis_for_PT(learningOutput, sys_info, obs_info, plot_info);
else
    visualize_phis(learningOutput, sys_info, obs_info, learn_info, plot_info);
end
% compare true trajectories vs. learned trajectories
visualize_trajs(learningOutput, sys_info, sys_info_approx, obs_info, ICs, plot_info);
end