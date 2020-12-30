function plot_phiA_and_phiXi_together(win_handle, learningOutput, sys_info, obs_info, plot_info)
% function plot_phiA_and_phiXi_together(phi_fig, learningOutput, sys_info, obs_info, plot_info)

% (c) M. Zhong

% put plots on this particular window
set(groot, 'CurrentFigure', win_handle);
% the rho's
rhoLTR                          = obs_info.rhoLT.rhoLTA.rhoLTR;
rhoLTRemp                       = cell(1, length(learningOutput));
rhoLTDR                         = obs_info.rhoLT.rhoLTA.rhoLTDR;
rhoLTDRemp                      = cell(1, length(learningOutput));
rhoLTXi                         = obs_info.rhoLT.rhoLTXi.mrhoLTXi;
rhoLTXiemp                      = cell(1, length(learningOutput));
%
all_phiAhat                     = cell(1, length(learningOutput));
all_phiXihat                    = cell(1, length(learningOutput));
all_phiAhatsmooth               = cell(1, length(learningOutput));
all_phiXihatsmooth              = cell(1, length(learningOutput));
%
min_rs                          = zeros(1, length(learningOutput));
max_rs                          = zeros(1, length(learningOutput));
%
handleAxes                      = gobjects(2, 2);
%
for idx = 1 : length(learningOutput)
  rhoLTRemp{idx}                = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTR;
  rhoLTDRemp{idx}               = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTDR;
  rhoLTXiemp{idx}               = learningOutput{idx}.rhoLTemp.rhoLTXi.mrhoLTXi;
  min_rs(idx)                   = rhoLTRemp{idx}.supp{1, 1}(1);
  max_rs(idx)                   = rhoLTRemp{idx}.supp{1, 1}(2);
  all_phiAhat{idx}              = learningOutput{idx}.Estimator.phiAhat;
  all_phiAhatsmooth{idx}        = learningOutput{idx}.Estimator.phiAhatsmooth;
  all_phiXihat{idx}             = learningOutput{idx}.Estimator.phiXihat;
  all_phiXihatsmooth{idx}       = learningOutput{idx}.Estimator.phiXihatsmooth;
end
%
min_r                           = min(min_rs);
max_r                           = max(max_rs);
if max_r < min_r + 10 * eps, max_r = min_r + 1; min_r = min_r - 1; end
range                           = [min_r, max_r];
r                               = linspace(range(1), range(2),1000);
phiAr                           = sys_info.phiA{1, 1}(r);
phiXir                          = sys_info.phiXi{1, 1}(r);
% put them on a 2 X 2 grid
for ind = 1 : 2
  subplot(2, 2, (ind - 1 ) * 2 + 1);
  if ind == 1
    phir                        = phiAr;
    all_phihat                  = all_phiAhat;
    all_phihatsmooth            = all_phiAhatsmooth;
  else
    phir                        = phiXir;
    all_phihat                  = all_phiXihat;
    all_phihatsmooth            = all_phiXihatsmooth;
  end
  for trialIdx = length(learningOutput) : -1 : 1
    phihat                      = all_phihat{trialIdx};
    phihatr(trialIdx, :)        = phihat{1, 1}(r);
    if plot_info.display_interpolant
      phihatsmooth              = all_phihatsmooth{trialIdx};
      phihatsmoothr(trialIdx,:) = phihatsmooth{1, 1}(r);
    else
      phihatsmoothr(trialIdx,:) = phihatr(trialIdx, :);
    end
  end    
  y_min                         = max([min(phir(phir > -Inf)), min(phihatr(:)),             min(phihatsmoothr(phihatsmoothr > -Inf))])*1.1;                                                                       % find out the range for y values, f1 might have blow up, just use f_hat
  y_max                         = min([max(phir(phir <  Inf)), max(phihatr(phihatr < Inf)), max(phihatsmoothr(phihatsmoothr <  Inf))])*1.1;
  if y_max < y_min + 10*eps, y_max = y_min + 1; y_min = y_min - 1; end
