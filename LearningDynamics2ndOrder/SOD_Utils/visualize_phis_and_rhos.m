function num_figs= visualize_phis_and_rhos(learningOutput, sys_info, obs_info, plot_info)
% function num_figs = visualize_phis_and_rhos(learningOutput, sys_info, obs_info, plot_info)

% (c) M. Zhong (JHU)

num_figs       = 0;
% do the energy based phi's first
if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
% prepare the window to plot the true and learned interactions
  scr_pos      = plot_info.scr_pos;
  scr_pos(1)   = scr_pos(1) + num_figs * plot_info.scr_xgap;
  phi_fig      = figure('Name', 'PhiEs: True vs. Learned', 'NumberTitle', 'off', 'Position', scr_pos);
  num_figs     = num_figs + 1;
  if contains(sys_info.name, 'Gravitation') || (isfield(sys_info, 'projE') && ~isempty(sys_info.projE))
    scr_pos    = plot_info.scr_pos;
    scr_pos(1) = scr_pos(1) + num_figs * plot_info.scr_xgap;
    if contains(sys_info.name, 'Gravitation')
      fig_name = 'PhiEs: True vs. Cleaned';
    else
      fig_name = 'rhoLTEs: True vs. Empirical';
    end
    ano_fig    = figure('Name', fig_name, 'NumberTitle', 'off', 'Position', scr_pos);
    num_figs   = num_figs + 1;  
  else
    ano_fig    = [];
  end
  plot_phis_and_rhos(phi_fig, ano_fig, learningOutput, sys_info, obs_info, plot_info, 'energy');
end
% alignment based phi's second
if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
% prepare the window to plot the true and learned interactions
  scr_pos      = plot_info.scr_pos;
  scr_pos(1)   = scr_pos(1) + num_figs * plot_info.scr_xgap;
  phi_fig      = figure('Name', 'PhiAs: True vs. Learned', 'NumberTitle', 'off', 'Position', scr_pos);
  num_figs     = num_figs + 1;
% prepare the window to plot the joint distribution
  scr_pos      = plot_info.scr_pos;
  scr_pos(1)   = scr_pos(1) + num_figs * plot_info.scr_xgap;
  rho_fig      = figure('Name', 'rhoLTAs: True vs. Empirical', 'NumberTitle', 'off', 'Position', scr_pos);
  num_figs     = num_figs + 1;
  plot_phis_and_rhos(phi_fig, rho_fig, learningOutput, sys_info, obs_info, plot_info, 'alignment');
end
% xi based phi's the last
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
% prepare the window to plot the true and learned interactions
  scr_pos      = plot_info.scr_pos;
  scr_pos(1)   = scr_pos(1) + num_figs * plot_info.scr_xgap;
  phi_fig      = figure('Name', 'PhiXis: True vs. Learned', 'NumberTitle', 'off', 'Position', scr_pos);  
  num_figs     = num_figs + 1;
% prepare the window to plot the joint distribution
  scr_pos      = plot_info.scr_pos;
  scr_pos(1)   = scr_pos(1) + num_figs * plot_info.scr_xgap;
  rho_fig      = figure('Name', 'rhoLTXis: True vs. Empirical', 'NumberTitle', 'off', 'Position', scr_pos);
  num_figs     = num_figs + 1;
  plot_phis_and_rhos(phi_fig, rho_fig, learningOutput, sys_info, obs_info, plot_info, 'xi');          
end
end