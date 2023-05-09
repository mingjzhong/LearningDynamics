function final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, ...
         learn_info, plot_info)
% function final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, ...
%          learn_info, plot_info)

% (c) M. zhong

% displaying errors
fprintf('\n================================================================================');
fprintf('\n------------------- Errors over %2d Learning Trial(s)', length(learningOutput));
if isfield(learningOutput{1}, 'trajErr'),                displayTrajErrs(learningOutput, obs_info, sys_info, solver_info); end
if isfield(learningOutput{1}, 'L2rhoTErr'),              displayL2rhoTErrs(learningOutput, sys_info); end
if isfield(learningOutput{1}, 'patternIndicatorScores'), displayPatternIndicators(learningOutput, solver_info); end
if isfield(learningOutput{1}, 'massErr');                displayMassErrs(learningOutput, sys_info); end
if isfield(learningOutput{1}.Estimator, 'ALM_Info'),     displayALM_Info(learningOutput); end
% displaying results
fprintf('\n------------------- Visualizing phis and trajs');
plot_info.plot_name   = sprintf('%s/%s_%s', learn_info.SAVE_DIR, sys_info.name, plot_info.time_stamp);
plot_info.solver_info = solver_info;
if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
plot_info.scr_pos     = [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4];
plot_info.scr_xgap    = scrsz(3) * 1/48;           
displayLearningResults(learningOutput, sys_info, sys_info_Ntransfer, obs_info, plot_info);
end