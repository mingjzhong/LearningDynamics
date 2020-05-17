function plot_phis_and_rhos(phi_fig, rho_fig, learningOutput, sys_info, obs_info, plot_info, type)
% function plot_phis_and_rhos(phi_fig, rho_fig, learningOutput, sys_info, obs_info, plot_info, type)

% (C) M. Zhong

% initialize storage
range                                  = get_basis_range(learningOutput, sys_info, type);
rho_range                              = get_rho_range(learningOutput, sys_info, type);
result                                 = get_phis_and_rhos_for_plotting(learningOutput, sys_info, ...
                                         obs_info, type);
plot_info.phi_type                     = type; 
plot_info.rho_type                     = type; 
switch type
  case 'energy'
    basis                              = learningOutput{1}.Estimator.Ebasis;
  case 'alignment'
    basis                              = learningOutput{1}.Estimator.Abasis;
  case 'xi'
    basis                              = learningOutput{1}.Estimator.Xibasis;
  otherwise
    error('');
end
plot_info.phi_resolution               = zeros(sys_info.K); 
plot_info.rho_resolution               = zeros(sys_info.K);
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if basis{k1, k2}.dim == 1
      plot_info.phi_resolution(k1, k2) = length(basis{k1, k2}.f);
      plot_info.rho_resolution(k1, k2) = 2 * plot_info.phi_resolution(k1, k2);
    else
      plot_info.phi_resolution(k1, k2) = sqrt(length(basis{k1, k2}.f));
      plot_info.rho_resolution(k1, k2) = 2 * plot_info.phi_resolution(k1, k2);
    end
  end
end
if isfield(plot_info, 'display_phihatreg') && ~isempty(plot_info.display_phihatreg) && plot_info.display_phihatreg
  phihats                              = result.phihats;
  phihatsmooths                        = result.phihatregs;
else
  phihats                              = result.phihats;
  phihatsmooths                        = result.phihatsmooths;
end
if contains(sys_info.name, 'Gravitation') && sys_info.N >= 5
  plot_info.showplotlegends            = false;
  plot_info.showlabels                 = false;
  plot_info.tick_font_size             = 16;
end
plot_phis_and_rhos_each_type(phi_fig, range, rho_range, result.phi, phihats, ...
  phihatsmooths, result.rhoLTR, result.rhoLTMRs, result.rhoLTX, result.rhoLTMXs, sys_info, ...
  plot_info);
saveas(phi_fig, [plot_info.plot_name result.phi_type], 'fig');  
if contains(sys_info.name, 'Gravitation')
  plot_phis_and_rhos_each_type(rho_fig, range, rho_range, result.phi, result.phihatsmooths, ...
    result.phihatcleans, result.rhoLTR, result.rhoLTMRs, result.rhoLTX, result.rhoLTMXs, sys_info, ...
    plot_info);
  saveas(rho_fig, [plot_info.plot_name '_phiE_clean'], 'fig'); 
end
if ~strcmp(type, 'energy') || contains(sys_info.name, 'SynchronizedOscillatorDynamics')
  plot_rhos_joint_distribution(rho_fig, range, rho_range, result.rhoLTR, result.rhoLTMRs, ...
    result.rhoLTX, result.rhoLTMXs, result.rhoLTRX, result.rhoLTMRXs, sys_info, plot_info);
  saveas(rho_fig, [plot_info.plot_name result.rho_type], 'fig');
end
end