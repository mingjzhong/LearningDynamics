function [rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2_2D(fig_handle, ax, range1, ...
         range2, rhoLT, k1, k2, rho_type, sys_info, plot_info)
% function [rhoPlotHandles, rhoPlotNames] = plot_rhos_marginal_Ck1Ck2_2D(fig_handle, ax, range1, range2, rhoLT, rhoLTMs, ...
%                                           k1, k2, sys_info, plot_info)

% (c) M. Zhong (JHU)

set(fig_handle, 'CurrentAxes', ax);
colormap('jet');
ax.FontSize                 = plot_info.tick_font_size;
ax.FontName                 = plot_info.tick_font_name;
rhoPlotHandles              = gobjects(1);
rhoPlotNames                = cell(1);
if ~isempty(rhoLT)
  r_ctrs                      = linspace(range1(1), range1(2), plot_info.rho_resolution(k1, k2));
  s_ctrs                      = linspace(range2(1), range2(2), plot_info.rho_resolution(k1, k2));
  [R, S]                      = ndgrid(r_ctrs, s_ctrs);
  if iscell(rhoLT)
    n_trials                  = length(rhoLT);
    rhoLT_ctrs                = zeros(n_trials, length(r_ctrs), length(s_ctrs));  
    for ind = 1 : n_trials
      rhoLT_ctrs(ind, :, :)   = rhoLT{ind}(R, S);
    end 
    histdata                  = squeeze(mean(rhoLT_ctrs, 1));
  else
    histdata                  = rhoLT(R, S);
  end
  pc_handle                   = pcolor(r_ctrs, s_ctrs, histdata);
  range1                      = plot_info.eff_range{1}{1};
  range2                      = plot_info.eff_range{2}{1};
  axis([range1, range2]);
  set(pc_handle, 'EdgeColor', 'none');  
  rhoPlotNames{1}             = get_legend_name_for_rhos(sys_info, plot_info, rho_type, k1, k2);
else
  r_ctrs                      = linspace(0, 1, 101);
  histdata                  = zeros(size(r_ctrs));
  histhandle                = plot(r_ctrs, histdata, 'k', 'LineWidth', 1); hold on;
  set(histhandle, 'Color', the_color/2);
  rhoPlotHandles(1)         = fill(r_ctrs([1, 1 : end, end]), [0, histdata, 0], the_color/2, ...
    'EdgeColor', 'none', 'FaceAlpha', 0.1);
  rhoPlotNames{1}           = get_legend_name_for_rhos(sys_info, plot_info, rho_type, k1, k2);
end
end