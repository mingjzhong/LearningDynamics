function plot_joint_distribution(win_handler, jrhoLT, jrhoLTemp, K, plot_info)
% function plot_joint_distribution(win_handler, jrhoLT, jrhoLTemp, K, plot_info)

% (c) M. Zhong (JHU)

% put plots on this particular window
set(groot, 'CurrentFigure', win_handler);
% initialize the storage
handleAxes                           = gobjects(3 * K, 2 * K);
color_true                           = [0.8500, 0.3250, 0.0980];
color_emp                            = [0.8500, 0.3250, 0.0980];
% go through each (k1, k2) pair
for k1 = 1 : K
  for k2 = 1 : K
% plots for the various (approximated) true \rho^L_T, \rho^L_{T, r} first
    subplot(3 * K, 2 * K, (k1 - 1) * 2 * K + (k2 - 1) * 2 + 1);
    rhoLTR                           = jrhoLT.rhoLTR;
    range                            = jrhoLTemp.supp{k1, k2}(1, :);
    edges                            = rhoLTR.histedges{k1, k2};
    edges_idxs                       = find(range(1) <= edges & edges <= range(2));
    [histdata,edges]                 = downsampleHistCounts( rhoLTR.hist{k1, k2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
    centers                          = (edges(1 : end - 1) + edges(2 : end))/2;   
    histHandle                       = plot(centers, histdata, 'k', 'LineWidth', 1);
    set(histHandle, 'Color', color_true);
    fill(centers(([1 1:end end])),[0 histdata' 0], color_true/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    axis tight;
    axesHandle                       = gca();
    axesHandle.FontSize              = plot_info.tick_font_size;
    axesHandle.FontName              = plot_info.tick_font_name;     
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
    xlabel('$r$ (pairwise distance)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    if K == 1
      ylabel('$\rho^L_{T, r}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    else
      ylabel(['$\rho_{T, r}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    end
    handleAxes((k1 - 1) * 3 + 1, (k2 - 1) * 2 * K + 1) = gca;
% \rho^L_{T, \dor{r}} or \rho^L_{T, \xi} second    
    subplot(3 * K, 2 * K, (k1 - 1) * 2 * K + (k2 - 1 + K) * 2 + 1);   
    if strcmp(plot_info.phi_type, 'alignment')
      rhoLTo                         = jrhoLT.rhoLTDR;
    elseif strcmp(plot_info.phi_type, 'xi')
      rhoLTo                         = jrhoLT.mrhoLTXi;
    end
    range                            = jrhoLTemp.supp{k1, k2}(2, :);
    edges                            = rhoLTo.histedges{k1, k2};
    edges_idxs                       = find(range(1) <= edges & edges <= range(2));
    [histdata,edges]                 = downsampleHistCounts( rhoLTo.hist{k1, k2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
    centers                          = (edges(1 : end - 1) + edges(2 : end))/2;
    histHandle                       = plot(centers, histdata, 'k', 'LineWidth', 1);
    set(histHandle, 'Color', color_true);
    fill(centers(([1 1:end end])),[0 histdata' 0], color_true/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    axis tight;
    axesHandle                       = gca();
    axesHandle.FontSize              = plot_info.tick_font_size;
    axesHandle.FontName              = plot_info.tick_font_name;     
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
    if strcmp(plot_info.phi_type, 'alignment')
      xlabel('$\dot{r}$ (pairwise speed)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if K == 1
        ylabel('$\rho^L_{T, \dot{r}}$',    'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \dot{r}}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    elseif strcmp(plot_info.phi_type, 'xi')
      xlabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if K == 1
        ylabel('$\rho^L_{T, \xi}$',             'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \xi}^{T, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    end
    handleAxes((k1 - 1) * 3 + 2, (k2 - 1) * 2 * K + 1) = axesHandle;
% joint \rho^L_{T, r, \dot{r}} or \rho^L_{T, r, \xi}
    subplot(3 * K, 2 * K, (k1 - 1) * 2 * K + (k2 - 1 + 2 * K) * 2 + 1);  
    x_range                          = jrhoLTemp.supp{k1, k2}(1, :);
    x_edges                          = jrhoLT.histedges{k1, k2}(1, :);
    x_edges_idxs                     = find(x_range(1) <= x_edges & x_edges <= x_range(2));
    num_xeidxs                       = length(x_edges_idxs);
    y_range                          = jrhoLTemp.supp{k1, k2}(2, :);
    y_edges                          = jrhoLT.histedges{k1, k2}(2, :);
    y_edges_idxs                     = find(y_range(1) <= y_edges & y_edges <= y_range(2));
    num_yeidxs                       = length(y_edges_idxs);
    [histdata, x_edges, y_edges]     = downsampleHist2D(jrhoLT.hist{k1, k2}(x_edges_idxs(1 : num_xeidxs - 1), y_edges_idxs(1 : num_yeidxs - 1)), ...
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
    if strcmp(plot_info.phi_type, 'alignment')
      ylabel('$\dot{r}$ (pairwise speed)',      'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    elseif strcmp(plot_info.phi_type, 'xi')
      ylabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    end
    colormap(gca, 'jet'); 
    handleAxes((k1 - 1) * 3 + 3, (k2 - 1) * 2 * K + 1) = axesHandle;
% plots for the various empirical \rho^{L, M}_T, \rho^{L, M}_{T, r} first
    subplot(3 * K, 2 * K, (k1 - 1) * 2 * K + (k2 - 1) * 2 + 2);     
    rhoLTR                           = jrhoLTemp.rhoLTR;
    range                            = jrhoLTemp.supp{k1, k2}(1, :);
    edges                            = rhoLTR.histedges{k1, k2};
    edges_idxs                       = find(range(1) <= edges & edges <= range(2));
    [histdata,edges]                 = downsampleHistCounts( rhoLTR.hist{k1, k2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
    centers                          = (edges(1 : end - 1) + edges(2 : end))/2;
    histHandle                       = plot(centers, histdata, 'k', 'LineWidth', 1);
    set(histHandle, 'Color', color_emp);
    fill(centers(([1 1:end end])),[0 histdata' 0], color_emp, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    axis tight;
    axesHandle                       = gca();
    axesHandle.FontSize              = plot_info.tick_font_size;
    axesHandle.FontName              = plot_info.tick_font_name;    
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
    xlabel('$r$ (pairwise distance)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    if K == 1
      ylabel('$\rho^{L, M}_{T, r}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    else
      ylabel(['$\rho_{T, r}^{T, M, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
    end
    handleAxes((k1 - 1) * 3 + 1, (k2 - 1) * 2 * K + 2) = axesHandle;
% \rho^{L, M}_{T, \dor{r}} or \rho^{L, M}_{T, \xi} second    
    subplot(3 * K, 2 * K, (k1 - 1) * 2 * K + (k2 - 1 + K) * 2 + 2);    
    if strcmp(plot_info.phi_type, 'alignment')
      rhoLTo                         = jrhoLTemp.rhoLTDR;
    elseif strcmp(plot_info.phi_type, 'xi')
      rhoLTo                         = jrhoLTemp.mrhoLTXi;
    end
    range                            = jrhoLTemp.supp{k1, k2}(2, :);
    edges                            = rhoLTo.histedges{k1, k2};
    edges_idxs                       = find(range(1) <= edges & edges <= range(2));
    [histdata,edges]                 = downsampleHistCounts( rhoLTo.hist{k1, k2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
    centers                          = (edges(1 : end - 1) + edges(2 : end))/2;
    histHandle                       = plot(centers, histdata, 'k', 'LineWidth', 1);
    set(histHandle, 'Color', color_emp);
    fill(centers(([1 1:end end])),[0 histdata' 0], color_emp, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    axis tight;
    axesHandle                       = gca();
    axesHandle.FontSize              = plot_info.tick_font_size;
    axesHandle.FontName              = plot_info.tick_font_name;     
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
    if strcmp(plot_info.phi_type, 'alignment')
      xlabel('$\dot{r}$ (pairwise speed)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if K == 1
        ylabel('$\rho^{L, M}_{T, \dot{r}}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \dot{r}}^{T, M, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    elseif strcmp(plot_info.phi_type, 'xi')
      xlabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      if K == 1
        ylabel('$\rho^{L, M}_{T, \xi}$',       'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      else
        ylabel(['$\rho_{T, \xi}^{T, M, ' sprint('%d%d}$', k1, k2)], 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size);
      end
    end
    handleAxes((k1 - 1) * 3 + 2, (k2 - 1) * 2 * K + 2) = axesHandle;
% joint \rho^{L, M}_{T, r, \dot{r}} or \rho^{L, M}_{T, r, \xi}
    subplot(3 * K, 2 * K, (k1 - 1) * 2 * K + (k2 - 1 + 2 * K) * 2 + 2);    
    x_range                          = jrhoLTemp.supp{k1, k2}(1, :);
    x_edges                          = jrhoLTemp.histedges{k1, k2}(1, :);
    x_edges_idxs                     = find(x_range(1) <= x_edges & x_edges <= x_range(2));
    num_xeidxs                       = length(x_edges_idxs);
    y_range                          = jrhoLTemp.supp{k1, k2}(2, :);
    y_edges                          = jrhoLTemp.histedges{k1, k2}(2, :);
    y_edges_idxs                     = find(y_range(1) <= y_edges & y_edges <= y_range(2));
    num_yeidxs                       = length(y_edges_idxs);
    [histdata, x_edges, y_edges]     = downsampleHist2D(jrhoLTemp.hist{k1, k2}(x_edges_idxs(1 : num_xeidxs - 1), y_edges_idxs(1 : num_yeidxs - 1)), ...
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
    if strcmp(plot_info.phi_type, 'alignment')
      ylabel('$\dot{r}$ (pairwise speed)',      'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    elseif strcmp(plot_info.phi_type, 'xi')
      ylabel('$\xi$ (pairwise $\xi_{i, i''}$)', 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name);
    end
    colormap(gca, 'jet');
    handleAxes((k1 - 1) * 3 + 3, (k2 - 1) * 2 * K + 2) = axesHandle;
  end
end
%
tightFigaroundAxes( handleAxes );
end
