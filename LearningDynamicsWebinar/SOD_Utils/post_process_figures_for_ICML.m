function post_process_figures_for_ICML()
% function post_process_figures_for_ICML()

% (C) M. Zhong

if ispc, save_path = getenv('USERPROFILE'); 
else,    save_path = getenv('HOME'); end        
SAVE_DIR       = [save_path, filesep, 'DataAnalyses', filesep, 'LearningDynamics'];
file_names     = {'LennardJonesDynamicsTruncatedonPD', 'LennardJonesDynamicsTruncatedonS2', ...
                  'OpinionDynamicsContonPD', 'OpinionDynamicsContonS2', ...
                  'PredatorPrey1stOrderonPD', 'PredatorPrey1stOrderonS2'};
SH_names       = {'LJD_on_PD', 'LJD_on_S2', 'OD_on_PD', 'OD_on_S2', 'PS1_on_PD', 'PS1_on_S2'};
time_stamps    = {'20210208T134032', '20210112T220548', '20210203T124555', '20210112T012529', ...
                  '20210204T150539', '20210114T075214'};
% regenerate_figures_for_ICML(SAVE_DIR, file_names, time_stamps);
fig_types      = {'phiE', 'traj'};
for idx1 = 1 : length(file_names)
  for idx2 = 1 %: length(fig_types)
    if idx2 == 1
      fig_type = fig_types{idx2};
    else
      fig_type = 'trajs';
    end
    fig_file   = sprintf('%s/%s_%s_%s.fig', SAVE_DIR, file_names{idx1}, time_stamps{idx1}, ...
                 fig_types{idx2});
    theFig     = openfig(fig_file);
    if idx1 > 2 && idx2 == 2
      orient(theFig,'landscape')
      set(theFig, 'PaperUnits', 'inches');
      set(theFig, 'PaperSize', [15, 8.5]);
      print(theFig, sprintf('%s/%s_%s_SI.pdf', SAVE_DIR, SH_names{idx1}, fig_type), ...
          '-opengl', '-r900', '-dpdf');
      close(theFig);
      theFig   = openfig(fig_file);
      theFig   = restructure_trajFig_for_ICML(theFig);
    end
    orient(theFig,'landscape')
    set(theFig, 'PaperUnits', 'inches');
    set(theFig, 'PaperSize', [15, 8.5]);    
    if idx2 == 2
      print(theFig, sprintf('%s/%s_%s', SAVE_DIR, SH_names{idx1}, fig_type), '-opengl', '-r900', ...
        '-dpdf');
    else
      saveas(theFig, sprintf('%s/%s_%s.pdf', SAVE_DIR, SH_names{idx1}, fig_type), 'pdf');       
    end
    close(theFig);
  end
end
end