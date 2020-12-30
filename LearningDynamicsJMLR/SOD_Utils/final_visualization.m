function [Mean_Traj_errors, Std_Traj_errors]=final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, learn_info, time_stamp, plot_info)
% function final_visualization(learningOutput, obs_info, solver_info, sys_info, learn_info, plot_info)

% (c) M. zhong. Edited by S. Tang

fprintf('\n================================================================================');
fprintf('\n---------------------- Errors over %2d Learning Trial(s)', length(learningOutput));


[Mean_Traj_errors, Std_Traj_errors]=displayTrajErrs(learningOutput, obs_info, solver_info);

displayIntKernelErrs(learningOutput, sys_info);
plot_info.plot_name      = sprintf('%s/%s_learningOutput_%s', learn_info.SAVE_DIR, sys_info.name, time_stamp);
plot_info.solver_info    = solver_info;
plot_info.for_larger_N   = false;

displayLearningResults(learningOutput, sys_info, learningOutput{1}.syshatsmooth_info, obs_info, learn_info, ...
                        learningOutput{1}.obs_data.ICs, plot_info);

if ~isempty(sys_info_Ntransfer)
    plot_info.for_larger_N = true;
    displayLearningResults( learningOutput, sys_info_Ntransfer, learningOutput{1}.syshatsmooth_info_Ntransfer, ...
        obs_info, learn_info, learningOutput{1}.y_init_Ntransfer, plot_info );
end

return