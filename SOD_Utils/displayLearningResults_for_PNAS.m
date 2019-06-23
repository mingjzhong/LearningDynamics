function displayLearningResults_for_PNAS(learningOutput, sys_info, chosen_dynamics, obs_info, learn_info, plot_info)
% displayLearningResults(learningOutput, sys_info, chosen_dynamics, obs_info, learn_info, plot_info)

% (c) M. Zhong (JHU)

% compare the true interactions vs. learned (and/or regularized) phis
if strcmp(sys_info.name, 'PhototaxisDynamics')
  visualize_phis_for_PT(learningOutput, sys_info, obs_info, plot_info);
else
  visualize_phis(learningOutput, sys_info, obs_info, learn_info, plot_info);
end
% compare true trajectories vs. learned trajectories

visualize_trajs_for_PNAS(learningOutput, sys_info, chosen_dynamics, obs_info, plot_info);
end