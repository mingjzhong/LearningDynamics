function plot_rhos_joint_distribution(win_handler, range, rho_range, rhoLTR, rhoLTMRs, rhoLTX, ...
         rhoLTMXs, rhoLTRX, rhoLTMRXs, sys_info, plot_info)
% function plot_rhos_joint_distribution(win_handler, rho_range, rhoLTRX, rhoLTMRX, K, plot_info)

% (c) M. Zhong (JHU)

% put plots on this particular window
set(groot, 'CurrentFigure', win_handler);
% initialize the storage
handleAxes                           = gobjects(3 * sys_info.K, 2 * sys_info.K);
n_trials                             = length(rhoLTMRs);
rhoLTMRsCk1Ck2                       = cell(1, n_trials);
rhoLTMXsCk1Ck2                       = cell(1, n_trials);
rhoLTMRXsCk1Ck2                      = cell(1, n_trials);
color_LT                             = [0.8500, 0.3250, 0.0980];
plot_info.rho_color                  = color_LT;
% go through each (k1, k2) pair
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
% get the corresponding rhoLTMs
    for ind = 1 : n_trials
      rhoLTMRsCk1Ck2{ind}            = rhoLTMRs{ind}{k1, k2};
      rhoLTMXsCk1Ck2{ind}            = rhoLTMXs{ind}{k1, k2};
      rhoLTMRXsCk1Ck2{ind}           = rhoLTMRXs{ind}{k1, k2};
    end
