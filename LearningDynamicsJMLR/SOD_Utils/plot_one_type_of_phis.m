function plot_one_type_of_phis(win_handler, phi, all_phihat, all_phihatsmooth, ~, learningOutput, ...
         basis_info, sys_info, obs_info, plot_info)
% function plot_one_type_of_phis(phi, phihat, phihatsmooth, basis, learningOutput, sys_info, obs_info)

% (c) M. Zhong (JHU)

% put plots on this particular window
set(groot, 'CurrentFigure', win_handler);
% parameters for plotting
total_num_trials      = length(learningOutput);
switch plot_info.phi_type
    case 'energy'
      rhoLTR            = obs_info.rhoLT.rhoLTE;
    case 'alignment'
      rhoLTR            = obs_info.rhoLT.rhoLTA.rhoLTR;
      rhoLTA            = obs_info.rhoLT.rhoLTA.rhoLTDR;
      rhoLTAemp         = cell(1, total_num_trials);
    case 'xi'
      rhoLTR            = obs_info.rhoLT.rhoLTXi.rhoLTR;
      rhoLTA            = obs_info.rhoLT.rhoLTXi.mrhoLTXi;
      rhoLTAemp         = cell(1, total_num_trials);
    otherwise
end
rhoLTRemp             = cell(1, total_num_trials);
for idx = 1 : total_num_trials
    switch plot_info.phi_type
        case 'energy'
            rhoLTRemp{idx}  = learningOutput{idx}.rhoLTemp.rhoLTE;
            handleAxes      = gobjects(sys_info.K);
        case 'alignment'
            rhoLTRemp{idx}  = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTR;
            rhoLTAemp{idx}  = learningOutput{idx}.rhoLTemp.rhoLTA.rhoLTDR;
            handleAxes      = gobjects(sys_info.K, 2 * sys_info.K);
        case 'xi'
            rhoLTRemp{idx}  = learningOutput{idx}.rhoLTemp.rhoLTXi.rhoLTR;
            rhoLTAemp{idx}  = learningOutput{idx}.rhoLTemp.rhoLTXi.mrhoLTXi;
            handleAxes      = gobjects(sys_info.K, 2 * sys_info.K);
        otherwise
    end
