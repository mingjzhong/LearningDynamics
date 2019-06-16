function plot_interactions_and_rhos(fig_handle, axis_handle, rhoLT, rhoLTemp, phi, phihats, phihatsmooths, k1, k2, sys_info, plot_info)
% function plot_interactions_and_rhos(fig_handle, axis_handle, rhoLT, rhoLTemp, phi, phihats, phihatsmooths, k1, k2, sys_info, plot_info)

% (c) M. Zhong (JHU)

set(fig_handle, 'CurrentAxes', axis_handle);                                                        % draw on the given axis
total_num_trials               = length(rhoLTemp);
range                          = get_range_from_rhos(rhoLTemp);
if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
r                              = linspace(range(1), range(2), plot_info.phi_resolution);
if ~isempty(phi), phir = phi(r); else, phir = []; end
phihatr                        = zeros(total_num_trials, length(r));
phihatsmoothr                  = zeros(total_num_trials, length(r));
for ind                        = 1 : total_num_trials
  phihat                       = phihats{ind};
  phihatr(ind, :)              = phihat(r);
  if plot_info.display_interpolant
    phihatsmooth               = phihatsmooths{ind};
    phihatsmoothr(ind, :)      = phihatsmooth(r);
  else
    phihatsmoothr(ind, :)      = phihatr(ind, :);
  end 
end
y_min                          = max([min(phir(phir > -Inf)), min(phihatr(:)),             min(phihatsmoothr(phihatsmoothr > -Inf))]);                                                                       % find out the range for y values, f1 might have blow up, just use f_hat
y_max                          = min([max(phir(phir <  Inf)), max(phihatr(phihatr < Inf)), max(phihatsmoothr(phihatsmoothr <  Inf))]);
if y_max < y_min +  10 * eps, y_max = y_min + 1; y_min = y_min - 1; end
yyaxis right;                                                                                       % display \rho^L_T and its estimator
ax                             = gca();
[rhoPlotHandles, rhoPlotNames] = plot_rhos(fig_handle, ax, range, rhoLT, rhoLTemp, k1, k2, sys_info, plot_info);
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
if plot_info.display_phihat || ~plot_info.display_interpolant
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
legendHandle                   = legend([phiPlotHandles, rhoPlotHandles], [phiPlotNames, rhoPlotNames]);
set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size, 'FontName', plot_info.legend_font_name);
y_range                        = y_max - y_min;
y_min                          = y_min - y_range * 0.1;
y_max                          = y_max + y_range * 0.1;
axis([range(1), range(2), y_min, y_max]);                                                           % set up a uniform x-range, tighten the y-range
the_max                        = max(abs([y_min, y_max]));
ax.YAxis(1).Exponent           = get_exponent_scale(the_max);
ax.YAxis(1).TickLabelFormat    = '%+.2g';
end  