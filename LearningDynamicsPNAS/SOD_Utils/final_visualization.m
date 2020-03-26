function final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, learn_info, time_stamp, plot_info)
% function final_visualization(learningOutput, obs_info, solver_info, sys_info, learn_info, plot_info)

% (c) M. zhong

% displaying errors
fprintf('\n================================================================================');
fprintf('\n------------------- Errors over %2d Learning Trial(s)', length(learningOutput));
if isfield(learningOutput{1}, 'trajErr'),   displayTrajErrs(learningOutput, obs_info, solver_info); end
if isfield(learningOutput{1}, 'L2rhoTErr'), displayL2rhoTErrs(learningOutput, sys_info); end
% displaying results
fprintf('\n------------------- Visualizing phis and trajs');
plot_info.plot_name      = sprintf('%s/%s_learningOutput_%s', learn_info.SAVE_DIR, sys_info.name, time_stamp);
plot_info.solver_info    = solver_info;
plot_info.for_larger_N   = false;
displayLearningResults(learningOutput, sys_info, learningOutput{1}.syshatsmooth_info, obs_info, learn_info, learningOutput{1}.obs_data.ICs, plot_info);
% for Larger N
if ~isempty(sys_info_Ntransfer)
  plot_info.for_larger_N = true;
  visualize_trajs(learningOutput, sys_info_Ntransfer, learningOutput{1}.syshatsmooth_info_Ntransfer, obs_info, learningOutput{1}.y_init_Ntransfer, plot_info);
end
end