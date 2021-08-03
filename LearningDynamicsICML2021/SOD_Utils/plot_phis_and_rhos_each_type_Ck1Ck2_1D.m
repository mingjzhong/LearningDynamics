function plot_phis_and_rhos_each_type_Ck1Ck2_1D(fig_handle, axis_handle, r_range, rhoLT, rhoLTM, ...
         phi, phihats, k1, k2, sys_info, plot_info)
% function plot_phis_and_rhos_each_type_Ck1Ck2_1D(fig_handle, axis_handle, r_range, rhoLT, rhoLTM, ...
% phi, phihats, k1, k2, sys_info, plot_info)

% (C) M. Zhong

set(fig_handle, 'CurrentAxes', axis_handle);                                                        % draw on the given axis
n_trials                       = length(phihats);
if ~isfield(plot_info, 'bg_trans') || isempty(plot_info.bg_trans)
  plot_info.bg_trans           = 0.1;
end
if r_range(2) < r_range(1) + 10 * eps, r_range(2) = r_range(1) + 1; end
r                              = linspace(r_range(1), r_range(2), plot_info.phi_resolution(k1, k2));
if ~isempty(phi), phir = phi(r); else, phir = []; end
if isfield(sys_info, 'F_EIH') && ~isempty(sys_info.F_EIH) && ~isempty(sys_info.F_EIH{k1, k2})
  has_EIH                      = true;
else
  has_EIH                      = false;
end
if has_EIH
  phir_max                     = (sys_info.F_EIH{k1, k2}{1}(r) - sys_info.phiE{k1, k2}(r))...
                                 ./sys_info.phiE{k1, k2}(r);
  phir_min                     = (sys_info.F_EIH{k1, k2}{2}(r) - sys_info.phiE{k1, k2}(r))...
                                 ./sys_info.phiE{k1, k2}(r);  
  phir                         = [];
end
phihatr                        = zeros(n_trials, length(r));
for ind                        = 1 : n_trials
  phihat                       = phihats{ind};
  if has_EIH
    phihatr(ind, :)            = (phihat(r) - sys_info.phiE{k1, k2}(r))./sys_info.phiE{k1, k2}(r);
  else
    phihatr(ind, :)            = phihat(r);
  end
end
if has_EIH
  phi_min                      = min([phir_max(phir_max > -Inf), phir_min(phir_min > -Inf)]);
  phi_max                      = max([phir_max(phir_max < Inf), phir_min(phir_min < Inf)]);  
else
  phi_min                      = min(phir(phir > -Inf));
  phi_max                      = max(phir(phir <  Inf));  
end

phihatr_min                    = min(phihatr(phihatr > -Inf));
phihatr_max                    = max(phihatr(phihatr <  Inf));
y_min                          = min([phi_min, phihatr_min]);
y_max                          = max([phi_max, phihatr_max]);
if y_max < y_min +  10 * eps, y_max = y_min + 1; y_min = y_min - 1; end
% y_min                          = max([phir_min, phihatr_min]);                                      % find out the range for y values, f1 might have blow up, just use f_hat
% y_max                          = min([phir_max, phihatr_max]);
% if y_max < y_min
%   y_min                        = min([phir_min, phihatr_min]);                                      % in the case of phihat/phihatsmooth above or blow phi
%   y_max                        = max([phir_max, phihatr_max]);  
% elseif y_max == y_min
%   y_max                        = y_min + 0.5; 
%   y_min                        = y_min - 0.5;
% else
%   if y_max < y_min +  10 * eps, y_max = y_min + 1; y_min = y_min - 1; end
% end
ax                             = gca();
ax.FontSize                    = plot_info.tick_font_size;
ax.FontName                    = plot_info.tick_font_name; 
num_PPH                        = 3; 
if ~has_EIH
  if isempty(phir), num_PPH = num_PPH - 1; end
