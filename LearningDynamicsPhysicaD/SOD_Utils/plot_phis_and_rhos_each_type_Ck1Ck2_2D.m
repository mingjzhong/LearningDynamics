function plot_phis_and_rhos_each_type_Ck1Ck2_2D(fig_handle, axis_handle, range, phi, phihats, phihatsmooths, k1, k2, sys_info, plot_info)
% function plot_phis_and_rhos_each_type_Ck1Ck2_2D(fig_handle, axis_handle, range, phi, phihats, phihatsmooths, k1, k2, sys_info, plot_info)

% (C) M. Zhong

set(fig_handle, 'CurrentAxes', axis_handle);                                                        % draw on the given axis
n_trials                       = length(phihats);
r_range                        = range(1, :);
s_range                        = range(2, :);
if r_range(2) < r_range(1) + 10 * eps, r_range(2) = r_range(1) + 1; end
if s_range(2) < s_range(1) + 10 * eps, s_range(2) = s_range(1) + 1; end
r                              = linspace(r_range(1), r_range(2), plot_info.phi_resolution(k1, k2));
s                              = linspace(s_range(1), s_range(2), plot_info.phi_resolution(k1, k2));
[R, S]                         = ndgrid(r, s);
if ~isempty(phi), phirs = phi(R, S); else, phirs = []; end
phihatrs                       = zeros(n_trials, length(r), length(s));
phihatsmoothrs                 = zeros(n_trials, length(r), length(s));
for ind                        = 1 : n_trials
  phihat                       = phihats{ind};
  phihatrs(ind, :, :)          = phihat(R, S);
  if plot_info.display_interpolant
    phihatsmooth               = phihatsmooths{ind};
    phihatsmoothrs(ind, :, :)  = phihatsmooth(R, S);
  else
    phihatsmoothrs(ind, :, :)  = phihatrs(ind, :, :);
  end 
end
z_min                          = max([min(phirs(phirs > -Inf)), min(phihatrs(phihatrs > -Inf)), min(phihatsmoothrs(phihatsmoothrs > -Inf))]); % find out the range for y values, f1 might have blow up, just use f_hat
z_max                          = min([max(phirs(phirs <  Inf)), max(phihatrs(phihatrs <  Inf)), max(phihatsmoothrs(phihatsmoothrs <  Inf))]);
if z_max < z_min
  z_min                        = min([min(phirs(phirs > -Inf)), min(phihatrs(phihatrs > -Inf)), min(phihatsmoothrs(phihatsmoothrs > -Inf))]);  % find out the range for y values, f1 might have blow up, just use f_hat
  z_max                        = max([max(phirs(phirs <  Inf)), max(phihatrs(phihatrs <  Inf)), max(phihatsmoothrs(phihatsmoothrs <  Inf))]);  
else
  if z_max < z_min +  10 * eps, z_max = z_min + 1; z_min = z_min - 1; end
end                                                                                                 % display interaction kernels
if plot_info.display_interpolant && plot_info.display_phihat, num_PPH = 3; else, num_PPH = 2; end                        
if isempty(phirs), num_PPH = num_PPH - 1; end
phiPlotHandles                 = gobjects(1, num_PPH);
phiPlotNames                   = cell(1, num_PPH);
PPH_count                      = 0; 
if ~isempty(phirs)
  PPH_count                    = PPH_count + 1;
  phiPlotHandles(PPH_count)    = surf(R, S, phirs, 'FaceColor', 'k', 'FaceAlpha', 0.6, 'EdgeColor', 'none');
  hold on;                                                                                          % plot the true phi, put on a hold
  phiPlotNames{PPH_count}      = get_legend_name_for_phis(sys_info, plot_info, 'phi', k1, k2);
%  surf(R, S, zeros(size(R)), 'FaceColor', 'g', 'FaceAlpha', '0.4', 'EdgeColor', 'none');           % add a x-axis
else
  surf(R, S, zeros(size(R)), 'FaceColor', 'g', 'FaceAlpha', 0.6, 'EdgeColor', 'none');              % add a x-axis, put on a hold
end
ax                             = gca();
ax.FontSize                    = plot_info.tick_font_size;
ax.FontName                    = plot_info.tick_font_name;  
if plot_info.display_phihat || ~plot_info.display_interpolant
  PPH_count                    = PPH_count + 1;
  phiPlotHandles(PPH_count)    = surf(R, S, squeeze(mean(phihatrs, 1)), 'FaceColor', 'b', 'FaceAlpha', 0.6, 'EdgeColor', 'none'); % plot the learned phi
  phiPlotNames{PPH_count}      = get_legend_name_for_phis(sys_info, plot_info, 'phihat', k1, k2);
%   plot(r, mean(phihatrs, 1) + std(phihatrs, [], 1), '--r', 'LineWidth', plot_info.phihat_line_width/4);
%   plot(r, mean(phihatrs, 1) - std(phihatrs, [], 1), '--r', 'LineWidth', plot_info.phihat_line_width/4);
end
if plot_info.display_interpolant
  PPH_count                    = PPH_count + 1;
  phiPlotHandles(PPH_count)    = surf(R, S, squeeze(mean(phihatrs, 1)), 'FaceColor', 'b', 'FaceAlpha', 0.6, 'EdgeColor', 'none'); % plot the smoothed phi
  if ~plot_info.display_phihat
    phiPlotNames{PPH_count}    = get_legend_name_for_phis(sys_info, plot_info, 'phihat', k1, k2);         
  else
    phiPlotNames{PPH_count}    = get_legend_name_for_phis(sys_info, plot_info, 'phihatsmooth', k1, k2);                 
  end
%   plot(r, mean(phihatsmoothrs, 1) + std(phihatsmoothrs, [], 1), '--b', 'LineWidth', plot_info.phihat_line_width/4);
%   plot(r, mean(phihatsmoothrs, 1) - std(phihatsmoothrs, [], 1), '--b', 'LineWidth', plot_info.phihat_line_width/4);
end
legendHandle                   = legend(phiPlotHandles, phiPlotNames);
set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size, 'FontName', plot_info.legend_font_name);
z_range                        = z_max - z_min;
z_min                          = z_min - z_range * 0.1;
z_max                          = z_max + z_range * 0.1;
axis([r_range(1), r_range(2), s_range(1), s_range(2), z_min, z_max]);                               % set up a uniform x-range, tighten the y-range
the_max                        = max(abs([z_min, z_max]));
ax.YAxis(1).Exponent           = get_exponent_scale(the_max);
ax.YAxis(1).TickLabelFormat    = '%+.2g';
end  