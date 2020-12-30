%% MM: DEPRECATED, WILL BE REMOVED SOON

function compare_fs_with_rho_T(phis, phi_hats, knot_vecs, total_pdist, N, T, M, L, n, plot_name)
%
%
%

% Ming Zhong
% Postdoc Research

% prepare the window to plot the true and learned interactions
% set up the position and size of the window
true_vs_learned                  = figure('Name', 'True Vs. Learned', 'NumberTitle', 'off', 'units', 'normalized', ...
'position', [0.1, 0.1, 0.5, 0.5]);
% find out the number of classes
num_classes                   = size(phis, 1);
for k_1 = 1 : num_classes
  for k_2 = 1 : num_classes
% put all interaction comparison in some big fig
    subplot(num_classes, num_classes, (k_1 - 1) * num_classes + k_2);
% find out the knot vector
    one_knot                  = knot_vecs{k_1, k_2};
%
    f1                        = phis{k_1, k_2};
    f2                        = phi_hats{k_1, k_2};
% put un the uniform learning result first
% use the knot vectors as the range
    range                     = [one_knot(1), one_knot(end)];
% change it into a vector for histogram
    class_pdist               = [total_pdist{k_1, k_2, :}];
    class_pdist_vec           = class_pdist(:);
% prepare the histogram on the total pairwise distances
    hist_fig                  = figure;
% do not show the histogram
    set(hist_fig, 'Visible', 'off');
% the bins are from the knot vector, where the basis fucntions are built
    edges                     = one_knot;
% generate the hsitogram plot in the background  
    histogram(class_pdist_vec, edges, 'Normalization', 'probability');
% take off the axes in the plot  
    axis tight;
    set(hist_fig.CurrentAxes, 'position', [0, 0, 1, 1], 'units', 'normalized');
    axis off;
% save the histogram in .png file  
    hist_fig_name              = sprintf('hist_fig_C%dC%d', k_1, k_2);
    print(hist_fig, hist_fig_name, '-dpng');  
% read in the file as img objective for later usage
    hist_img                   = imread([hist_fig_name '.png']);
% refine this knot vector, so that each sub-interval generated a knot has
% at least 7 interior points, so 3 levels of refinement
    r                          = refine_knot_vec(one_knot, 10);
% find out the true phi's at r
    f_of_r                     = f1(r);
% find out the learned hpi's at r
    f_hat_of_r                 = f2(r);  
% find out the range for y values, f1 might have blow up, just use f_hat    
    y_min                      = min(f_hat_of_r) - 0.2;
    y_max                      = max(f_hat_of_r) + 0.2;
% plot everything on the true_vs_learned window
    set(groot, 'CurrentFigure', true_vs_learned);
% where to put this class C_{s_1} to class C_{s_2} interaction
% Flip the image upside down and show it in the background
    the_bg                      = imagesc([range(1), range(2)], [y_min, y_max], flipud(hist_img));
% set up a somehow transparent background
    set(the_bg, 'AlphaData', 0.4);
% put on a hold
    hold on;
    plot(r, f_of_r, '-r', 'LineWidth', 3);
% put the learned phi  
    plot(r, f_hat_of_r,  'bs', 'LineWidth', 2, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 1);
    hold off;
    xlabel('r, the pairwise distances');
    ylabel('True and Learned \phi''s');
    title(sprintf('N = %d, T = %d, M = %d, L = %d, n = %d', N, T, M, L, n(k_1, k_2)));
% 
    my_leg = legend(['$\phi_{' sprintf('%d, %d', k_1, k_2) '}$'], ['$\hat{\phi}_{' sprintf('%d, %d', k_1, k_2) '}$'], ...
    'Location', 'Best');
    set(my_leg, 'Interpreter', 'Latex');
% set up a uniform x-range, tighten the y-range
    axis([range(1), range(2), y_min, y_max]);
% set the y-axis back to normal.
    set(true_vs_learned.CurrentAxes, 'ydir', 'normal');
% print the plot in both eps and pdf forms
    print(true_vs_learned, '-depsc', plot_name);
% delete the histogram file
    delete(sprintf('hist_fig_C%dC%d.png', k_1, k_2));
  end
end
end  
