function plot_joint_distribution(win_handler, rhoLTA, rhoLTAemp, K, plot_info)
% function plot_joint_distribution(win_handler, rhoLTA, rhoLTAemp, K, plot_info)

% (c) M. Zhong (JHU)

% put plots on this particular window
set(groot, 'CurrentFigure', win_handler);
%
AXIS_FONT_SIZE           = plot_info.axis_font_size;
AXIS_FONT_NAME           = plot_info.axis_font_name;
LEGEND_FONT_SIZE         = plot_info.legend_font_size;
RHOTSCALINGDOWNFACTOR    = plot_info.rhotscalingdownfactor;
handleAxes               = gobjects(K);
% go through each (k1, k2) pair
for k_1 = 1 : K
  for k_2 = 1 : K
% true joint distrubtion    
    subplot(K, 2 * K, (k_1 - 1) * 2 * K + 2 * k_2 - 1);
    x_range              = rhoLTAemp.supp{k_1, k_2}(1, :);
    x_edges              = rhoLTA.histedges{k_1, k_2}(1, :);
    x_edges_idxs         = find(x_range(1) <= x_edges & x_edges <= x_range(2));
    num_xeidxs           = length(x_edges_idxs);
    x_centers            = (x_edges(x_edges_idxs(1 : num_xeidxs - 1)) + x_edges(x_edges_idxs(2 : num_xeidxs)))/2;
    y_range              = rhoLTAemp.supp{k_1, k_2}(2, :);
    y_edges              = rhoLTA.histedges{k_1, k_2}(2, :);
    y_edges_idxs         = find(y_range(1) <= y_edges & y_edges <= y_range(2));
    num_yeidxs           = length(y_edges_idxs);
    y_centers            = (y_edges(y_edges_idxs(1 : num_yeidxs - 1)) + y_edges(y_edges_idxs(2 : num_yeidxs)))/2; 
    if ~isempty(rhoLTA.hist{k_1, k_2})
      histdata1          = rhoLTA.hist{k_1,k_2}(x_edges_idxs(1 : num_xeidxs - 1), y_edges_idxs(1 : num_yeidxs - 1));% this is the "true" \rhoLT from many MC simulations
    else
      histdata1          = zeros(length(x_centers), length(y_centers));
    end
    surf(x_centers, y_centers, histdata1'), shading interp, colormap(parula), hold on;
    tmpmax               = RHOTSCALINGDOWNFACTOR * max(histdata1(:));
    if tmpmax==0, tmpmax = 1; end
    if isnan(tmpmax), tmpmax = 1; end 
    if abs(x_range(2) - x_range(1)) < 1.0e-12, x_range(2) = x_range(1) + 1; end
    if abs(y_range(2) - y_range(1)) < 1.0e-12, y_range(2) = y_range(1) + 1; end
    axis([x_range(1), x_range(2), y_range(1), y_range(2), 0, tmpmax]);
    if strcmp(plot_info.phi_type, 'alignment')
      zlabel('$\hat\rho^{L, A}_T$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);   
    elseif strcmp(plot_info.phi_type, 'xi')
      zlabel('$\hat\rho^{L, \xi}_T$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);   
    end   
    xlabel('r (pairwise distance)', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME, 'Rotation', 26);
    if strcmp(plot_info.phi_type, 'alignment')
      ylabel('$\dot{r}$ (pairwise speed)', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME, 'Rotation', -40);
    elseif strcmp(plot_info.phi_type, 'xi')
      ylabel('$\xi$ (pairwise $\xi$)', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME, 'Rotation', -40);
    end    
    handleAxes(k_1, 2 * k_2 - 1) = gca;
% empirical data joint distrubtion
    subplot(K, 2 * K, (k_1 - 1) * 2 * K + 2 * k_2);
    x_edges              = rhoLTAemp.histedges{k_1, k_2}(1, :);
    x_edges_idxs         = find(x_range(1) <= x_edges & x_edges <= x_range(2));
    num_xeidxs           = length(x_edges_idxs);
    x_centers            = (x_edges(x_edges_idxs(1 : num_xeidxs - 1)) + x_edges(x_edges_idxs(2 : num_xeidxs)))/2;
    y_edges              = rhoLTAemp.histedges{k_1, k_2}(2, :);
    y_edges_idxs         = find(y_range(1) <= y_edges & y_edges <= y_range(2));
    num_yeidxs           = length(y_edges_idxs);
    y_centers            = (y_edges(y_edges_idxs(1 : num_yeidxs - 1)) + y_edges(y_edges_idxs(2 : num_yeidxs)))/2; 
    if ~isempty(rhoLTAemp.hist{k_1, k_2})
      histdata2          = rhoLTAemp.hist{k_1,k_2}(x_edges_idxs(1 : num_xeidxs - 1), y_edges_idxs(1 : num_yeidxs - 1));% this is the "true" \rhoLT from many MC simulations
    else
      histdata2          = zeros(length(x_centers), length(y_centers));
    end    
    surf(x_centers, y_centers, histdata2'), shading interp, colormap(parula), hold on;
    tmpmax               = RHOTSCALINGDOWNFACTOR * max(histdata2(:));
    if tmpmax==0, tmpmax = 1; end
    if isnan(tmpmax), tmpmax = 1; end 
    if abs(x_range(2) - x_range(1)) < 1.0e-12, x_range(2) = x_range(1) + 1; end
    if abs(y_range(2) - y_range(1)) < 1.0e-12, y_range(2) = y_range(1) + 1; end
    axis([x_range(1), x_range(2), y_range(1), y_range(2), 0, tmpmax]);
    if strcmp(plot_info.phi_type, 'alignment')
      zlabel('$\hat\rho^{L, M, A}_T$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);   
    elseif strcmp(plot_info.phi_type, 'xi')
      zlabel('$\hat\rho^{L, M, \xi}_T$', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);   
    end  
    xlabel('r (pairwise distance)', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME, 'Rotation', 26);
    if strcmp(plot_info.phi_type, 'alignment')
      ylabel('$\dot{r}$ (pairwise speed)', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME, 'Rotation', -40);
    elseif strcmp(plot_info.phi_type, 'xi')
      ylabel('$\xi$ (pairwise $\xi$)', 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME, 'Rotation', -40);
    end
    handleAxes(k_1, 2 * k_2) = gca;
  end
end
tightFigaroundAxes( handleAxes );
end