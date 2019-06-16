function plot_one_type_of_phis(win_handler, phi, all_phihat, all_phihatsmooth, learningOutput, basis_info, sys_info, obs_info, plot_info)
% function plot_one_type_of_phis(win_handler, phi, all_phihat, all_phihatsmooth, learningOutput, basis_info, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

% put plots on this particular window
set(groot, 'CurrentFigure', win_handler);
% parameters for plotting
total_num_trials                         = length(learningOutput);
switch plot_info.phi_type
    case 'energy'
      rhoLTR                             = obs_info.rhoLT.rhoLTE;
    case 'alignment'
      rhoLTR                             = obs_info.rhoLT.rhoLTA.rhoLTR;
      rhoLTA                             = obs_info.rhoLT.rhoLTA.rhoLTDR;
      rhoLTAemp                          = cell(1, total_num_trials);
    case 'xi'
      rhoLTR                             = obs_info.rhoLT.rhoLTXi.rhoLTR;
      rhoLTA                             = obs_info.rhoLT.rhoLTXi.mrhoLTXi;
      rhoLTAemp                          = cell(1, total_num_trials);
    otherwise
end
rhoLTRemp                                = cell(1, total_num_trials);
rhoLTemp                                 = cell(1, total_num_trials);
phihats                                  = cell(1, total_num_trials);
phihatsmooths                            = cell(1, total_num_trials);
for idx = 1 : total_num_trials
  switch plot_info.phi_type
    case 'energy'
      rhoLTRemp{idx}                     = learningOutput{idx}.rhoLTemp.rhoLTE;
      handleAxes                         = gobjects(sys_info.K);
    case 'alignment'
      rhoLTRemp{idx}                     = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTR;
      rhoLTAemp{idx}                     = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTDR;
      handleAxes                         = gobjects(sys_info.K, 2 * sys_info.K);
    case 'xi'
      rhoLTRemp{idx}                     = learningOutput{idx}.rhoLTemp.rhoLTXi.rhoLTR;
      rhoLTAemp{idx}                     = learningOutput{idx}.rhoLTemp.rhoLTXi.mrhoLTXi;
      handleAxes                         = gobjects(sys_info.K, 2 * sys_info.K);
    otherwise
  end
end
plot_info.phi_resolution                 = 1001; 
% go through each (k1, k2) pair
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if strcmp(plot_info.phi_type, 'energy')
      axis_handle                        = subplot(sys_info.K, sys_info.K, (k1 - 1) * sys_info.K + k2); % put all interaction comparisons in some big fig
    else
      axis_handle                        = subplot(sys_info.K, 2 * sys_info.K, (k1 - 1) * 2 * sys_info.K + 2 * k2 - 1);
    end            
    rhoLT                                = get_single_rhoLT(rhoLTR, k1, k2);
    for ind = 1 : total_num_trials
      rhoLTemp{ind}                      = get_single_rhoLT(rhoLTRemp{ind}, k1, k2);
      phihat                             = all_phihat{ind};
      phihats{ind}                       = phihat{k1, k2};
      phihatsmooth                       = all_phihatsmooth{ind};
      phihatsmooths{ind}                 = phihatsmooth{k1, k2};
    end
    plot_interactions_and_rhos(win_handler, axis_handle, rhoLT, rhoLTemp, phi{k1, k2}, phihats, phihatsmooths, k1, k2, sys_info, plot_info);
    if k1 == sys_info.K
      xlabel('$r$ (pairwise distance)','FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name, 'Interpreter', 'latex');
    end
    if plot_info.showplottitles
      titleHandle = title(sprintf('N = %d, T = %.0f, M = %d, L = %d, n = %d', sys_info.N, obs_info.T_L, obs_info.M, obs_info.L, basis_info.n(k_1,k_2)), 'FontSize', plot_info.title_font_size);
      set(titleHandle, 'Position', get(titleHandle,'Position') .* [1, 0.95, 1]);
      set(titleHandle, 'Interpreter', 'Latex', 'FontSize', plot_info.title_font_size,'FontName', plot_info.title_font_name, 'FontWeight', 'bold' );
    end    
    if strcmp(plot_info.phi_type, 'energy'), handleAxes(k1, k2) = axis_handle; else, handleAxes(k1, 2 * k2 - 1) = axis_handle; end
    if ~strcmp(plot_info.phi_type, 'energy')
      ax                                 = subplot(sys_info.K, 2 * sys_info.K, (k_1 - 1) * 2 * sys_info.K + 2 * k_2); 
      yyaxis right;
      rhoLT                              = get_single_rhoLT(rhoLTA);
      for ind = 1 : total_num_trials
        rhoLTemp{ind}                    = get_single_rhoLT(rhoLTAemp{ind}, k1, k2);
      end
      range                              = get_range_from_rhos(rhoLTemp);
      [rhoPlotHandles, rhoPlotNames]     = plot_rhos(win_handler, ax, range, rhoLT, rhoLTemp, k1, k2, sys_info, plot_info); 
      legendHandle                       = legend(rhoPlotHandles, rhoPlotNames);
      set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size, 'FontName', plot_info.legend_font_name);
      if k_1==sys_info.K
        if strcmp(plot_info.phi_type, 'alignment')
          xlabelHandle                   = xlabel('$\dot{r}$ (pairwise speed)', 'FontSize', plot_info.axis_font_size);
        elseif strcmp(plot_info.phi_type, 'xi')
          xlabelHandle                   = xlabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'FontSize', plot_info.axis_font_size);
        end
        set(xlabelHandle, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name); 
      end        
      handleAxes(k1, 2 * k2) = gca;      
    end
  end
end
tightFigaroundAxes(handleAxes);
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if strcmp(plot_info.phi_type, 'energy')
      axis_handle                        = handleAxes(k1, k2);
    else
      axis_handle                        = handleAxes(k1, 2 * k2 - 1);
    end
    axis_handle.YAxis(1).TickLabelFormat = '%.2g';
  end
end
end