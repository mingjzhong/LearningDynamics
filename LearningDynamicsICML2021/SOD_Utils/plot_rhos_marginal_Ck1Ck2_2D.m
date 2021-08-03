function [rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2_2D(fig_handle, ax, range1, ...
         range2, rhoLT, k1, k2, rho_type, sys_info, plot_info)
% function [rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2_2D(fig_handle, ax, range1, ...
%          range2, rhoLT, k1, k2, rho_type, sys_info, plot_info)

% (c) M. Zhong (JHU)

set(fig_handle, 'CurrentAxes', ax);
colormap('jet');
ax.FontSize                 = plot_info.tick_font_size;
ax.FontName                 = plot_info.tick_font_name;
rhoPlotHandles              = gobjects(1);
rhoPlotNames                = cell(1);
if ~isempty(rhoLT)
  r_ctrs                    = linspace(range1(1), range1(2), plot_info.rho_resolution(k1, k2));
  s_ctrs                    = linspace(range2(1), range2(2), plot_info.rho_resolution(k1, k2));
  [R, S]                    = ndgrid(r_ctrs, s_ctrs);
  if iscell(rhoLT)
    n_trials                = length(rhoLT);
    rhoLT_ctrs              = zeros(n_trials, length(r_ctrs), length(s_ctrs));  
    for ind = 1 : n_trials
      rhoLT_ctrs(ind, :, :) = rhoLT{ind}(R, S);
    end 
    histdata                = squeeze(mean(rhoLT_ctrs, 1));
  else
    histdata                = rhoLT(R, S);
  end
  if nnz(histdata) < 0.05 * numel(histdata)
    ind                     = histdata > 0;
    R                       = R(ind);
    S                       = S(ind);
    scatter(R, S, 36, histdata(ind), 'filled', 'o');
    r_min                   = min(R);
    r_max                   = max(R);
    r_range                 = r_max - r_min;
    s_min                   = min(S);
    s_max                   = max(S);
    CH                      = colorbar('east');
    set(CH, 'FontSize', plot_info.colorbar_font_size);
    axis([r_min, r_max + 0.05 * r_range, s_min, s_max]);
  else
    pc_handle               = pcolor(R, S, histdata);
    [r_range, s_range]      = get_effective_range(histdata, R, S);
    axis([r_range, s_range]);
    set(pc_handle, 'EdgeColor', 'none');  
  end
  rhoPlotNames{1}           = get_legend_name_for_rhos(sys_info, plot_info, rho_type, k1, k2);
else
  r_ctrs                    = linspace(0, 1, 101);
  histdata                  = zeros(size(r_ctrs));
  histhandle                = plot(r_ctrs, histdata, 'k', 'LineWidth', 1); hold on;
  set(histhandle, 'Color', the_color/2);
  rhoPlotHandles(1)         = fill(r_ctrs([1, 1 : end, end]), [0, histdata, 0], the_color/2, ...
    'EdgeColor', 'none', 'FaceAlpha', 0.1);
  rhoPlotNames{1}           = get_legend_name_for_rhos(sys_info, plot_info, rho_type, k1, k2);
end
end