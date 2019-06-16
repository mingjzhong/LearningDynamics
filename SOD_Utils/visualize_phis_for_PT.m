function visualize_phis_for_PT(learningOutput, sys_info, obs_info, plot_info)
% function visualize_phis_for_PT(learningOutput, sys_info, obs_info, learn_info, plot_info)

% (c) M. Zhong

% screen size issue
if isfield(plot_info, 'scrsz')
  scrsz        = plot_info.scrsz;
else
  scrsz        = get(groot,'ScreenSize');
end
% plot phiA and phiXi together
phi_fig  = figure('Name', 'PhiA and PhiXi: True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
[scrsz(3)*1/8, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
plot_phiA_and_phiXi_together(phi_fig, learningOutput, sys_info, obs_info, plot_info);
saveas(phi_fig, [plot_info.plot_name '_phiA_n_phiXi'], 'fig');  
% prepare the window to plot the joint distribution: rhoLTA
rhoLTA_fig          = figure('Name', 'rhoLTAs: True Vs. Empirical', 'NumberTitle', 'off', 'Position', ...
[scrsz(3)*1/8 + scrsz(3)* 5/144, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
plot_info.phi_type  = 'alignment';
plot_joint_distribution(rhoLTA_fig, obs_info.rhoLT.rhoLTA, learningOutput{1}.rhoLTemp.rhoLTA, sys_info.K, plot_info);
saveas(rhoLTA_fig, [plot_info.plot_name '_rhoLTA'], 'fig');
% prepare the window to plot the joint distribution: rhoLTXi
rhoLTXi_fig          = figure('Name', 'rhoLTXis: True Vs. Empirical', 'NumberTitle', 'off', 'Position', ...
[scrsz(3)*1/8 + scrsz(3)* 10/144, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
plot_info.phi_type  = 'xi';
plot_joint_distribution(rhoLTXi_fig, obs_info.rhoLT.rhoLTXi, learningOutput{1}.rhoLTemp.rhoLTXi, sys_info.K, plot_info);
saveas(rhoLTXi_fig, [plot_info.plot_name '_rhoLTXi'], 'fig');
end