end
phiPlotHandles                 = gobjects(1, num_PPH);
phiPlotNames                   = cell(1, num_PPH);
PPH_count                      = 0; 
if has_EIH
  bg_color                     = plot_info.bg_colors(1, :);
  PPH_count                    = PPH_count + 1;
  LH                           = plot(r, phir_max, '-.', 'LineWidth', plot_info.phi_line_width); 
  LH.Color                     = [bg_color, 0.8 * plot_info.bg_trans]; % same color as the background for the range
  phiPlotNames{PPH_count}      = 'EIH Range';
  hold on;
  LH                           = plot(r, phir_min, '-.', 'LineWidth', plot_info.phi_line_width); 
  LH.Color                     = [bg_color, 0.8 * plot_info.bg_trans]; % also with the same transparency
  phiPlotHandles(PPH_count)    = fill([r, fliplr(r)], [phir_max, fliplr(phir_min)], bg_color, ...
                                 'EdgeColor', 'none', 'FaceAlpha', 0.1);
  phiPlotHandles(PPH_count)    = plot(r, zeros(size(r)), 'k-', 'LineWidth', plot_info.phi_line_width); 
  phiPlotNames{PPH_count}      = 'Newton';    
else
  if ~isempty(phir)
    PPH_count                  = PPH_count + 1;
    phiPlotHandles(PPH_count)  = plot(r, phir, 'k', 'LineWidth', plot_info.phi_line_width);         % plot the true phi, put on a hold
    hold on;
    phiPlotNames{PPH_count}    = get_legend_name_for_phis(sys_info, plot_info, 'phi', k1, k2); 
    plot(r, zeros(size(r)), 'k-.');                                                                 % add a x-axis
  else
    plot(r, zeros(size(r)), 'k-.'); hold on;                                                        % add a x-axis, put on a hold
  end  
end
PPH_count                      = PPH_count + 1;
phihat_mean                    = mean(phihatr,1);
phiPlotHandles(PPH_count)      = plot(r, phihat_mean, '--b', 'LineWidth', ...
                                 plot_info.phihat_line_width);% plot the learned phi
phiPlotNames{PPH_count}        = get_legend_name_for_phis(sys_info, plot_info, 'phihat', k1, k2);
if n_trials > 1
  PPH_count                    = PPH_count + 1;
  std_up                       = phihat_mean + std(phihatr, [], 1);
  std_low                      = phihat_mean - std(phihatr, [], 1);
  phiPlotHandles(PPH_count)    = fill([r, fliplr(r)], [std_up, fliplr(std_low)], 'r', ...
                                 'EdgeColor', 'none', 'FaceAlpha', 0.5);
  phiPlotNames{PPH_count}      = ['$I_{std(', erase(phiPlotNames{PPH_count - 1}, ...
                                  '$'), ')}$'];                        
end
y_range                        = y_max - y_min;
y_min                          = y_min - y_range * 0.1;
y_max                          = y_max + y_range * 0.1;
if y_max == y_min, y_min = y_min - 0.05; y_max = y_max + 0.05; end
if isfield(plot_info, 'phi_range') && ~isempty(plot_info.phi_range)
  y_min                        = plot_info.phi_range(1);
  y_max                        = plot_info.phi_range(2);
end
axis([r_range(1), r_range(2), y_min, y_max]);                                                       % set up a uniform x-range, tighten the y-range
if has_EIH
  scale1                       = floor(min(log10(abs(phihat_mean))));
  scale2                       = floor(min(log10(abs(phir_max))));
  scale3                       = floor(min(log10(abs(phir_min))));
  theC                         = min([scale1, scale2, scale3]);
  if isfield(plot_info, 'theC') && ~isempty(plot_info.theC)
    theC                       = plot_info.theC;
  end
  symlog(axis_handle, 'y', theC);
end
yyaxis right;                                                                                       % display \rho^L_T and its estimator
ax                             = gca();
plot_info.rho_type             = 'energy';
[rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2(fig_handle, ax, r_range, rhoLT, ...
                                 rhoLTM, k1, k2, sys_info, plot_info);
ax.YAxis(2).Color              = plot_info.rho_color;
yyaxis left                                                                                         % display interaction kernels
if plot_info.showplotlegends
  legendHandle                 = legend([phiPlotHandles, rhoPlotHandles], [phiPlotNames, rhoPlotNames]);
  set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', ...
    plot_info.legend_font_size, 'FontName', plot_info.legend_font_name);
end
if ~has_EIH
  the_max                      = max(abs([y_min, y_max]));
  ax.YAxis(1).Exponent         = get_exponent_scale(the_max);
  ax.YAxis(1).TickLabelFormat  = '%+.2g';  
end
end  