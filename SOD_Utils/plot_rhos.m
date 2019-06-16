function [rhoPlotHandles, rhoPlotNames] = plot_rhos(fig_handle, ax, range, rhoLT, rhoLTemp, k1, k2, sys_info, plot_info)
% function [rhoPlotHandles, rhoPlotNames] = plot_rhos(fig_handle, ax, range, rhoLT, rhoLTemp, k1, k2, sys_info, plot_info)

% (c) M. Zhong (JHU)

set(fig_handle, 'CurrentAxes', ax);
ax.FontSize                 = plot_info.tick_font_size;
ax.FontName                 = plot_info.tick_font_name;
the_color                   = get(gca, 'YColor');
if ~isempty(rhoLT), num_RPH = 2; else, num_RPH = 1; end
rhoPlotHandles              = gobjects(1, num_RPH);
rhoPlotNames                = cell(1, num_RPH);
RPH_count                   = 0;
if ~isempty(rhoLT)
  RPH_count                 = RPH_count + 1;
  edges                     = rhoLT.histedges;                                                      % approximated \rho_T^L's
  edges_idxs                = find(range(1) <= edges & edges <= range(2));
  if ~isempty(rhoLT.hist)
    [histdata1,edges]       = downsampleHistCounts(rhoLT.hist(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2);
    centers                 = (edges(1 : end - 1) + edges(2 : end))/2;
  else
    centers                 = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
    histdata1               = zeros(size(centers));
  end
  histHandle                = plot(centers, histdata1,'k','LineWidth',1);    hold on;
  set(histHandle, 'Color', the_color);
  rhoPlotHandles(RPH_count) = fill(centers(([1 1:end end])), [0 histdata1' 0], the_color/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
  rhoPlotNames{RPH_count}   = get_legend_name_for_rhos(sys_info, plot_info, 'rhoLT', k1, k2);
else
  histdata1                 = [];
end
RPH_count                   = RPH_count + 1;
edges                       = rhoLTemp{1}.histedges;                                                % Estimated \rho's
edges_idxs                  = find(range(1) <= edges & edges <= range(2));
if ~isempty(rhoLTemp{1}.hist)
  [histdata2, edges]        = downsampleHistCounts(rhoLTemp{1}.hist(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2);
  centers                   = (edges(1 : end - 1) + edges(2 : end))/2;
else
  centers                   = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
  histdata2                 = zeros(size(centers));
end
histHandle2                 = plot(centers,histdata2,'k--','LineWidth',1);
set(histHandle2, 'Color', the_color);
rhoPlotHandles(RPH_count)   = fill(centers(([1 1:end end])), [0 histdata2' 0], the_color, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
rhoPlotNames{RPH_count}     = get_legend_name_for_rhos(sys_info, plot_info, 'rhoLTemp', k1, k2);
axis tight;
if ~isempty(histdata1)
  tmpmax = plot_info.rhotscalingdownfactor * max(max(histdata1(:)), max(histdata2));
else
  tmpmax = plot_info.rhotscalingdownfactor * max(histdata2);
end
if tmpmax==0, tmpmax = 1; end
if isnan(tmpmax), tmpmax = 1; end
axis([range(1), range(2), 0, tmpmax]);
ax.YAxis(2).Exponent        = get_exponent_scale(tmpmax);
ax.YAxis(2).TickLabelFormat = '%.2g';
end