%% MM: DEPRECATED, will be removed soon

function compare_fs(phis, phi_hat, phi_hat_smooth, knot_vecs, sys_info, obs_info, learning_info, obs_data, plot_name )

% compare_fs(phis, phi_hats, knot_vecs, total_pdist, N, T, M, L, n, plot_name)

% (c) Ming Zhong, Mauro Maggioni, JHU

LEGEND_FONT_SIZE = 20;
TITLE_FONT_SIZE = 20;
AXIS_FONT_SIZE = 20;
PHI_LINE_WIDTH = 1.5;
PHIHAT_LINE_WIDTH = 1;

% prepare the window to plot the true and learned interactions
scrsz = get(groot,'ScreenSize');
true_vs_learned = figure('Name','True Vs. Learned', 'NumberTitle', 'off','Position',[scrsz(3)*1/8,scrsz(4)*1/8,scrsz(3)*3/4,scrsz(4)*3/4]);

num_classes                   = size(phis, 1);                                                                                  % find out the number of classes
for k_1 = 1 : num_classes
    for k_2 = 1 : num_classes
        subplot(num_classes, num_classes, (k_1 - 1) * num_classes + k_2);                                                       % put all interaction comparison in some big fig
        one_knot                  = knot_vecs{k_1, k_2};                                                                        % find out the knot vector
        range                     = [one_knot(1), one_knot(end)];                                                               % plot the uniform learning result first; use the knot vectors as the range
        r                          = refine_knot_vec(one_knot, 10);                                                             % refine this knot vector, so that each sub-interval generated a knot has at least 7 interior points, so 3 levels of refinement
        f_of_r                     = phis{k_1, k_2}(r);
        f_hat_of_r                 = phi_hat{k_1,k_2}(r);
        f_hat_smooth_of_r          = phi_hat_smooth{k_1,k_2}(r);
        y_min                      = min([f_of_r,f_hat_of_r,f_hat_smooth_of_r])*1.1;                                                                       % find out the range for y values, f1 might have blow up, just use f_hat
        y_max                      = max([f_of_r,f_hat_of_r,f_hat_smooth_of_r])*1.1;
        
        set(groot, 'CurrentFigure', true_vs_learned);                                                                           % plot everything on the true_vs_learned window
        
        edges                       = obs_info.rho_T_histedges;                                                                 % Estimated \rho's
        edges_idxs                  = find(edges<range(2));
        centers                     = (edges(1:edges_idxs(end)-1) + edges(2:edges_idxs(end)))/2;
        histdata                    = obs_info.rhoT_hist{1}(edges_idxs(1:end-1));
        
        yyaxis right
        axesHandle1 = gca();
        histHandle1=plot(centers,histdata(:,1),'b','LineWidth',1);
        hold on;
        hist1 = fill(centers(([1 1:end end])),[0 histdata(:,1)' 0],'b','EdgeColor','none','FaceAlpha',0.2);
        if isfield(obs_data,'rhoTexmp_hist') && ~isempty(obs_data.rhoTexmp_hist)
            histdata                = [histdata,obs_data.rhoTexmp_hist(edges_idxs(1:end-1))];
            histHandle2=plot(centers,histdata(:,2),'r','LineWidth',1);
            hist2 = fill(centers(([1 1:end end])),[0 histdata(:,2)' 0],'r','EdgeColor','r','FaceAlpha',0.2);
        else
            hist2 = [];
        end
        axis tight;
        ylabelHandle = ylabel(axesHandle1,'$\hat\rho^L_T, \rho^{L,M}_T$','Interpreter','latex','FontSize',AXIS_FONT_SIZE);
        set(ylabelHandle,'VerticalAlignment','bottom');
        set(ylabelHandle,'Position',get(ylabelHandle,'Position')-[0.25,0,0]);
        
        yyaxis left
        plotHandle1=plot(r, f_of_r, '-b', 'LineWidth', PHI_LINE_WIDTH);hold on
        plotHandle2=plot(r, f_hat_of_r,  '-g', 'LineWidth', PHIHAT_LINE_WIDTH);                                                 % plot the learned phi
        plotHandle3=plot(r, f_hat_smooth_of_r,  '-r', 'LineWidth', PHIHAT_LINE_WIDTH);                                          % plot the learned phi, smoothed
        
        if num_classes>1
            legendHandle2=legend([plotHandle1,plotHandle2,plotHandle3,hist1,hist2], ...
                ['$\phi_{' sprintf('%d, %d', k_1, k_2) '}$'], ['$\hat{\phi}_{' sprintf('%d, %d', k_1, k_2) '}$'], ...
                ['$\hat{\phi}_{' sprintf('%d, %d', k_1, k_2) ',reg}$'], ['$\hat\rho^L_T$'],['$\rho^{L,M}_T$'] );
            ylabel(['$\phi_{' sprintf('%d, %d', k_1, k_2) '},\hat{\phi}_{' sprintf('%d, %d', k_1, k_2) '},' ...
                '\hat{\phi}_{' sprintf('%d, %d', k_1, k_2) ',reg}$'],'Interpreter','latex','FontSize',AXIS_FONT_SIZE);
        else
            legendHandle2=legend([plotHandle1,plotHandle2,plotHandle3,hist1,hist2], ...
                {'$\phi$','$\hat{\phi}$','$\hat{\phi}_{reg}$','$\hat\rho^L_T$','$\rho^{L,M}_T$'} );
            ylabel(['$\phi, \hat{\phi}, \hat{\phi}_{reg}$'],'Interpreter','latex','FontSize',AXIS_FONT_SIZE);        end
        set(legendHandle2,'Location', 'NorthEast','Interpreter','latex','FontSize',LEGEND_FONT_SIZE);
        
        axis([range(1), range(2), y_min, y_max]);                                                                               % set up a uniform x-range, tighten the y-range
        
        xlabel('r (pairwise distances)','FontSize',AXIS_FONT_SIZE);
        
        titleHandle = title(sprintf('N = %d, T = %.0f, M = %d, L = %d, n = %d', sys_info.N, obs_info.T_L, obs_info.M, ...
            obs_info.L, learning_info.Ebasis_info.n), ...
            'FontSize',TITLE_FONT_SIZE);
        set(titleHandle,'Position',get(titleHandle,'Position')-[0,0.05,0]);
    end
end


ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

print(true_vs_learned, '-depsc', plot_name);                                                                                    % print the plot in both eps and pdf forms

return
