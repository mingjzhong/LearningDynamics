function final_visualization_RKHS(learningOutput, sys_info, obs_info, plot_info)
% function final_visualization_RKHS(learningOutput, sys_info, obs_info, plot_info)

% future use:
% emp_errs        = get_RKHS_empirical_errors(A, b, U, spec, learningOutput{k}.Estimator.rhs_l2sq);

% (C) M. Zhong

if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
plot_info.scr_pos  = [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4];
plot_info.scr_xgap = scrsz(3) * 1/48; 
plot_info.num_figs = 0;
plot_info.num_figs = visualize_RKHS_eigenvalues(learningOutput, sys_info, plot_info);
visualize_RKHS_phihats(learningOutput, sys_info, obs_info, plot_info);
end