end
max_rs                = zeros(1, total_num_trials);
min_rs                = zeros(1, total_num_trials);
% go through each (k1, k2) pair
for k_1 = 1 : sys_info.K
    for k_2 = 1 : sys_info.K
        clear r phir phihatr phihatsmoothr
        if strcmp(plot_info.phi_type, 'energy')
          subplot(sys_info.K, sys_info.K, (k_1 - 1) * sys_info.K + k_2);                            % put all interaction comparisons in some big fig
        else
          subplot(sys_info.K, 2 * sys_info.K, (k_1 - 1) * 2 * sys_info.K + 2 * k_2 - 1);
        end
        %     for trialIdx = 1 : total_num_trials
        %       basis                     = all_basis{trialIdx};
        %       one_knot                  = basis{k_1, k_2}.knots;                                            % find out the knot vector
        %       range(trialIdx,:)         = [one_knot(1), one_knot(end)];                                     % plot the uniform learning result first; use the knot vectors as the range
        %       r(trialIdx,:)             = refine_knot_vec(one_knot, 10);                                    % refine this knot vector, so that each sub-interval generated a knot has at least 7 interior points, so 3 levels of refinement
        %     end
        %     range                       = [max(range(:,1)),min(range(:,2))];
        %     r                           = unique(r(:));
        %     r(r<range(1) | r>range(2))  = [];
        %
        %     if rhoLTRtemp{trialIdx}.supp{k_1,k_2}(2) - rhoLTRtemp{trialIdx}.supp{k_1,k_2}(1) >0
        %       r = r(r >= rhoLTRtemp{trialIdx}.supp{k_1,k_2}(1) & r <= rhoLTRtemp{trialIdx}.supp{k_1,k_2}(2) );
        %     end
        %     r                              = linspace(r(1),r(end),1000);
        for ind = 1 : total_num_trials
            min_rs(ind)                    = rhoLTRemp{ind}.supp{k_1, k_2}(1);
            max_rs(ind)                    = rhoLTRemp{ind}.supp{k_1, k_2}(2);
        end
        max_r                            = max(max_rs);
        min_r                            = min(min_rs);
        if max_r < min_r + 10 * eps, max_r = min_r + 1; min_r = min_r - 1; end
        range                            = [min_r, max_r];
        r                                = linspace(range(1), range(2),1000);
        phir                             = phi{k_1, k_2}(r);
        for trialIdx = total_num_trials:-1:1
            phihat                         = all_phihat{trialIdx};
            phihatr(trialIdx, :)           = phihat{k_1,k_2}(r);
            if plot_info.display_interpolant
                phihatsmooth               = all_phihatsmooth{trialIdx};
                phihatsmoothr(trialIdx,:)  = phihatsmooth{k_1,k_2}(r);
            else
                phihatsmoothr(trialIdx,:)  = phihatr(trialIdx, :);
            end
        end
        y_min               = max([min(phir(phir > -Inf)), min(phihatr(:)),             min(phihatsmoothr(phihatsmoothr > -Inf))])*1.1;                                                                       % find out the range for y values, f1 might have blow up, just use f_hat
        y_max               = min([max(phir(phir <  Inf)), max(phihatr(phihatr < Inf)), max(phihatsmoothr(phihatsmoothr <  Inf))])*1.1;
        if y_max < y_min + 10*eps, y_max = y_min + 1; y_min = y_min - 1; end
        
        edges               = rhoLTR.histedges{k_1, k_2};                                           % approximated \rho_T^L's
        edges_idxs          = find(range(1) <= edges & edges <= range(2));
        if ~isempty(rhoLTR.hist{k_1, k_2})
          [histdata,edges]    = downsampleHistCounts( rhoLTR.hist{k_1,k_2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
          centers             = (edges(1 : end - 1) + edges(2 : end))/2;
        else
          centers            = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
          histdata           = zeros(size(centers));
        end
        yyaxis right;                                                                               % display \rho^L_T and its estimator
        axesHandle1          = gca();
        axesHandle1.FontSize = plot_info.tick_font_size;
        axesHandle1.FontName = plot_info.tick_font_name;        
        histHandle1          = plot(centers, histdata,'k','LineWidth',1);    hold on;
        color1               = get(gca,'YColor');
        set(histHandle1,'Color', color1);
        hist1                = fill(centers(([1 1:end end])),[0 histdata' 0], color1/2,'EdgeColor','none','FaceAlpha',0.1);
        
        edges                = rhoLTRemp{1}.histedges{k_1, k_2};                                     % Estimated \rho's
        edges_idxs           = find(range(1) <= edges & edges <= range(2));
        if ~isempty(rhoLTRemp{1}.hist{k_1, k_2})
          [histdata2,edges]    = downsampleHistCounts( rhoLTRemp{1}.hist{k_1,k_2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
          centers             = (edges(1 : end - 1) + edges(2 : end))/2;
        else
          centers             = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
          histdata2          = zeros(size(centers));
        end
        histHandle2         = plot(centers,histdata2,'k--','LineWidth',1);
        color2              = get(gca,'YColor');
        set(histHandle2,'Color', color2);
        hist2               = fill(centers(([1 1:end end])),[0 histdata2' 0], color2,'EdgeColor',...
            'none','FaceAlpha',0.1);
        axis tight;
        tmpmax = plot_info.rhotscalingdownfactor * max(max(histdata(:)), max(histdata2));
        if tmpmax==0, tmpmax = 1; end
        if isnan(tmpmax), tmpmax = 1; end
        if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
        axis([range(1), range(2), 0, tmpmax]);
        if tmpmax == 1
          Escale                             = 1;
        else 
          Escale                             = int32(log10(tmpmax));
        end
        axesHandle1.YAxis(2).Exponent        = Escale;
        axesHandle1.YAxis(2).TickLabelFormat = '%.2g';
%         ylabelHandle = ylabel(axesHandle1,'$\rho^L_T, \rho^{L,M}_T$','Interpreter','latex','FontSize',AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);
%         set(ylabelHandle,'VerticalAlignment','bottom');
%         set(ylabelHandle,'Position',get(ylabelHandle,'Position').*[0.95,0.33,1]);                 % TBD better
        yyaxis left                                                                                 % display interaction kernels
        axesHandle2           = gca();
        axesHandle2.FontSize  = plot_info.tick_font_size;
        axesHandle2.FontName  = plot_info.tick_font_name;  
        if plot_info.display_interpolant && plot_info.display_phihat
          legendPlotHandles   = gobjects(1, 3);
          legendPlotStrings   = cell(1, 5);
        else
          legendPlotHandles   = gobjects(1, 2);
          legendPlotStrings   = cell(1, 4);  
        end
        LP_counter            = 1;        
        legendPlotHandles(LP_counter) = plot(r, phir, 'k', 'LineWidth', plot_info.phi_line_width); hold on
        switch plot_info.phi_type
          case 'energy'
            if sys_info.ode_order == 1
              legend_name = '$\phi$';
            else
              legend_name = '$\phi^E$';
            end
          case 'alignment'
            legend_name = '$\phi^A$';
          case 'xi'
            legend_name = '$\phi^{\xi}$';
          otherwise
        end
        legendPlotStrings{LP_counter}=legend_name;
        % subidx = ceil(linspace(1,length(r)-1,32));
        %         plotHandle2=errorbar(r(subidx),mean(phiEhatr(:,subidx),1),std(phiEhatr(:,subidx),1));
        %         set(plotHandle2,'LineStyle','none','LineWidth',PHIHAT_LINE_WIDTH/4,'Color','g');
        if plot_info.display_phihat || ~plot_info.display_interpolant
            LP_counter              = LP_counter + 1;
            legendPlotHandles(LP_counter)=plot(r, mean(phihatr,1),  '-r', 'LineWidth', plot_info.phihat_line_width);                    % plot the learned phi
            switch plot_info.phi_type
              case 'energy'
                if sys_info.ode_order == 1
                  legend_name = '$\hat\phi$';
                else
                  legend_name = '$\hat\phi^E$';
                end
              case 'alignment'
                legend_name = '$\hat\phi^A$';
              case 'xi'
                legend_name = '$\hat\phi^{\xi}$';
              otherwise
            end
            legendPlotStrings{LP_counter}=legend_name;
            plot(r, mean(phihatr,1)+std(phihatr,[],1),  '--r', 'LineWidth', plot_info.phihat_line_width/4);
            plot(r, mean(phihatr,1)-std(phihatr,[],1),  '--r', 'LineWidth', plot_info.phihat_line_width/4);
        end
        plot(r,zeros(size(r)),'k--');
        if plot_info.display_interpolant
            %if DISPLAY_PHIHAT, set(legendPlotHandles(end),'LineWidth',PHIHAT_LINE_WIDTH/16); end
            LP_counter              = LP_counter + 1;
            legendPlotHandles(LP_counter) = plot(r, mean(phihatsmoothr,1),  '-b', 'LineWidth', plot_info.phihat_line_width);         % plot the learned phi, smoothed
            if ~plot_info.display_phihat
              switch plot_info.phi_type
                case 'energy'
                  if sys_info.ode_order == 1
                    legend_name = '$\hat\phi$';
                  else
                    legend_name = '$\hat\phi^E$';
                  end
                case 'alignment'
                  legend_name = '$\hat\phi^A$';
                case 'xi'
                  legend_name = '$\hat\phi^{\xi}$';
                otherwise
              end          
            else
              switch plot_info.phi_type
                case 'energy'
                  if sys_info.ode_order == 1
                    legend_name = '$\phi^{reg}$';
                  else
                    legend_name = '$\phi^{E, reg}$';
                  end
                case 'alignment'
                  legend_name = '$\phi^{A, reg}$';
                case 'xi'
                  legend_name = '$\phi^{\xi, reg}$';
                otherwise
              end                
            end
            legendPlotStrings{LP_counter}=legend_name;
            plot(r, mean(phihatsmoothr,1)+std(phihatsmoothr,[],1),  '--b', 'LineWidth', plot_info.phihat_line_width/4);
            plot(r, mean(phihatsmoothr,1)-std(phihatsmoothr,[],1),  '--b', 'LineWidth', plot_info.phihat_line_width/4);
        end
        if sys_info.K > 1
            for p = 1:length(legendPlotStrings)-2
                legendPlotStrings{p} = sprintf('$%s_{%d,%d}$',legendPlotStrings{p}(2:end-1),k_1,k_2);
            end
          if sys_info.ode_order == 1
            legendPlotStrings{end-1} = ['$\rho_T^{L',    sprintf(', %d%d}$', k_1, k_2)];
            legendPlotStrings{end}   = ['$\rho_T^{L, M', sprintf(', %d%d}$', k_1, k_2)];          
          else
            legendPlotStrings{end-1} = ['$\rho_{T, r}^{L',    sprintf(', %d%d}$', k_1, k_2)];
            legendPlotStrings{end}   = ['$\rho_{T, r}^{L, M', sprintf(', %d%d}$', k_1, k_2)];               
          end
        else
          if sys_info.ode_order == 1
            legendPlotStrings{end-1} = '$\rho_T^L$';
            legendPlotStrings{end}   = '$\rho_T^{L, M}$';         
          else
            legendPlotStrings{end-1} = '$\rho_{T, r}^L$';
            legendPlotStrings{end}   = '$\rho_{T, r}^{L, M}$';               
          end        
        end
        legendHandle2 = legend([legendPlotHandles, hist1, hist2], legendPlotStrings);
%         if sys_info.K > 1
%             ylabelString=['$\phi_{' sprintf('%d, %d', k_1, k_2) '}'];
%             if DISPLAY_PHIHAT
%                 ylabelString = [ylabelString ',\hat{\phi}_{' sprintf('%d, %d', k_1, k_2) '}'];
%             end
%             if DISPLAY_INTERPOLANT
%                 ylabelString = [ylabelString ',\hat{\phi}_{' sprintf('%d, %d', k_1, k_2) '}^{reg}'];
%             end
%             ylabelString = [ylabelString, '$'];
% 
%             ylabel(ylabelString,'Interpreter','latex','FontSize',AXIS_FONT_SIZE);
%         else
%             ylabelString='$\phi';
%             if DISPLAY_PHIHAT
%                 ylabelString = [ylabelString ',\hat{\phi}'];
%             end
%             if DISPLAY_INTERPOLANT
%                 ylabelString = [ylabelString ',\hat{\phi}^{reg}'];
%             end
%             ylabelString = [ylabelString, '$'];
% 
%             ylabel(ylabelString,'Interpreter','latex','FontSize',AXIS_FONT_SIZE);
%         end
        %    set(legendHandle2, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', LEGEND_FONT_SIZE, 'AutoUpdate', 'off');
        set(legendHandle2, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
        axis([range(1), range(2), y_min-(y_max-y_min)*0.1, y_max]);                                     % set up a uniform x-range, tighten the y-range
        if k_1==sys_info.K
            xlabel('r (pairwise distance)','FontSize', plot_info.axis_font_size);
        end
        
        if plot_info.showplottitles
            titleHandle = title(sprintf('N = %d, T = %.0f, M = %d, L = %d, n = %d', sys_info.N, obs_info.T_L, obs_info.M, ...
                obs_info.L, basis_info.n(k_1,k_2)), ...
                'FontSize',plot_info.title_font_size);
            set( titleHandle,'Position',get(titleHandle,'Position')-[0,0.05,0]);
            set( titleHandle, 'Interpreter', 'Latex', 'FontSize', plot_info.title_font_size,'FontName', plot_info.title_font_name,'FontWeight','bold' );
        end      
        if strcmp(plot_info.phi_type, 'energy')
            handleAxes(k_1,k_2) = gca;
            handleAxes(k_1,k_2).YAxis(1).TickLabelFormat = '%+g';
        else
            handleAxes(k_1, 2 * k_2 - 1) = gca;
            handleAxes(k_1, 2 * k_2 - 1).YAxis(1).TickLabelFormat = '%+g';
        end
        if ~strcmp(plot_info.phi_type, 'energy')
            range               = rhoLTAemp{1}.supp{k_1, k_2};
            edges               = rhoLTA.histedges{k_1, k_2};                                       % Estimated \rho's
            edges_idxs          = find(range(1) <= edges & edges <= range(2));
            if ~isempty(rhoLTA.hist{k_1, k_2})
              [histdata,edges]    = downsampleHistCounts( rhoLTA.hist{k_1,k_2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
              centers             = (edges(1 : end - 1) + edges(2 : end))/2;
            else
              centers             = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
              histdata          = zeros(size(centers));
            end                                                                                    % display \rho^L_T and its estimator
            subplot(sys_info.K, 2 * sys_info.K, (k_1 - 1) * 2 * sys_info.K + 2 * k_2);          
            histHandle1         = plot(centers, histdata,'k', 'LineWidth', 1);    hold on;
            set(histHandle1, 'Color', color1);
            hist1               = fill(centers(([1 1:end end])),[0 histdata' 0], color1/2, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
            edges               = rhoLTAemp{1}.histedges{k_1, k_2};                                 % Estimated \rho's
            edges_idxs          = find(range(1) <= edges & edges <= range(2));
            if ~isempty(rhoLTAemp{1}.hist{k_1, k_2})
              [histdata2,edges]    = downsampleHistCounts( rhoLTAemp{1}.hist{k_1,k_2}(edges_idxs(1 : end - 1)), edges(edges_idxs), sqrt(length(edges_idxs))/2 );
              centers             = (edges(1 : end - 1) + edges(2 : end))/2;
            else
              centers             = (edges(edges_idxs(1 : end - 1)) + edges(edges_idxs(2 : end)))/2;
              histdata2          = zeros(size(centers));
            end
            histHandle2         = plot(centers, histdata2, 'k--', 'LineWidth', 1);
            set(histHandle2, 'Color', color2);
            hist2               = fill(centers(([1 1:end end])), [0 histdata2' 0], color2,'EdgeColor', 'none','FaceAlpha', 0.1);
            axis tight;
            tmpmax              = plot_info.rhotscalingdownfactor * max(max(histdata(:)), max(histdata2));
            if tmpmax == 0,   tmpmax = 1; end
            if isnan(tmpmax), tmpmax = 1; end
            if abs(range(2) - range(1)) < 1.0e-12, range(2) = range(1) + 1; end
            axis([range(1), range(2), 0, tmpmax]);
            axesHandle3          = gca();
            axesHandle3.FontSize = plot_info.tick_font_size;
            axesHandle3.FontName = plot_info.tick_font_name;              
            axesHandle3.YAxis.Exponent        = int32(log10(tmpmax));
            axesHandle3.YAxis.TickLabelFormat = '%.2g';
%             if strcmp(phi_type, 'alignment')
%               if sys_info.K == 1
%                 ylabel_name = '$\hat\rho^{L, A}_T, \rho^{L, M, A}_T$';
%               else
%                 ylabel_name = sprintf('$\hat\rho^{L, A}_{T, %d, %d}, \rho^{L, M, A}_{T, %d, %d}$', k_1, k_2, k_1, k_2);
%               end
%             elseif strcmp(phi_type, 'xi')
%               if sys_info.K == 1
%                 ylabel_name = '$\hat\rho^{L, \xi}_T, \rho^{L, M, \xi}_T$';
%               else
%                 ylabel_name = sprintf('$\hat\rho^{L, \xi}_{T, %d, %d}, \rho^{L, M, \xi}_{T, %d, %d}$', k_1, k_2, k_1, k_2);
%               end              
%             end
%             ylabelHandle = ylabel(axesHandle1, ylabel_name);
%             set(ylabelHandle, 'Interpreter', 'latex', 'FontSize', AXIS_FONT_SIZE, 'FontName', AXIS_FONT_NAME);
            if k_1==sys_info.K
              if strcmp(plot_info.phi_type, 'alignment')
                xlabelHandle = xlabel('$\dot{r}$ (pairwise speed)','FontSize',plot_info.axis_font_size);
              elseif strcmp(plot_info.phi_type, 'xi')
                xlabelHandle = xlabel('$\xi$ (pairwise $\xi_{i, i''}$)','FontSize',plot_info.axis_font_size);
              end
              set(xlabelHandle, 'Interpreter', 'latex', 'FontSize', plot_info.axis_font_size, 'FontName', plot_info.axis_font_name); 
            end     
            if strcmp(phi_type, 'alignment')
              if sys_info.K == 1
                legend_names = {'$\rho^{L}_{T, \dot{r}}$', '$\rho^{L, M}_{T, \dot{r}}$'};
              else
                legend_names = {['$\rho_{T, \dot{r}}^{L, ', sprintf('%d%d}$', k_1, k_2)], ['$\rho_{T, \dot{r}}^{L, M,', sprintf('%d%d}$', k_1, k_2)]};
              end
            elseif strcmp(phi_type, 'xi')
              if sys_info.K == 1
                legend_names = {'$\rho^{L}_{T, \xi}$', '$\rho^{L, M}_{T, \xi}$'};
              else
                legend_names = {['$\rho_{T, \xi}^{L, ', sprintf('%d%d}$', k_1, k_2)], ['$\rho_{T, \xi}^{L, M,', sprintf('%d%d}$', k_1, k_2)]};
              end
            end
            legendHandle = legend([hist1, hist2], legend_names);
            set(legendHandle, 'Location', 'NorthEast', 'Interpreter', 'latex', 'FontSize', plot_info.legend_font_size);
            handleAxes(k_1, 2 * k_2) = gca;
        end
    end
end
tightFigaroundAxes( handleAxes );
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    if strcmp(plot_info.phi_type, 'energy')
      axis_handle = handleAxes(k1, k2);
    else
      axis_handle = handleAxes(k1, 2 * k2 - 1);
    end
    axis_handle.YAxis(1).TickLabelFormat = '%g';
  end
end
end