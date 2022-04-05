function [rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2(fig_handle, ax, x_range, ...
          rhoLT, rhoLTMs, k1, k2, sys_info, plot_info)
% function [rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2(fig_handle, ax, x_range, ...
%           rhoLT, rhoLTMs, k1, k2, sys_info, plot_info)

% (c) M. Zhong (JHU)

set(fig_handle, 'CurrentAxes', ax);
ax.FontSize                   = plot_info.tick_font_size;
ax.FontName                   = plot_info.tick_font_name;
if isfield(plot_info, 'rho_color') && ~isempty(plot_info.rho_color)
  the_color                   = plot_info.rho_color;
else
  the_color                   = get(gca, 'YColor');
end
if ~isempty(rhoLT) && ~isempty(rhoLTMs)
  num_RPH                     = 2; 
else
  if ~isempty(rhoLT) || ~isempty(rhoLTMs)
    num_RPH                   = 1;
  else % both are empty
    num_RPH                   = 2;
  end
end
rhoPlotHandles                = gobjects(1, num_RPH);
rhoPlotNames                  = cell(1, num_RPH);
RPH_count                     = 0;
centers                       = linspace(x_range(1), x_range(2), plot_info.rho_resolution(k1, k2));
n_trials                      = length(rhoLTMs);
rhoLTMs_ctrs                  = zeros(n_trials, length(centers));
if ~isempty(rhoLT)
  RPH_count                   = RPH_count + 1;
  histdata1                   = rhoLT(centers);
  histHandle                  = plot(centers, histdata1,'-k', 'LineWidth', 1); hold on;
  set(histHandle, 'Color', the_color/2);
  rhoPlotHandles(RPH_count)   = fill(centers([1, 1 : end, end]), [0, histdata1, 0], the_color/2, ...
                              'EdgeColor', 'none', 'FaceAlpha', 1.2 * plot_info.bg_trans);
  rhoPlotNames{RPH_count}     = get_legend_name_for_rhos(sys_info, plot_info, 'rhoLT', k1, k2);
else
  histdata1                   = [];
end
if ~isempty(rhoLTMs)
  RPH_count                   = RPH_count + 1;
  for ind = 1 : n_trials
    rhoLTMs_ctrs(ind, :)      = rhoLTMs{ind}(centers);
  end
  histdata2                   = mean(rhoLTMs_ctrs, 1);
  histHandle2                 = plot(centers, histdata2, '--b', 'LineWidth', 1); hold on;
  set(histHandle2, 'Color', the_color);
%   histdata2_std             = std(rhoLTMs_ctrs, [], 1);  
%   std_handle                = plot(centers, histdata2 - histdata2_std, ':b', 'LineWidth', 1/2);
%   set(std_handle, 'Color', the_color);
%   std_handle                = plot(centers, histdata2 + histdata2_std, ':b', 'LineWidth', 1/2);
%   set(std_handle, 'Color', the_color);
  rhoPlotHandles(RPH_count)   = fill(centers([1, 1:end, end]), [0, histdata2, 0], the_color, ...
                                'EdgeColor', 'none', 'FaceAlpha', 1.2 * plot_info.bg_trans);
  rhoPlotNames{RPH_count}     = get_legend_name_for_rhos(sys_info, plot_info, 'rhoLTM', k1, k2);
  axis tight;
else
  histdata2                   = [];
end
tmpmax                        = 0;
if ~isempty(histdata1) && ~isempty(histdata2)
  tmpmax                      = plot_info.rhotscalingdownfactor * max(max(histdata1(:)), ...
                                max(histdata2));
else
  if ~isempty(histdata2)
    tmpmax                    = plot_info.rhotscalingdownfactor * max(histdata2);
  end
  if ~isempty(histdata1)
    tmpmax                    = plot_info.rhotscalingdownfactor * max(histdata1);
  end
  if isempty(histdata1) && isempty(histdata2)
    tmpmax                    = 0;
  end
end
if RPH_count == 0
  centers                     = linspace(0, 1, 101);
  histdata                    = zeros(size(centers));
  histhandle                  = plot(centers, histdata, 'k', 'LineWidth', 1); hold on;
  set(histhandle, 'Color', the_color/2);
  rhoPlotHandles(1)           = fill(centers([1, 1 : end, end]), [0, histdata, 0], the_color/2, ...
                                'EdgeColor', 'none', 'FaceAlpha', 1.2 * plot_info.bg_trans);
  rhoPlotNames{1}             = get_legend_name_for_rhos(sys_info, plot_info, 'rhoLT', k1, k2);
  histhandle                  = plot(centers, histdata, 'b--', 'LineWidth', 1);
  set(histhandle, 'Color', the_color);
  rhoPlotHandles(2)           = fill(centers([1, 1 : end, end]), [0, histdata, 0], the_color, ...
                                'EdgeColor', 'none', 'FaceAlpha', 1.2 * plot_info.bg_trans);
  rhoPlotNames{2}             = get_legend_name_for_rhos(sys_info, plot_info, 'rhoLTM', k1, k2);  
end
if tmpmax==0, tmpmax = 1; end
if isnan(tmpmax), tmpmax = 1; end
if isfield(plot_info, 'rho_max') && ~isempty(plot_info.rho_max)
  tmpmax                      = plot_info.rho_max;
end
axis([x_range(1), x_range(2), 0, tmpmax]);
ind                           = length(ax.YAxis);                    
ax.YAxis(ind).Exponent        = get_exponent_scale(tmpmax);
ax.YAxis(ind).TickLabelFormat = '%.2g'; 
end