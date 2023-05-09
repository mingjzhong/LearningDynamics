function hist_counts = perform_histcount(rho_pdist, hist_edges, sys_info)
% function hist_counts = perform_histcount(rho_pdist, hist_edges, sys_info)

% (C) M. Zhong (JHU)

hist_counts                                 = cell(size(rho_pdist));
for ind1 = 1 : length(rho_pdist)
  if ~isempty(rho_pdist{ind1})
    hist_counts{ind1}                       = cell(size(rho_pdist{ind1}));
    for k1 = 1 : size(rho_pdist{ind1}, 1)
      for k2 = 1 : size(rho_pdist{ind1}, 1)
        if ~isempty(rho_pdist{ind1}{k1, k2})
          if length(rho_pdist{ind1}{k1, k2}) > 1
            hist_counts{ind1}{k1, k2}       = cell(1, length(rho_pdist{ind1}{k1, k2}) + 1);
          else
            hist_counts{ind1}{k1, k2}       = cell(1, length(rho_pdist{ind1}{k1, k2}));
          end
          for ind2 = 1 : length(rho_pdist{ind1}{k1, k2}) % the marginals, all 1D
            hist_counts{ind1}{k1, k2}{ind2} = get_histcounts_nd(rho_pdist{ind1}{k1, k2}(ind2), ...
                                              hist_edges{ind1}{k1, k2}(ind2));
          end
          if length(rho_pdist{ind1}{k1, k2}) > 1         % the joint, 2D and up
            hist_counts{ind1}{k1, k2}{end}  = get_histcounts_nd(rho_pdist{ind1}{k1, k2}, ...
                                              hist_edges{ind1}{k1, k2});
          end
        end
      end
    end
  end
end
if sys_info.ode_order == 2 && (isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)) && ...
  (isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA))
  hist_counts_old                           = hist_counts;
  kinds_old                                 = length(hist_counts_old);
  hist_counts                               = cell(1, kinds_old + 1); 
  hist_counts(1 : kinds_old)                = hist_counts_old;
  K                                         = size(rho_pdist{1}, 1);
  hist_counts{kinds_old + 1}                = cell(K);
  for k1 = 1 : K
    for k2 = 1 : K      
      hist_counts{kinds_old + 1}{k1, k2}    = {get_EA_histcounts(rho_pdist{1}{k1, k2}, ...
                                               hist_edges{1}{k1, k2}, rho_pdist{2}{k1, k2}, ...
                                               hist_edges{2}{k1, k2})};
    end
  end
end
end