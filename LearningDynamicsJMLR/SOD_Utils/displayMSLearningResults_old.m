function displayMSLearningResults_old(learningOutput, plot_info)
% function displayMSLearningResults_old(learningOutput, obs_info, learn_info, plot_info)

% (c) M. Zhong

scrsz                 = get(groot,'ScreenSize');
phi_fig               = figure('Name', 'PhiEs: True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
[scrsz(3) * 1/8, scrsz(4) * 1/8, scrsz(3) * 3/4, scrsz(4) * 3/4]);
phiEhat               = learningOutput.Estimator.phiEhat;
phiAhat               = learningOutput.Estimator.phiAhat;
rhoLTR                = learningOutput.rhoLTemp.rhoLTA.rhoLTR;
rhoLTDR               = learningOutput.rhoLTemp.rhoLTA.rhoLTDR;
handleAxes            = gobjects(1, 3); 
% put plots on this particular window
set(groot, 'CurrentFigure', phi_fig);
% parameters for plotting
LEGEND_FONT_SIZE      = plot_info.legend_font_size;
AXIS_FONT_SIZE        = plot_info.axis_font_size;
AXIS_FONT_NAME        = plot_info.axis_font_name;
PHIHAT_LINE_WIDTH     = plot_info.phihat_line_width;
RHOTSCALINGDOWNFACTOR = plot_info.rhotscalingdownfactor;

% put phiEhat, phiAhat, and the marginal of \dot{r} in three different subplots, phiEhat first
subplot(1, 3, 1); 
min_r                 = rhoLTR.supp{1, 1}(1);
max_r                 = rhoLTR.supp{1, 1}(2);
if max_r < min_r + 10 * eps, max_r = min_r + 1; min_r = min_r - 1; end
range                 = [min_r, max_r];
edges                 = rhoLTR.histedges{1, 1};                                                     % Estimated \rho's
edges_idxs            = find(range(1) <= edges & edges <= range(2));
centers               = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
histdata              = rhoLTR.hist{1, 1}(edges_idxs(1 : end - 1));
yyaxis right
axesHandle            = gca();
histHandle            = plot(centers, histdata,'k','LineWidth',1);    hold on;
hist_color            = get(gca,'YColor');
set(histHandle, 'Color', hist_color);
hist                  = fill(centers(([1 1:end end])),[0 histdata' 0], hist_color/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
tmpmax                = RHOTSCALINGDOWNFACTOR * max(histdata(:));
if tmpmax==0, tmpmax = 1; end
if isnan(tmpmax), tmpmax = 1; end
if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
axis([range(1), range(2), 0, tmpmax]);
ylabelHandle = ylabel(axesHandle, '$\rho^{L,M}_T$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);
set(ylabelHandle, 'VerticalAlignment', 'bottom');
set(ylabelHandle, 'Position', get(ylabelHandle,'Position') .* [0.95,0.33,1]);                       % TBD better
yyaxis left
r                     = linspace(range(1), range(2),1000);
phiEhatr              = phiEhat{1, 1}(r);
y_min                 = min(phiEhatr(phiEhatr > -Inf));
y_max                 = max(phiEhatr(phiEhatr < Inf));
if y_max < y_min + 10*eps, y_max = y_min + 1; y_min = y_min - 1; end
phiEhatplot           = plot(r, phiEhatr, 'k', 'LineWidth', PHIHAT_LINE_WIDTH); hold on
plot(r, zeros(size(r)), 'k--');
ylabel('$\hat\phi^E$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE);
xlabelHandle          = xlabel('$r$ (pairwise distance)', 'FontSize', AXIS_FONT_SIZE);
set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME); 
legendHandle          = legend([phiEhatplot, hist], '$\hat\phi^E$', '$\rho^{L,M}_T$');        
set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', LEGEND_FONT_SIZE);
axis([range(1), range(2), y_min - (y_max-y_min) * 0.1, y_max]);                                     % set up a uniform x-range, tighten the y-range
handleAxes(1)         = gca;
% phiAhat
subplot(1, 3, 2); 
yyaxis right
axesHandle            = gca();
histHandle            = plot(centers, histdata, 'k', 'LineWidth',1); hold on;
set(histHandle, 'Color', hist_color);
hist                  = fill(centers(([1 1:end end])),[0 histdata' 0], hist_color/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
axis([range(1), range(2), 0, tmpmax]);
ylabelHandle          = ylabel(axesHandle, '$\rho^{L,M}_T$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);
set(ylabelHandle, 'VerticalAlignment', 'bottom');
set(ylabelHandle, 'Position', get(ylabelHandle,'Position') .* [0.95,0.33,1]);                       % TBD better
yyaxis left
phiAhatr              = phiAhat{1, 1}(r);
y_min                 = min(phiAhatr(phiAhatr > -Inf));
y_max                 = max(phiAhatr(phiAhatr < Inf));
if y_max < y_min + 10*eps, y_max = y_min + 1; y_min = y_min - 1; end
phiAhatplot           = plot(r, phiAhatr, 'k', 'LineWidth', PHIHAT_LINE_WIDTH); hold on
plot(r, zeros(size(r)), 'k--');
ylabel('$\hat\phi^A$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE);
xlabelHandle          = xlabel('$r$ (pairwise distance)', 'FontSize', AXIS_FONT_SIZE);
set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME); 
legendHandle          = legend([phiAhatplot, hist], '$\hat\phi^A$', '$\rho^{L,M}_T$');       
set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', LEGEND_FONT_SIZE);
axis([range(1), range(2), y_min - (y_max-y_min) * 0.1, y_max]);                                     % set up a uniform x-range, tighten the y-range
handleAxes(2)         = gca;
% marginal of \dot{r}
subplot(1, 3, 3);
range                 = rhoLTDR.supp{1, 1};
edges                 = rhoLTDR.histedges{1, 1};                                                    % Estimated \rho's
edges_idxs            = find(range(1) <= edges & edges <= range(2));
centers               = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
histdata              = rhoLTDR.hist{1, 1}(edges_idxs(1 : end - 1));                                % this is the "true" \rhoLT from many MC simulations                                                                                    % display \rho^L_T and its estimator
axesHandle            = gca();
histHandle            = plot(centers, histdata,'k', 'LineWidth', 1); hold on;
set(histHandle, 'Color', hist_color);
fill(centers(([1 1:end end])),[0 histdata' 0], hist_color/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
tmpmax                = RHOTSCALINGDOWNFACTOR * max(histdata(:)); 
if tmpmax == 0,   tmpmax = 1; end
if isnan(tmpmax), tmpmax = 1; end
if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
axis([range(1), range(2), 0, tmpmax]);
ylabelHandle          = ylabel(axesHandle, '$\rho^{L, M, A}_T$');
set(ylabelHandle, 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);
xlabelHandle          = xlabel('$\dot{r}$ (pairwise speed)', 'FontSize', AXIS_FONT_SIZE);
set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME); 
handleAxes(3)         = gca;
tightFigaroundAxes(handleAxes);
end