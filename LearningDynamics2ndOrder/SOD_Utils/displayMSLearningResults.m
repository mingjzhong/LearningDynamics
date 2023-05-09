function displayMSLearningResults(learningOutput, sys_info, plot_info)
% function displayMSLearningResults(learningOutput, sys_info, plot_info)

% (c) M. Zhong (JHU)

% prepare the window size
if isfield(plot_info, 'scrsz') && ~isempty(plot_info.scrsz), scrsz = plot_info.scrsz; 
else, scrsz = get(groot,'ScreenSize'); end
pos_vec                                    = [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, ...
                                             scrsz(4) * 3/4];
phi_fig                                    = figure('Name', 'Learned PhiE vs. PhiA', ...
                                             'NumberTitle', 'off', 'Position', pos_vec);
handleAxes                                 = gobjects(1, 2); 
total_num_trials                           = length(learningOutput);
phiEhats                                   = cell(1, total_num_trials);
phiAhats                                   = cell(1, total_num_trials);
rhoLTM                                     = cell(1, total_num_trials);
% put plots on this particular window
set(groot, 'CurrentFigure', phi_fig);
% phiE first
axis_handle                                = subplot(1, 2, 1);
plot_info.phi_type                         = 'energy';
plot_info.phi_resolution                   = 400;
plot_info.rho_resolution                   = 400;
phiE                                       = [];
for ind = 1 : total_num_trials
  phiEhats{ind}                            = learningOutput{ind}.Estimator.phiEhat{1, 1};
  rhoLTM{ind}                              = learningOutput{ind}.Estimator.rhoLTM{1}{1}.dense;
end
plot_info.display_interpolant              = false;
plot_info.display_phihat                   = true;

range                                      = get_basis_range(learningOutput, sys_info, 'energy');
plot_phis_and_rhos_each_type_Ck1Ck2_1D(phi_fig, axis_handle, range{1, 1}, [], rhoLTM, phiE, ...
      phiEhats, [], 1, 1, sys_info, plot_info);
xlabelHandle                               = xlabel('$r$ (pairwise distance)', 'FontSize', ...
                                             plot_info.axis_font_size);
set(xlabelHandle, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name); 
handleAxes(1)                              = axis_handle;
% phiAhat second
axis_handle                                = subplot(1, 2, 2);
plot_info.phi_type                         = 'alignment';
phiA                                       = [];
for ind = 1 : total_num_trials
  phiAhats{ind}                            = learningOutput{ind}.Estimator.phiAhat{1, 1};
end
plot_phis_and_rhos_each_type_Ck1Ck2_1D(phi_fig, axis_handle, range{1, 1}, [], rhoLTM, phiA, ...
      phiAhats, [], 1, 1, sys_info, plot_info);
xlabelHandle                               = xlabel('$r$ (pairwise distance)', 'FontSize', ...
  plot_info.axis_font_size);
set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', ...
  plot_info.axis_font_name); 
handleAxes(2)                              = axis_handle;
% tighten the axis
tightFigaroundAxes(handleAxes);
for ind = 1 : 2
  handleAxes(ind).YAxis(1).TickLabelFormat = '%.2g';
end
% save the figure
saveas(phi_fig, [plot_info.plot_name '_phi_MS'], 'fig');
% plot the joint distribution
pos_vec                                    = [scrsz(3) * 3/16, scrsz(4) * 1/8, scrsz(3) * 3/4, ...
                                             scrsz(4) * 3/4];
rho_fig                                    = figure('Name', 'rhoLTemps: Marginals and Joint', ...
                                             'NumberTitle', 'off', 'Position', pos_vec);
rhoLTMRs                                   = cell(1, total_num_trials);
rhoLTMDRs                                  = cell(1, total_num_trials);
rhoLTMRDRs                                 = cell(1, total_num_trials);
for ind = 1 : total_num_trials
  rhoLTMRs{ind}                            = {learningOutput{ind}.Estimator.rhoLTM{2}{1}.mrhoLT{1}.dense};
  rhoLTMDRs{ind}                           = {learningOutput{ind}.Estimator.rhoLTM{2}{1}.mrhoLT{2}.dense};
  rhoLTMRDRs{ind}                          = {learningOutput{ind}.Estimator.rhoLTM{2}{1}.dense};
end
rho_range                                  = get_rho_range(learningOutput, sys_info, 'alignment');
plot_info.rho_type                         = 'alignment';
plot_rhos_joint_distribution(rho_fig, range, rho_range, [], rhoLTMRs, [], rhoLTMDRs, [], ...
  rhoLTMRDRs, sys_info, plot_info);
% save the figure
saveas(rho_fig, [plot_info.plot_name '_rho_MS'], 'fig');
end