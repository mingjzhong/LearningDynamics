function visualize_JPL_phihats(obs_info, sys_info, plot_info, learn_info, learn_out)
% function visualize_JPL_phihats(obs_info, sys_info, plot_info, learn_info, learn_out)

% (C) M. Zhong

obs_info.rhoLT           = learn_out.Estimator.rhoLTM;
plot_info.plot_name      = sprintf('%s/%s_%s', learn_info.SAVE_DIR, sys_info.name, ...
                           plot_info.time_stamp);
if isfield(plot_info, 'scrsz'), scrsz = plot_info.scrsz; else, scrsz = get(groot,'ScreenSize'); end
plot_info.scr_pos        = [scrsz(3) * 1/16, scrsz(4) * 1/16, scrsz(3) * 3/4, scrsz(4) * 3/4];
plot_info.scr_xgap       = scrsz(3) * 1/96; 
plot_info.phi_resolution = 250 * ones(sys_info.N);     
plot_info.rho_resolution = plot_info.phi_resolution;
plot_info.showplotlegends = true;
plot_info.phi_type       = 'energy';
for k1 = 1 : sys_info.N
  scr_pos                = plot_info.scr_pos;
  scr_pos(1)             = scr_pos(1) + (k1 - 1) * plot_info.scr_xgap;
  WH                     = figure('Name', sprintf('PhiEhats on %s', sys_info.AO_names{k1}), ...
                           'NumberTitle', 'off', 'Position', scr_pos);
  plot_idx               = 0;
  AHs                    = gobjects(3, 3);
  for k2 = 1 : sys_info.N
    if k2 ~= k1
      plot_idx           = plot_idx + 1;
      AH                 = subplot(3, 3, plot_idx);
      plot_phis_and_rhos_each_type_Ck1Ck2(WH, AH, learn_out.Estimator.Ebasis{k1, k2}.supp, ...
        [], {learn_out.Estimator.rhoLTM{1}{k1, k2}.dense}, ...
        [], learn_out.Estimator.phiEhat(k1, k2), learn_out.Estimator.phiEhatsmooth(k1, k2), ...
        k1, k2, sys_info, plot_info);
      titleHandle        = title([sprintf('%s on %s ', sys_info.AO_names{k2}, ...
                           sys_info.AO_names{k1}), '$\hat\phi^E$']);
      set(titleHandle, 'Interpreter', 'latex', 'FontSize', plot_info.title_font_size,'FontName', ...
        plot_info.title_font_name, 'FontWeight', 'bold' );                         
      row_ind            = floor((plot_idx - 1)/3) + 1;
      col_ind            = mod(plot_idx - 1, 3) + 1;
      AHs(row_ind, col_ind) = AH;
    end
  end
  tightFigaroundAxes(AHs);
  for k2 = 1 : 3
    for k3 = 1 : 3
      AH                          = AHs(k2, k3);
      AH.YAxis(1).TickLabelFormat = '%.2g';
    end
  end  
  print(WH, sprintf('%s/JPL_phiEhats_on_%s', learn_info.SAVE_DIR, sys_info.AO_names{k1}), ...
    '-painters', '-dpng', '-r300');
end
if ~isempty(learn_out.Estimator.phiAhat)
  plot_info.phi_type       = 'alignment';
  for k1 = 1 : sys_info.N
    scr_pos                = plot_info.scr_pos;
    scr_pos(1)             = scr_pos(1) + (k1 + 9) * plot_info.scr_xgap;
    WH                     = figure('Name', sprintf('PhiAhats on %s', sys_info.AO_names{k1}), ...
                             'NumberTitle', 'off', 'Position', scr_pos);
    plot_idx               = 0;
    AHs                    = gobjects(3, 3);
    for k2 = 1 : sys_info.N
      if k2 ~= k1
        plot_idx           = plot_idx + 1;
        AH                 = subplot(3, 3, plot_idx);
        plot_phis_and_rhos_each_type_Ck1Ck2(WH, AH, learn_out.Estimator.Abasis{k1, k2}.supp, ...
          [], {learn_out.Estimator.rhoLTM{1}{k1, k2}.dense}, ...
          [], learn_out.Estimator.phiAhat(k1, k2), learn_out.Estimator.phiAhatsmooth(k1, k2), ...
          k1, k2, sys_info, plot_info);
        titleHandle        = title([sprintf('%s on %s ', sys_info.AO_names{k2}, ...
                             sys_info.AO_names{k1}), '$\hat\phi^A$']);
        set(titleHandle, 'Interpreter', 'latex', 'FontSize', plot_info.title_font_size,'FontName', ...
          plot_info.title_font_name, 'FontWeight', 'bold' );                         
        row_ind            = floor((plot_idx - 1)/3) + 1;
        col_ind            = mod(plot_idx - 1, 3) + 1;
        AHs(row_ind, col_ind) = AH;
      end
    end
    tightFigaroundAxes(AHs);
    for k2 = 1 : 3
      for k3 = 1 : 3
        AH                          = AHs(k2, k3);
        AH.YAxis(1).TickLabelFormat = '%.2g';
      end
    end  
    print(WH, sprintf('%s/JPL_phiAhats_on_%s', learn_info.SAVE_DIR, sys_info.AO_names{k1}), ...
      '-painters', '-dpng', '-r300');
  end
end
end