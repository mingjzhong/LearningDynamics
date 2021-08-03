function num_figs = plot_mass_and_phi_mean(sys_info, learningOutput, plot_info)
% function num_figs = plot_mass_and_phi_mean(sys_info, learningOutput, plot_info)

% (c) M. Zhong (JHU)

num_trials          = length(learningOutput);
num_figs            = 2;
mass_hats           = zeros(num_trials, sys_info.N);
massErrs            = zeros(num_trials, sys_info.N);
supps               = zeros(num_trials, 2);
%sys_info.AO_names   = {'Sun', 'Mer', 'Ven', 'Ear', 'Moo', 'Mar', 'Jup', 'Sat', 'Ura', 'Nep'};
for ind = 1 : num_trials
  mass_hats(ind, :) = learningOutput{ind}.Estimator.gravity.mass_hat;
  massErrs(ind, :)  = learningOutput{ind}.Estimator.massErr;
  supps(ind, :)     = learningOutput{ind}.Estimator.gravity.basis.supp;
end
supp                = zeros(1, 2);
supp(1)             = min(supps(:, 1));
supp(2)             = max(supps(:, 2));
r                   = linspace(supp(1), supp(2), 1001);
rq                  = learningOutput{1}.Estimator.gravity.rq;
phim_vec            = learningOutput{1}.Estimator.gravity.phim_vec/learningOutput{1}.Estimator.gravity.C;
r                   = union(r, rq);
gravity_fun         = r.^(-3);
phimMat             = zeros(num_trials, length(r));
for ind = 1 : num_trials
  phimMat(ind, :)   = learningOutput{ind}.Estimator.gravity.phihatm(r)/learningOutput{ind}.Estimator.gravity.C;
end
scr_pos             = plot_info.scr_pos;
scr_pos(1)          = scr_pos(1) + plot_info.num_figs * plot_info.scr_xgap;
gravity_mass_fig    = figure('Name', [sys_info.name ': Masses'], 'NumberTitle', 'off', ...
                      'Position', scr_pos);
% First for the comparison of masses
BH1                 = bar(1 : sys_info.N, sys_info.known_mass, 0.8);
BH1.FaceAlpha       = 0.5;
hold on;
BH2                 = bar(1 : sys_info.N, mean(mass_hats, 1), 0.4);
hold off;
% how to handle the confidence intervals: mean(mass_hats, 1) +/- std(mass_hats, 0, 1) in bar plot?
AH                  = gca;
set(AH,'YScale','log');
y_min               = min([min(sys_info.known_mass), min(mean(mass_hats, 1) - std(mass_hats, 0, 1))]);
y_max               = max([max(sys_info.known_mass), max(mean(mass_hats, 1) + std(mass_hats, 0, 1))]);
axis([1 - 0.5, sys_info.N + 0.5, y_min * 0.8, y_max * 1.2]);
legendHandle        = legend([BH1, BH2], {'True Masses', 'Estimated Masses'});
AH.FontSize         = plot_info.tick_font_size;
AH.FontName         = plot_info.tick_font_name;  
set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size, ...
    'FontName', plot_info.legend_font_name);
xticks(1 : sys_info.N);
xticklabels(sys_info.AO_names);  
tightFigaroundAxes(AH);
% print the relative errors in estimating masses
for idx = 1 : length(sys_info.AO_names)
  fprintf('\nFor %8s, the err. is: %10.4e %s %10.4e', sys_info.AO_names{idx}, ...
    mean(massErrs(:, idx)), char(177), std(massErrs(:, idx)));
end
% put up the comparison of phi_m and 1/r^3
scr_pos               = plot_info.scr_pos;
scr_pos(1)            = scr_pos(1) + (plot_info.num_figs + 1) * plot_info.scr_xgap;
gravity_phihatm_fig   = figure('Name', [sys_info.name ': phihat_m'], 'NumberTitle', 'off', 'Position', scr_pos);
% First: phihat_m(rq) vs 1/(rq)^3
loglog(r, gravity_fun, 'k', 'LineWidth', plot_info.phi_line_width);
hold on;
loglog(rq, phim_vec,  'bo', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 6);
hold off;
y_min               = min([min(gravity_fun), min(phim_vec)]);
y_max               = max([max(gravity_fun), max(phim_vec)]);
y_min               = y_min * 0.9;
y_max               = y_max * 1.1;
axis([min(rq), max(rq), y_min, y_max]);
legendHandle        = legend('True $\frac{1}{r^3}$', 'Estimated $\hat\phi_m(r_q)$');
AH                  = gca();
AH.FontSize         = plot_info.tick_font_size;
AH.FontName         = plot_info.tick_font_name;  
set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size, ...
    'FontName', plot_info.legend_font_name);
xlabel('$r$ (pairwise distance)','FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name, ...
       'Interpreter', 'latex');
tightFigaroundAxes(AH);
% save them
saveas(gravity_mass_fig, sprintf('%s/%s_%s_mass', plot_info.SAVE_DIR, sys_info.name, plot_info.time_stamp), 'fig');
saveas(gravity_phihatm_fig, sprintf('%s/%s_%s_phim', plot_info.SAVE_DIR, sys_info.name, plot_info.time_stamp), 'fig');
end