function plot_phis_and_rhos_each_type_Ck1Ck2_1D(fig_handle, axis_handle, r_range, rhoLT, rhoLTM, ...
         phi, phihats, phihatsmooths, k1, k2, sys_info, plot_info)
% function plot_phis_and_rhos_each_type_Ck1Ck2_1D(fig_handle, axis_handle, r_range, rhoLT, rhoLTM, ...
% phi, phihats, phihatsmooths, phihatregs, k1, k2, sys_info, plot_info)

% (C) M. Zhong

set(fig_handle, 'CurrentAxes', axis_handle);                                                        % draw on the given axis
n_trials                       = length(phihats);
if r_range(2) < r_range(1) + 10 * eps, r_range(2) = r_range(1) + 1; end
r                              = linspace(r_range(1), r_range(2), plot_info.phi_resolution(k1, k2));
if ~isempty(phi), phir = phi(r); else, phir = []; end
phihatr                        = zeros(n_trials, length(r));
phihatsmoothr                  = zeros(n_trials, length(r));
for ind                        = 1 : n_trials
  if plot_info.display_phihat
    phihat                     = phihats{ind};
    phihatr(ind, :)            = phihat(r);
  end
  if plot_info.display_interpolant
    phihatsmooth               = phihatsmooths{ind};
    phihatsmoothr(ind, :)      = phihatsmooth(r);
  end 
end
phir_min                       = min(phir(phir > -Inf));
phir_max                       = max(phir(phir <  Inf));
if plot_info.display_interpolant && plot_info.display_phihat
  phihatr_min                  = min(phihatr(phihatr > -Inf));
  phihatr_max                  = max(phihatr(phihatr <  Inf));
  phihatsmoothr_min            = min(phihatsmoothr(phihatsmoothr > -Inf));
  phihatsmoothr_max            = max(phihatsmoothr(phihatsmoothr <  Inf));
elseif plot_info.display_interpolant && ~plot_info.display_phihat
  phihatr_min                  = [];
  phihatr_max                  = [];
  phihatsmoothr_min            = min(phihatsmoothr(phihatsmoothr > -Inf));
  phihatsmoothr_max            = max(phihatsmoothr(phihatsmoothr <  Inf));
elseif ~plot_info.display_interpolant && plot_info.display_phihat
  phihatr_min                  = min(phihatr(phihatr > -Inf));
  phihatr_max                  = max(phihatr(phihatr <  Inf));
  phihatsmoothr_min            = [];
  phihatsmoothr_max            = [];
end
y_min                          = max([phir_min, phihatr_min, phihatsmoothr_min]);                   % find out the range for y values, f1 might have blow up, just use f_hat
y_max                          = min([phir_max, phihatr_max, phihatsmoothr_max]);
if y_max < y_min
  y_min                        = min([phir_min, phihatr_min, phihatsmoothr_min]);                   % in the case of phihat/phihatsmooth above or blow phi
  y_max                        = max([phir_max, phihatr_max, phihatsmoothr_max]);  
else
  if y_max < y_min +  10 * eps, y_max = y_min + 1; y_min = y_min - 1; end
end
yyaxis right;                                                                                       % display \rho^L_T and its estimator
ax                             = gca();
plot_info.rho_type             = 'energy';
[rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2(fig_handle, ax, r_range, rhoLT, rhoLTM, k1, k2, sys_info, plot_info);
yyaxis left                                                                                         % display interaction kernels
ax                             = gca();
ax.FontSize                    = plot_info.tick_font_size;
ax.FontName                    = plot_info.tick_font_name;  
if plot_info.display_interpolant && plot_info.display_phihat, num_PPH = 3; else, num_PPH = 2; end                        
if isempty(phir), num_PPH = num_PPH - 1; end
phiPlotHandles                 = gobjects(1, num_PPH);
phiPlotNames                   = cell(1, num_PPH);
PPH_count                      = 0; 
if ~isempty(phir)
  PPH_count                    = PPH_count + 1;
  phiPlotHandles(PPH_count)    = plot(r, phir, 'k', 'LineWidth', plot_info.phi_line_width); hold on;% plot the true phi, put on a hold
  phiPlotNames{PPH_count}      = get_legend_name_for_phis(sys_info, plot_info, 'phi', k1, k2);
  plot(r, zeros(size(r)), 'k--');                                                                   % add a x-axis
else
  plot(r, zeros(size(r)), 'k--'); hold on;                                                          % add a x-axis, put on a hold
end
if plot_info.display_phihat %|| ~plot_info.display_interpolant
  PPH_count                    = PPH_count + 1;
  phiPlotHandles(PPH_count)    = plot(r, mean(phihatr,1), '-r', 'LineWidth', plot_info.phihat_line_width);% plot the learned phi
  phiPlotNames{PPH_count}      = get_legend_name_for_phis(sys_info, plot_info, 'phihat', k1, k2);
  plot(r, mean(phihatr, 1) + std(phihatr, [], 1), '--r', 'LineWidth', plot_info.phihat_line_width/4);
  plot(r, mean(phihatr, 1) - std(phihatr, [], 1), '--r', 'LineWidth', plot_info.phihat_line_width/4);
end
if plot_info.display_interpolant
  PPH_count                    = PPH_count + 1;
  phiPlotHandles(PPH_count)    = plot(r, mean(phihatsmoothr,1),  '-b', 'LineWidth', plot_info.phihat_line_width);% plot the learned phi, smoothed
  if ~plot_info.display_phihat
    phiPlotNames{PPH_count}    = get_legend_name_for_phis(sys_info, plot_info, 'phihat', k1, k2);         
  else
    phiPlotNames{PPH_count}    = get_legend_name_for_phis(sys_info, plot_info, 'phihatsmooth', k1, k2);                 
  end
  plot(r, mean(phihatsmoothr, 1) + std(phihatsmoothr, [], 1), '--b', 'LineWidth', plot_info.phihat_line_width/4);
  plot(r, mean(phihatsmoothr, 1) - std(phihatsmoothr, [], 1), '--b', 'LineWidth', plot_info.phihat_line_width/4);
end
if plot_info.showplotlegends
  legendHandle                 = legend([phiPlotHandles, rhoPlotHandles], [phiPlotNames, rhoPlotNames]);
  set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', ...
    plot_info.legend_font_size, 'FontName', plot_info.legend_font_name);
end
y_range                        = y_max - y_min;
y_min                          = y_min - y_range * 0.1;
y_max                          = y_max + y_range * 0.1;
axis([r_range(1), r_range(2), y_min, y_max]);                                                       % set up a uniform x-range, tighten the y-range
the_max                        = max(abs([y_min, y_max]));
ax.YAxis(1).Exponent           = get_exponent_scale(the_max);
ax.YAxis(1).TickLabelFormat    = '%+.2g';
end  