function final_visualization_RKHS(learningOutput, sys_info, obs_info, plot_info, degrees, noise_kinds)
% function final_visualization_RKHS(learningOutput, sys_info, obs_info, plot_info, degrees, noise_kinds)

% future use:
% emp_errs        = get_RKHS_empirical_errors(A, b, U, spec, learningOutput{k}.Estimator.rhs_l2sq);

% (C) M. Zhong

if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
plot_info.scr_pos      = [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4];
plot_info.scr_xgap     = scrsz(3) * 1/48; 
plot_info.num_figs     = 0;
for idx1 = 1 : length(degrees)
  for idx2 = 1 : length(noise_kinds)  
    plot_info.fig_name = sprintf('%s/%s_EigValComp_deg%d_NT%d',  plot_info.SAVE_DIR, sys_info.name, ...
                         idx1 - 1, idx2); 
    if idx2 == 2, plot_info.show_h = true; else, plot_info.show_h = false; end
    plot_info.num_figs = plot_info.num_figs + visualize_RKHS_eigenvalues(learningOutput{idx1, idx2}, ...
                         plot_info);
    plot_info.fig_name = sprintf('%s/%s_phihatComp_deg%d_NT%d', plot_info.SAVE_DIR, sys_info.name, ...
                         idx1 - 1, idx2);
    plot_info.num_figs = plot_info.num_figs + visualize_RKHS_phihats(learningOutput{idx1, idx2}, ...
                         sys_info, obs_info, plot_info);
  end
end
for idx = 1 : length(degrees)
  plot_info.fig_name   = sprintf('%s/%s_EigFuncComp_deg%d', plot_info.SAVE_DIR, sys_info.name, ...
                         idx - 1);
  plot_info.num_figs   = plot_info.num_figs + compare_RKHS_basis(learningOutput(idx, :), plot_info);
end
end