% plots for the various (approximated) true \rho^L_T, \rho^L_{T, r} first
    subplot(3 * sys_info.K, 2 * sys_info.K, (k1 - 1) * 2 * sys_info.K + (k2 - 1) * 2 + 1);                                                                                   
    ax                  = gca();                                                                    % display \rho^L_T and its estimator
    if size(range{k1, k2}, 1) == 1
      r_range           = range{k1, k2};
    else
      r_range           = range{k1, k2}(1, :);
    end
    [~, ~, eff_range1]  = plot_rhos_marginal_Ck1Ck2(win_handler, ax, r_range, rhoLTR{k1, k2}, [], k1, k2, sys_info, plot_info);
    xlabel('$r$ (pairwise distance)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    if sys_info.K == 1
      ylabel('$\rho^L_{T, r}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    else
      ylabel(['$\rho_{T, r}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    end
    handleAxes((k1 - 1) * 3 + 1, (k2 - 1) * 2 * sys_info.K + 1) = ax;
% \rho^L_{T, \dor{r}} or \rho^L_{T, \xi} second    
    subplot(3 * sys_info.K, 2 * sys_info.K, (k1 - 1) * 2 * sys_info.K + (k2 - 1 + sys_info.K) * 2 + 1);                                                                                     
    ax                  = gca();                                                                    % display \rho^L_T and its estimator
    if size(rho_range{k1, k2}, 1) == 1
      s_range           = rho_range{k1, k2};
    else
      s_range           = rho_range{k1, k2}(2, :);
    end
    [~, ~, eff_range2]  = plot_rhos_marginal_Ck1Ck2(win_handler, ax, s_range, rhoLTX{k1, k2}, [], k1, k2, sys_info, plot_info);
    if strcmp(plot_info.phi_type, 'energy') && contains(sys_info.name, 'SynchronizedOscillatorDynamics')
      xlabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if sys_info.K == 1
        ylabel('$\rho^L_{T, \xi}$',    'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \xi}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end      
    elseif strcmp(plot_info.phi_type, 'alignment')
      xlabel('$\dot{r}$ (pairwise speed)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if sys_info.K == 1
        ylabel('$\rho^L_{T, \dot{r}}$',    'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \dot{r}}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    elseif strcmp(plot_info.phi_type, 'xi')
      xlabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if sys_info.K == 1
        ylabel('$\rho^L_{T, \xi}$',             'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \xi}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    end
    handleAxes((k1 - 1) * 3 + 2, (k2 - 1) * 2 * sys_info.K + 1) = ax;
% joint \rho^L_{T, r, \dot{r}} or \rho^L_{T, r, \xi}
    subplot(3 * sys_info.K, 2 * sys_info.K, (k1 - 1) * 2 * sys_info.K + (k2 - 1 + 2 * sys_info.K) * 2 + 1);  
    ax                  = gca();                                                                    % display \rho^L_T and its estimator
    plot_info.eff_range = {eff_range1, eff_range2};
    plot_rhos_marginal_Ck1Ck2_2D(win_handler, ax, r_range, s_range, rhoLTRX{k1, k2}, ...
      k1, k2, 'rhoLT', sys_info, plot_info);    
    xlabel('$r$ (pairwise distance)',           'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    if strcmp(plot_info.phi_type, 'energy') && contains(sys_info.name, 'SynchronizedOscillatorDynamics')
      ylabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    elseif strcmp(plot_info.phi_type, 'alignment')
      ylabel('$\dot{r}$ (pairwise speed)',      'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    elseif strcmp(plot_info.phi_type, 'xi')
      ylabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    end 
    handleAxes((k1 - 1) * 3 + 3, (k2 - 1) * 2 * sys_info.K + 1) = ax;
% plots for the various empirical \rho^{L, M}_T, \rho^{L, M}_{T, r} first
    subplot(3 * sys_info.K, 2 * sys_info.K, (k1 - 1) * 2 * sys_info.K + (k2 - 1) * 2 + 2);
    ax                  = gca();                                                                    % display \rho^L_T and its estimator
    if size(range{k1, k2}, 1) == 1
      r_range           = range{k1, k2};
    else
      r_range           = range{k1, k2}(1, :);
    end
    [~, ~, eff_range1]  = plot_rhos_marginal_Ck1Ck2(win_handler, ax, r_range, [], rhoLTMRsCk1Ck2, k1, k2, sys_info, plot_info);
    xlabel('$r$ (pairwise distance)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    if sys_info.K == 1
      ylabel('$\rho^{L, M}_{T, r}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    else
      ylabel(['$\rho_{T, r}^{T, M, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    end
    handleAxes((k1 - 1) * 3 + 1, (k2 - 1) * 2 * sys_info.K + 2) = ax;
% \rho^{L, M}_{T, \dor{r}} or \rho^{L, M}_{T, \xi} second    
    subplot(3 * sys_info.K, 2 * sys_info.K, (k1 - 1) * 2 * sys_info.K + (k2 - 1 + sys_info.K) * 2 + 2); 
    ax                  = gca();                                                                    % display \rho^L_T and its estimator
    if size(rho_range{k1, k2}, 1) == 1
      s_range           = rho_range{k1, k2};
    else
      s_range           = rho_range{k1, k2}(2, :);
    end    
    [~, ~, eff_range2]  = plot_rhos_marginal_Ck1Ck2(win_handler, ax, s_range, [], rhoLTMXsCk1Ck2, k1, k2, sys_info, plot_info);
    if strcmp(plot_info.phi_type, 'energy') && contains(sys_info.name, 'SynchronizedOscillatorDynamics')
      xlabel('$\dot{r}$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if sys_info.K == 1
        ylabel('$\rho^{L, M}_{T, \xi}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \xi}^{T, M, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end      
    elseif strcmp(plot_info.phi_type, 'alignment')
      xlabel('$\dot{r}$ (pairwise speed)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if sys_info.K == 1
        ylabel('$\rho^{L, M}_{T, \dot{r}}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \dot{r}}^{T, M, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    elseif strcmp(plot_info.phi_type, 'xi')
      xlabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if sys_info.K == 1
        ylabel('$\rho^{L, M}_{T, \xi}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \xi}^{T, M, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    end
    handleAxes((k1 - 1) * 3 + 2, (k2 - 1) * 2 * sys_info.K + 2) = ax;
% joint \rho^{L, M}_{T, r, \dot{r}} or \rho^{L, M}_{T, r, \xi}
    subplot(3 * sys_info.K, 2 * sys_info.K, (k1 - 1) * 2 * sys_info.K + (k2 - 1 + 2 * sys_info.K) * 2 + 2); 
    ax                  = gca();                                                                    % display \rho^L_T and its estimator
    plot_info.eff_range = {eff_range1, eff_range2};
    plot_rhos_marginal_Ck1Ck2_2D(win_handler, ax, r_range, s_range, rhoLTMRXsCk1Ck2, ...
      k1, k2, 'rhoLTM', sys_info, plot_info);
    xlabel('$r$ (pairwise distance)',           'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    if strcmp(plot_info.phi_type, 'energy') && contains(sys_info.name, 'SynchronizedOscillatorDynamics')
      ylabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    elseif strcmp(plot_info.phi_type, 'alignment')
      ylabel('$\dot{r}$ (pairwise speed)',      'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    elseif strcmp(plot_info.phi_type, 'xi')
      ylabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    end
    handleAxes((k1 - 1) * 3 + 3, (k2 - 1) * 2 * sys_info.K + 2) = ax;
  end
end
%
tightFigaroundAxes(handleAxes);
end
