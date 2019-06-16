function plot_phiA_and_phiXi_together(win_handle, learningOutput, sys_info, obs_info, plot_info)
% function plot_phiA_and_phiXi_together(phi_fig, learningOutput, sys_info, obs_info, plot_info)

% (c) M. Zhong

% put plots on this particular window
set(groot, 'CurrentFigure', win_handle);
% the rho's
rhoLTR                                        = obs_info.rhoLT.rhoLTA.rhoLTR;
rhoLTRemp                                     = cell(1, length(learningOutput));
rhoLTDR                                       = obs_info.rhoLT.rhoLTA.rhoLTDR;
rhoLTDRemp                                    = cell(1, length(learningOutput));
rhoLTXi                                       = obs_info.rhoLT.rhoLTXi.mrhoLTXi;
rhoLTXiemp                                    = cell(1, length(learningOutput));
rhoLTemp                                      = cell(1, length(learningOutput));
% the phi's
all_phiAhat                                   = cell(1, length(learningOutput));
all_phiXihat                                  = cell(1, length(learningOutput));
all_phiAhatsmooth                             = cell(1, length(learningOutput));
all_phiXihatsmooth                            = cell(1, length(learningOutput));
% the handle to axes
handleAxes                                    = gobjects(2, 2);
% re-arrange storage
for idx = 1 : length(learningOutput)
  rhoLTRemp{idx}                              = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTR;
  rhoLTDRemp{idx}                             = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTDR;
  rhoLTXiemp{idx}                             = learningOutput{idx}.rhoLTemp.rhoLTXi.mrhoLTXi;
  all_phiAhat{idx}                            = learningOutput{idx}.Estimator.phiAhat{1, 1};
  all_phiAhatsmooth{idx}                      = learningOutput{idx}.Estimator.phiAhatsmooth{1, 1};
  all_phiXihat{idx}                           = learningOutput{idx}.Estimator.phiXihat{1, 1};
  all_phiXihatsmooth{idx}                     = learningOutput{idx}.Estimator.phiXihatsmooth{1, 1};
end
% set up some initial terms
plot_info.phi_resolution                      = 1001;
phiA                                          = sys_info.phiA;
phiXi                                         = sys_info.phiXi;
% put them on a 2 X 2 grid
for plot_ind = 1 : 2
  axis_handle                                 = subplot(2, 2, (plot_ind - 1 ) * 2 + 1);
  if plot_ind == 1
    phi                                       = phiA;
    phihats                                   = all_phiAhat;
    phihatsmooths                             = all_phiAhatsmooth;
    plot_info.phi_type                        = 'alignment';
  else
    phi                                       = phiXi;
    phihats                                   = all_phiXihat;
    phihatsmooths                             = all_phiXihatsmooth;
    plot_info.phi_type                        = 'xi';
  end
  rhoLT                                       = get_single_rhoLT(rhoLTR, 1, 1);
  for ind = 1 : length(learningOutput)
    rhoLTemp{ind}                             = get_single_rhoLT(rhoLTRemp{ind}, 1, 1);
  end
  plot_interactions_and_rhos(win_handle, axis_handle, rhoLT, rhoLTemp, phi{1, 1}, phihats, phihatsmooths, 1, 1, sys_info, plot_info);
  xlabel('$r$ (pairwise distance)', 'Interpreter', 'latex', 'FontSize',plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
  handleAxes(plot_ind, 1)                     = axis_handle;
% put on marginal distribution
  axis_handle                                 = subplot(2, 2, (plot_ind - 1 ) * 2 + 2);
  yyaxis right;
  if plot_ind == 1
    rhoLT                                     = get_single_rhoLT(rhoLTDR, 1, 1);
    for ind = 1 : length(learningOutput)
      rhoLTemp{ind}                           = get_single_rhoLT(rhoLTDRemp{ind}, 1, 1);
    end    
  else
    rhoLT                                     = get_single_rhoLT(rhoLTXi, 1, 1);
    for ind = 1 : length(learningOutput)
      rhoLTemp{ind}                           = get_single_rhoLT(rhoLTXiemp{ind}, 1, 1);
    end      
  end
  range                                       = get_range_from_rhos(rhoLTemp);
  [rhoPlotHandles, rhoPlotNames]              = plot_rhos(win_handle, axis_handle, range, rhoLT, rhoLTemp, 1, 1, sys_info, plot_info); 
  legendHandle                                = legend(rhoPlotHandles, rhoPlotNames);
  set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size, 'FontName', plot_info.legend_font_name);  
  if plot_ind == 1
    xlabelHandle                              = xlabel('$\dot{r}$ (pairwise speed)','FontSize',plot_info.axis_font_size);
  else
    xlabelHandle                              = xlabel('$\xi$ (pairwise $\xi_{i, i''}$)','FontSize',plot_info.axis_font_size);
  end
  set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name); 
  yyaxis left;
  axesHandle                                  = gca;
  set(axesHandle, 'YTick', []);
  handleAxes(plot_ind, 2)                          = axesHandle;   
end 
% tighten the axis
tightFigaroundAxes( handleAxes );
for ind = 1 : 2
  handleAxes(ind, 1).YAxis(1).TickLabelFormat = '%.2g';
end
end