% put on rho's
  edges                         = rhoLTR.histedges{1, 1};                                           % Estimated \rho's
  edges_idxs                    = find(range(1) <= edges & edges <= range(2));
  [histdata,edges]              = downsampleHistCounts( rhoLTR.hist{1, 1}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
  centers                       = (edges(1 : end - 1) + edges(2 : end))/2;
  yyaxis right;                                                                                     % display \rho^L_T and its estimator
  axesHandle1                   = gca();
  histHandle1                   = plot(centers, histdata,'k','LineWidth',1);    hold on;
  color1                        = get(gca,'YColor');
  set(histHandle1,'Color', color1);
  hist1                         = fill(centers(([1 1:end end])),[0 histdata' 0], color1/2,'EdgeColor','none','FaceAlpha',0.1);
  edges                         = rhoLTRemp{1}.histedges{1, 1};                                     % Estimated \rho's
  edges_idxs                    = find(range(1) <= edges & edges <= range(2));
  [histdata2,edges]             = downsampleHistCounts( rhoLTRemp{1}.hist{1, 1}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
  centers                       = (edges(1 : end - 1) + edges(2 : end))/2;
  histHandle2                   = plot(centers,histdata2,'k--','LineWidth',1);
  color2                        = get(gca,'YColor');
  set(histHandle2,'Color', color2);
  hist2                         = fill(centers(([1 1:end end])),[0 histdata2' 0], color2,'EdgeColor',...
  'none','FaceAlpha',0.1);
  axis tight;
  tmpmax = plot_info.rhotscalingdownfactor * max(max(histdata(:)), max(histdata2));
  if tmpmax==0, tmpmax = 1; end
  if isnan(tmpmax), tmpmax = 1; end
  if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
  axis([range(1), range(2), 0, tmpmax]);
  if tmpmax == 1
    Escale                             = 1;
  else 
    Escale                             = int32(log10(tmpmax));
  end
  axesHandle1.YAxis(2).Exponent        = Escale;
  axesHandle1.YAxis(2).TickLabelFormat = '%.2g';
% put on phi's
  yyaxis left                                                                                     % display interaction kernels
  if plot_info.display_interpolant && plot_info.display_phihat
    legendPlotHandles                  = gobjects(1, 3);
    legendPlotStrings                  = cell(1, 5);
  else
    legendPlotHandles                  = gobjects(1, 2);
    legendPlotStrings                  = cell(1, 4);  
  end
  LP_counter                           = 1;        
  legendPlotHandles(LP_counter)        = plot(r, phir, 'k', 'LineWidth', plot_info.phi_line_width); hold on;
  if ind == 1
    legend_name = '$\phi^A$';
  else
    legend_name = '$\phi^{\xi}$';
  end
  legendPlotStrings{LP_counter}        = legend_name;
  if plot_info.display_phihat || ~plot_info.display_interpolant
    LP_counter                         = LP_counter + 1;
    legendPlotHandles(LP_counter)      = plot(r, mean(phihatr,1),  '-r', 'LineWidth', plot_info.phihat_line_width); % plot the learned phi
    if ind == 1
      legend_name = '$\hat\phi^A$';
    else
      legend_name = '$\hat\phi^{\xi}$';
    end
    legendPlotStrings{LP_counter}      =legend_name;
    plot(r, mean(phihatr,1) + std(phihatr, [], 1),  '--r', 'LineWidth', plot_info.phihat_line_width/4);
    plot(r, mean(phihatr,1) - std(phihatr, [], 1),  '--r', 'LineWidth', plot_info.phihat_line_width/4);
  end
  plot(r,zeros(size(r)),'k--');
  if plot_info.display_interpolant
    LP_counter                         = LP_counter + 1;
    legendPlotHandles(LP_counter)      = plot(r, mean(phihatsmoothr,1),  '-b', 'LineWidth', plot_info.phihat_line_width); % plot the learned phi, smoothed
    if ~plot_info.display_phihat
      if ind == 1
        legend_name = '$\hat\phi^A$';
      else
        legend_name = '$\hat\phi^{\xi}$';
      end        
    else
      if ind == 1
        legend_name = '$\hat\phi^{A, reg}$';
      else
        legend_name = '$\hat\phi^{\xi, reg}$';
      end             
    end
    legendPlotStrings{LP_counter}      = legend_name;
    plot(r, mean(phihatsmoothr, 1) + std(phihatsmoothr, [], 1),  '--b', 'LineWidth', plot_info.phihat_line_width/4);
    plot(r, mean(phihatsmoothr, 1) - std(phihatsmoothr, [], 1),  '--b', 'LineWidth', plot_info.phihat_line_width/4);
  end
  legendPlotStrings{end-1}             = '$\rho_{T, r}^L$';
  legendPlotStrings{end}               = '$\rho_{T, r}^{L, M}$';  
  legendHandle2                        = legend([legendPlotHandles, hist1, hist2], legendPlotStrings);
  set(legendHandle2, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
  axis([range(1), range(2), y_min-(y_max-y_min)*0.1, y_max]);                                       % set up a uniform x-range, tighten the y-range
  xlabel('r (pairwise distance)','FontSize',plot_info.axis_font_size);
  axesHandle                           = gca;
  axesHandle.YAxis(1).TickLabelFormat  = '%+g';
  handleAxes(ind, 1)                   = axesHandle;
% put on marginal distribution
  subplot(2, 2, (ind - 1 ) * 2 + 2);
  if ind == 1
    rhoLTA                             = rhoLTDR;
    rhoLTAemp                          = rhoLTDRemp;
  else
    rhoLTA                             = rhoLTXi;
    rhoLTAemp                          = rhoLTXiemp;
  end
  m_range                              = rhoLTAemp{1}.supp{1, 1};
  edges                                = rhoLTA.histedges{1, 1};                                    % Estimated \rho's
  edges_idxs                           = find(m_range(1) <= edges & edges <= m_range(2));
  [histdata,edges]                     = downsampleHistCounts( rhoLTA.hist{1, 1}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
  centers                              = (edges(1 : end - 1) + edges(2 : end))/2;                                                                                    % display \rho^L_T and its estimator
  axesHandle1                          = gca();
  histHandle1                          = plot(centers, histdata,'k', 'LineWidth', 1);    hold on;
  set(histHandle1, 'Color', color1);
  hist1                                = fill(centers(([1 1:end end])),[0 histdata' 0], color1/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
  edges                                = rhoLTAemp{1}.histedges{1, 1};                              % Estimated \rho's
  edges_idxs                           = find(m_range(1) <= edges & edges <= m_range(2));
  [histdata2,edges]                    = downsampleHistCounts( rhoLTAemp{1}.hist{1, 1}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
  centers                              = (edges(1 : end - 1) + edges(2 : end))/2;
  histHandle2                          = plot(centers, histdata2, 'k--', 'LineWidth', 1);
  set(histHandle2, 'Color', color2);
  hist2                                = fill(centers(([1 1:end end])), [0 histdata2' 0], color2,'EdgeColor', 'none','FaceAlpha', 0.1);
  axis tight;
  tmpmax = plot_info.rhotscalingdownfactor * max(max(histdata(:)), max(histdata2));
  if tmpmax == 0,   tmpmax = 1; end
  if isnan(tmpmax), tmpmax = 1; end
  if abs(m_range(2) - m_range(1)) < 1.0e-12, m_range(2) = m_range(1) + 1; end
  axis([m_range(1), m_range(2), 0, tmpmax]);
  axesHandle1.YAxis.Exponent        = int32(log10(tmpmax));
  axesHandle1.YAxis.TickLabelFormat = '%.2g';
  if ind == 1
    xlabelHandle                       = xlabel('$\dot{r}$ (pairwise speed)','FontSize',plot_info.axis_font_size);
    legend_names                       = {'$\rho^{L}_{T, \dot{r}}$', '$\rho^{L, M}_{T, \dot{r}}$'};
  else
    xlabelHandle                       = xlabel('$\xi$ (pairwise $\xi_{i, i''}$)','FontSize',plot_info.axis_font_size);
    legend_names                       = {'$\rho^{L}_{T, \xi}$', '$\rho^{L, M}_{T, \xi}$'};
  end
  set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name); 
  legendHandle                         = legend([hist1, hist2], legend_names);
  set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
  handleAxes(ind, 2)                   = gca;   
end 
%
tightFigaroundAxes( handleAxes );
for ind = 1 : 2
  handleAxes(ind, 1).YAxis(1).TickLabelFormat = '%g';
end
end