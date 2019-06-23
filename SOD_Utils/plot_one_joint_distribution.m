function plot_one_joint_distribution(win_handler, jrhoLT, K, plot_info)
% function plot_joint_distribution(win_handler, jrhoLT, K, plot_info)

% (c) M. Zhong (JHU)

% put plots on this particular window
set(groot, 'CurrentFigure', win_handler);
% initialize the storage
handleAxes                           = gobjects(3 * K, K);
color_true                           = [0.8500, 0.3250, 0.0980];
% go through each (k1, k2) pair
for k1 = 1 : K
  for k2 = 1 : K
% plots for the various (approximated) true \rho^L_T, \rho^L_{T, r} first
    subplot(3 * K, K, (k1 - 1) * 3 * K + k2);
    range                            = jrhoLT.rhoLTA.rhoLTR.supp{k1, k2}(1, :);
    edges                            = jrhoLT.rhoLTA.rhoLTR.histedges{k1, k2};
    edges_idxs                       = find(range(1) <= edges & edges <= range(2));
    [histdata,edges]                 = downsampleHistCounts( jrhoLT.rhoLTA.rhoLTR.hist{k1, k2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
    centers                          = (edges(1 : end - 1) + edges(2 : end))/2;
    histHandle                       = plot(centers, histdata, 'k', 'LineWidth', 1);
    set(histHandle, 'Color', color_true);
    fill(centers(([1 1:end end])),[0 histdata' 0], color_true/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    axis tight;
    axesHandle                       = gca();
    tmpmax                           = plot_info.rhotscalingdownfactor * max(histdata(:));
    if tmpmax==0, tmpmax = 1; end
    if isnan(tmpmax), tmpmax = 1; end
    if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
    axis([range(1), range(2), 0, tmpmax]);
    if tmpmax == 1
      Escale                         = 1;
    else 
      Escale                         = int32(log10(tmpmax));
    end
    axesHandle.YAxis.Exponent        = Escale;
    axesHandle.YAxis.TickLabelFormat = '%.2g';
    axesHandle.FontSize   = plot_info.tick_font_size;
    axesHandle.FontName   = plot_info.tick_font_name;
    xlabel('$r$ (pairwise distance)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    if K == 1
      ylabel('$\rho^L_{T, r}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    else
      ylabel(['$\rho_{T, r}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    end
    handleAxes((k1 - 1) * 3 + 1, k2) = axesHandle;
% \rho^L_{T, \dor{r}} or \rho^L_{T, \xi} second    
    subplot(3 * K, K, (k1 - 1) * 3 * K + k2 + K);
    range                            = jrhoLT.rhoLTA.rhoLTDR.supp{k1, k2}(1, :);
    edges                            = jrhoLT.rhoLTA.rhoLTDR.histedges{k1, k2};
    edges_idxs                       = find(range(1) <= edges & edges <= range(2));
    [histdata,edges]                 = downsampleHistCounts( jrhoLT.rhoLTA.rhoLTDR.hist{k1, k2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
    centers                          = (edges(1 : end - 1) + edges(2 : end))/2;
    histHandle                       = plot(centers, histdata, 'k', 'LineWidth', 1);
    set(histHandle, 'Color', color_true);
    fill(centers(([1 1:end end])),[0 histdata' 0], color_true/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    axis tight;
    axesHandle                       = gca();
    tmpmax                           = plot_info.rhotscalingdownfactor * max(histdata(:));
    if tmpmax==0, tmpmax = 1; end
    if isnan(tmpmax), tmpmax = 1; end
    if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
    axis([range(1), range(2), 0, tmpmax]);
    if tmpmax == 1
      Escale                         = 1;
    else 
      Escale                         = int32(log10(tmpmax));
    end
    axesHandle.YAxis.Exponent        = Escale;
    axesHandle.YAxis.TickLabelFormat = '%.2g';  
    axesHandle.FontSize              = plot_info.tick_font_size;
    axesHandle.FontName              = plot_info.tick_font_name;    
    xlabel('$\dot{r}$ (pairwise speed)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    if K == 1
      ylabel('$\rho^L_{T, \dot{r}}$',    'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    else
      ylabel(['$\rho_{T, \dot{r}}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    end    
    handleAxes((k1 - 1) * 3 + 2, k2) = axesHandle;
% joint \rho^L_{T, r, \dot{r}} or \rho^L_{T, r, \xi}
    subplot(3 * K, K, (k1 - 1) * 3 * K + k2 + 2 * K);
    x_range                          = jrhoLT.rhoLTA.supp{k1, k2}(1, :);
    x_edges                          = jrhoLT.rhoLTA.histedges{k1, k2}(1, :);
    x_edges_idxs                     = find(x_range(1) <= x_edges & x_edges <= x_range(2));
    num_xeidxs                       = length(x_edges_idxs);
    y_range                          = jrhoLT.rhoLTA.supp{k1, k2}(2, :);
    y_edges                          = jrhoLT.rhoLTA.histedges{k1, k2}(2, :);
    y_edges_idxs                     = find(y_range(1) <= y_edges & y_edges <= y_range(2));
    num_yeidxs                       = length(y_edges_idxs);
    [histdata, x_edges, y_edges]     = downsampleHist2D(jrhoLT.rhoLTA.hist{k1, k2}(x_edges_idxs(1 : num_xeidxs - 1), y_edges_idxs(1 : num_yeidxs - 1)), ...
                                       x_edges(x_edges_idxs), sqrt(num_xeidxs)/2, y_edges(y_edges_idxs), sqrt(num_yeidxs)/2);
    x_centers                        = (x_edges(1 : end - 1) + x_edges(2 : end))/2;
    y_centers                        = (y_edges(1 : end - 1) + y_edges(2 : end))/2;
    pc_handle                        = pcolor(x_centers, y_centers, histdata');
    set(pc_handle, 'EdgeColor', 'none')
%     tmpmax                           = plot_info.rhotscalingdownfactor * max(histdata(:));
%     if tmpmax==0, tmpmax = 1; end
%     if isnan(tmpmax), tmpmax = 1; end 
    if abs(x_range(2) - x_range(1)) < 1.0e-12, x_range(2) = x_range(1) + 1; end
    if abs(y_range(2) - y_range(1)) < 1.0e-12, y_range(2) = y_range(1) + 1; end
    axis([x_range(1), x_range(2), y_range(1), y_range(2)]);
    axesHandle                       = gca();
    axesHandle.FontSize              = plot_info.tick_font_size;
    axesHandle.FontName              = plot_info.tick_font_name;     
    xlabel('$r$ (pairwise distance)',           'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    ylabel('$\dot{r}$',      'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    colormap(gca, 'jet');
    handleAxes((k1 - 1) * 3 + 3, k2) = axesHandle;
  end
end
%
tightFigaroundAxes( handleAxes );
end
