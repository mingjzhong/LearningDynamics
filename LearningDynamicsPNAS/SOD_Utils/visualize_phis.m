function visualize_phis(learningOutput, sys_info, obs_info, learn_info, plot_info)
% function visualize_phis(learningOutput, sys_info, obs_info, learn_info, plot_info)

% (c) M. Zhong (JHU)

% screen size issue
if isfield(plot_info, 'scrsz')
  scrsz        = plot_info.scrsz;
else
  scrsz        = get(groot,'ScreenSize');
end
% prepare different phi's
n_trials              = length(learningOutput);
phihat                = cell(1, n_trials);
phihatsmooth          = cell(1, n_trials);
basis                 = cell(1, n_trials);
phi                   = sys_info.phiE;
%
if ~isempty(phi)
    basis_info          = learn_info.Ebasis_info;
    for ind = 1 : n_trials
        phihat{ind}       = learningOutput{ind}.Estimator.phiEhat;
        phihatsmooth{ind} = learningOutput{ind}.Estimator.phiEhatsmooth;
        basis{ind}        = learningOutput{ind}.Estimator.Ebasis;
    end
% prepare the window to plot the true and learned interactions
    phi_fig             = figure('Name', 'PhiEs: True Vs. Learned', 'NumberTitle', 'off', 'Position', [scrsz(3)*1/8, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
    plot_info.phi_type  = 'energy';
    plot_one_type_of_phis(phi_fig, phi, phihat, phihatsmooth, learningOutput, basis_info, sys_info, obs_info, plot_info)
    if isfield(plot_info,'plot_name')
        saveas(phi_fig, [plot_info.plot_name '_phiE'], 'fig');                                            % save the figure in the figures subfolder
    end
end
%
if sys_info.ode_order == 2
    phi                 = sys_info.phiA;
else
    phi                 = [];
end
%
if ~isempty(phi)
    basis_info              = learn_info.Abasis_info;
    for ind = 1 : n_trials
        phihat{ind}         = learningOutput{ind}.Estimator.phiAhat;
        phihatsmooth{ind}   = learningOutput{ind}.Estimator.phiAhatsmooth;
        basis{ind}          = learningOutput{ind}.Estimator.Abasis;
    end
% prepare the window to plot the true and learned interactions
    phi_fig             = figure('Name', 'PhiAs: True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
        [scrsz(3)*1/8 + scrsz(3)* 1/48, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
    plot_info.phi_type  = 'alignment';
    plot_one_type_of_phis(phi_fig, phi, phihat, phihatsmooth, learningOutput, basis_info, sys_info, obs_info, plot_info)
    saveas(phi_fig, [plot_info.plot_name '_phiA'], 'fig');                                          % save the figure in the figures subfolder
% prepare the window to plot the joint distribution
    rhoLTA_fig          = figure('Name', 'rhoLTAs: True Vs. Empirical', 'NumberTitle', 'off', 'Position', ...
    [scrsz(3)*1/8 + scrsz(3)* 2/48, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
    plot_joint_distribution(rhoLTA_fig, obs_info.rhoLT.rhoLTA, learningOutput{1}.rhoLTemp.rhoLTA, sys_info.K, plot_info);
    saveas(rhoLTA_fig, [plot_info.plot_name '_rhoLTA'], 'fig');
end
%
if sys_info.ode_order == 2 && sys_info.has_xi
    phi                 = sys_info.phiXi;
else
    phi                 = [];
end
%
if ~isempty(phi)
    basis_info          = learn_info.Xibasis_info;
    for ind = 1 : n_trials
        phihat{ind}       = learningOutput{ind}.Estimator.phiXihat;
        phihatsmooth{ind} = learningOutput{ind}.Estimator.phiXihatsmooth;
        basis{ind}        = learningOutput{ind}.Estimator.Xibasis;
    end
% prepare the window to plot the true and learned interactions
    phi_fig             = figure('Name', 'PhiXis: True Vs. Learned', 'NumberTitle', 'off', 'Position', ...
    [scrsz(3)*1/8 + scrsz(3)*3/48, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
    plot_info.phi_type  = 'xi';
    plot_one_type_of_phis(phi_fig, phi, phihat, phihatsmooth, learningOutput, basis_info, sys_info, obs_info, plot_info)
    saveas(phi_fig, [plot_info.plot_name '_phiXi'], 'fig');                                            % save the figure in the figures subfolder
% prepare the window to plot the joint distribution
    rhoLTXi_fig          = figure('Name', 'rhoLTXis: True Vs. Empirical', 'NumberTitle', 'off', 'Position', ...
    [scrsz(3)*1/8 + scrsz(3)* 4/48, scrsz(4)*1/8, scrsz(3)*3/4, scrsz(4)*3/4]);
    plot_joint_distribution(rhoLTXi_fig, obs_info.rhoLT.rhoLTXi, learningOutput{1}.rhoLTemp.rhoLTXi, sys_info.K, plot_info);
    saveas(rhoLTXi_fig, [plot_info.plot_name '_rhoLTXi'], 'fig');
end
end