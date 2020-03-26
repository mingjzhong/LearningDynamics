function displayMSLearningResults(learningOutput, sys_info, plot_info)
% function displayMSLearningResults(learningOutput, sys_info, plot_info)

% (c) M. Zhong (JHU)

% prepare the window size
if isfield(plot_info, 'scrsz') && ~isempty(plot_info.scrsz), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
phi_fig                                    = figure('Name', 'Learned PhiE vs. PhiA', 'NumberTitle', 'off', 'Position', [scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4]);
handleAxes                                 = gobjects(1, 2); 
total_num_trials                           = length(learningOutput);
phiEhats                                   = cell(1, total_num_trials);
phiAhats                                   = cell(1, total_num_trials);
rhoLTemp                                   = cell(1, total_num_trials);
% put plots on this particular window
set(groot, 'CurrentFigure', phi_fig);
% phiE first
axis_handle                                = subplot(1, 2, 1);
plot_info.phi_type                         = 'energy';
plot_info.phi_resolution                   = 1001;
phiE                                       = [];
for ind = 1 : total_num_trials
  phiEhats{ind}                            = learningOutput{ind}.Estimator.phiEhat{1, 1};
  rhoLTemp{ind}                            = get_single_rhoLT(learningOutput{ind}.rhoLTemp.rhoLTA.rhoLTR, 1, 1);
end
plot_info.display_interpolant              = false;
rhoLT                                      = [];
plot_interactions_and_rhos(phi_fig, axis_handle, rhoLT, rhoLTemp, phiE, phiEhats, [], 1, 1, sys_info, plot_info);
xlabelHandle                               = xlabel('$r$ (pairwise distance)', 'FontSize', plot_info.axis_font_size);
set(xlabelHandle, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name); 
handleAxes(1)                              = axis_handle;
% phiAhat second
axis_handle                                = subplot(1, 2, 2);
plot_info.phi_type                         = 'alignment';
phiA                                       = [];
for ind = 1 : total_num_trials
  phiAhats{ind}                            = learningOutput{ind}.Estimator.phiAhat{1, 1};
end
plot_interactions_and_rhos(phi_fig, axis_handle, rhoLT, rhoLTemp, phiA, phiAhats, [], 1, 1, sys_info, plot_info);
xlabelHandle                               = xlabel('$r$ (pairwise distance)', 'FontSize', plot_info.axis_font_size);
set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name); 
handleAxes(2)                              = axis_handle;
% tighten the axis
tightFigaroundAxes(handleAxes);
for ind = 1 : 2
  handleAxes(ind).YAxis(1).TickLabelFormat = '%.2g';
end
% save the figure
saveas(phi_fig, [plot_info.plot_name '_phi_MS'], 'fig');
% plot the joint distribution
rho_fig                                    = figure('Name', 'rhoLTemps: Marginals and Joint', 'NumberTitle', 'off', 'Position', ...
[scrsz(3) * 1/4, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4]);
plot_one_joint_distribution(rho_fig, learningOutput{1}.rhoLTemp, 1, plot_info);
% save the figure
saveas(rho_fig, [plot_info.plot_name '_rho_MS'], 'fig');
end