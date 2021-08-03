function plot_phis_and_rhos_each_type(win_handler, range, rho_range, phi, phihats, rhoLTR, ...
         rhoLTMRs, rhoLTX, rhoLTMXs, sys_info, plot_info)
% function plot_phis_and_rhos_each_type(win_handler, range, rho_range, phi, phihats, rhoLTR, ...
%          rhoLTMRs, rhoLTX, rhoLTMXs, sys_info, plot_info)

% (c) M. Zhong (JHU)

% put plots on this particular window
set(groot, 'CurrentFigure', win_handler);
% parameters for plotting
n_trials                                 = length(phihats); 
phihatsCk1Ck2                            = cell(1, n_trials); 
rhoLTMRsCk1Ck2                           = cell(1, n_trials); 
rhoLTMXsCk1Ck2                           = cell(1, n_trials);
is_SOD                                   = contains(sys_info.name, 'SynchronizedOscillatorDynamics');
phiE_2D                                  = isfield(sys_info, 'projE') && ~isempty(sys_info.projE);
for idx = 1 : n_trials
  switch plot_info.phi_type
    case 'energy'
      handleAxes                         = gobjects(sys_info.K);
    case 'alignment'
      handleAxes                         = gobjects(sys_info.K, 2 * sys_info.K);
    case 'xi'
      if is_SOD
        handleAxes                       = gobjects(sys_info.K);
      else
        handleAxes                       = gobjects(sys_info.K, 2 * sys_info.K);
      end
    otherwise
      error('');
  end
end
% go through each (k1, k2) pair, put all interaction comparisons in one figure
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if strcmp(plot_info.phi_type, 'energy') || is_SOD
      axis_handle                        = subplot(sys_info.K, sys_info.K, ...
                                          (k1 - 1) * sys_info.K + k2); 
    else
      axis_handle                        = subplot(sys_info.K, 2 * sys_info.K, ...
                                           (k1 - 1) * 2 * sys_info.K + 2 * k2 - 1);
    end
    if ~isempty(rhoLTR), rhoLTRCk1Ck2 = rhoLTR{k1, k2}; else, rhoLTRCk1Ck2 = []; end
    if ~isempty(phi), phiCk1Ck2 = phi{k1, k2}; else, phiCk1Ck2 = []; end
    for ind = 1 : n_trials
      phihatsCk1Ck2{ind}                 = phihats{ind}{k1, k2};
      rhoLTMRsCk1Ck2{ind}                = rhoLTMRs{ind}{k1, k2};
    end
    plot_phis_and_rhos_each_type_Ck1Ck2(win_handler, axis_handle, range{k1, k2}, rhoLTRCk1Ck2, ...
      rhoLTMRsCk1Ck2, phiCk1Ck2, phihatsCk1Ck2, k1, k2, sys_info, plot_info);
    if k1 == sys_info.K
      if ~isfield(plot_info, 'showlabels') || isempty(plot_info.showlabels) || plot_info.showlabels
        xlabel('$r$ (pairwise distance)','FontSize', plot_info.axis_font_size, 'FontName', ...
          plot_info.axis_font_name, 'Interpreter', 'latex');
      end
      if is_SOD
        ylabel('$\xi$ (pairwise $\xi_{i, i''}$)','FontSize', plot_info.axis_font_size, ...
          'FontName', plot_info.axis_font_name, 'Interpreter', 'latex');        
      else
        if strcmp(plot_info.phi_type, 'energy') && phiE_2D
          ylabel('$s$ (pairwise $s_{i, i''}^E$)','FontSize', plot_info.axis_font_size, ...
            'FontName', plot_info.axis_font_name, 'Interpreter', 'latex');         
        end
      end
    end
    if plot_info.showplottitles
      titleHandle = title(sprintf('N = %d, T = %.0f, M = %d, L = %d, n = %d', sys_info.N, ...
        obs_info.T_L, obs_info.M, obs_info.L, basis_info.n(k_1,k_2)), 'FontSize', ...
        plot_info.title_font_size);
      set(titleHandle, 'Position', get(titleHandle,'Position') .* [1, 0.95, 1]);
      set(titleHandle, 'Interpreter', 'Latex', 'FontSize', plot_info.title_font_size, ...
        'FontName', plot_info.title_font_name, 'FontWeight', 'bold' );
    end    
    if strcmp(plot_info.phi_type, 'energy'), handleAxes(k1, k2) = axis_handle; 
    else, handleAxes(k1, 2 * k2 - 1) = axis_handle; end
    if ~strcmp(plot_info.phi_type, 'energy') && ~is_SOD
      ax                                 = subplot(sys_info.K, 2 * sys_info.K, ...
                                          (k1 - 1) * 2 * sys_info.K + 2 * k2); 
      yyaxis right;
      if ~isempty(rhoLTX), rhoLTXCk1Ck2 = rhoLTX{k1, k2}; else, rhoLTXCk1Ck2 = []; end
      for ind = 1 : n_trials
        rhoLTMXsCk1Ck2{ind}              = rhoLTMXs{ind}{k1, k2};
      end
      plot_info.rho_type                 = plot_info.phi_type;
      [rhoPlotHandles, rhoPlotNames]     = plot_rhos_marginal_Ck1Ck2(win_handler, ax, ...
                                           rho_range{k1, k2}, rhoLTXCk1Ck2, rhoLTMXsCk1Ck2, ...
                                           k1, k2, sys_info, plot_info); 
      if plot_info.showplotlegends
        legendHandle                     = legend(rhoPlotHandles, rhoPlotNames);
        set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', ...
          plot_info.legend_font_size, 'FontName', plot_info.legend_font_name);
      end
      if k1 == sys_info.K
        if strcmp(plot_info.phi_type, 'alignment')
          xlabelHandle                   = xlabel('$\dot{r}$ (pairwise speed)', 'FontSize', ...
                                           plot_info.axis_font_size);
        elseif strcmp(plot_info.phi_type, 'xi')
          xlabelHandle                   = xlabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'FontSize', ...
                                           plot_info.axis_font_size);
        end
        set(xlabelHandle, 'Interpreter', 'latex', 'FontName', plot_info.axis_font_name); 
      end        
      handleAxes(k1, 2 * k2)             = gca;      
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