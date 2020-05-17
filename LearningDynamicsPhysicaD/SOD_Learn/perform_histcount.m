function hist_counts = perform_histcount(rho_pdist, hist_edges)
% function hist_counts = perform_histcount(rho_pdist, hist_edges)

% (C) M. Zhong (JHU)

hist_counts                                      = cell(size(rho_pdist));
for ind1 = 1 : length(rho_pdist)
  if ~isempty(rho_pdist{ind1})
    hist_counts{ind1}                            = cell(size(rho_pdist{ind1}));
    for k1 = 1 : size(rho_pdist{ind1}, 1)
      for k2 = 1 : size(rho_pdist{ind1}, 1)
        if ~isempty(rho_pdist{ind1}{k1, k2})
          if length(rho_pdist{ind1}{k1, k2}) > 1
            hist_counts{ind1}{k1, k2}            = cell(1, length(rho_pdist{ind1}{k1, k2}) + 1);
          else
            hist_counts{ind1}{k1, k2}            = cell(1, length(rho_pdist{ind1}{k1, k2}));
          end
          for ind2 = 1 : length(rho_pdist{ind1}{k1, k2}) % the marginals, all 1D
            hist_counts{ind1}{k1, k2}{ind2}      = histcounts(rho_pdist{ind1}{k1, k2}{ind2}, ...
              hist_edges{ind1}{k1, k2}{ind2});
          end
          if length(rho_pdist{ind1}{k1, k2}) > 1
            switch length(rho_pdist{ind1}{k1, k2}) % the joint, might be 2D or 3D (no need to proceed any further)
              case 2
                hist_counts{ind1}{k1, k2}{2 + 1} = histcounts2(rho_pdist{ind1}{k1, k2}{1}, rho_pdist{ind1}{k1, k2}{2}, ...
                  hist_edges{ind1}{k1, k2}{1}, hist_edges{ind1}{k1, k2}{2});
              case 3
                hist_counts{ind1}{k1, k2}{3 + 1} = histcounts3(rho_pdist{ind1}{k1, k2}{1}, rho_pdist{ind1}{k1, k2}{2}, ...
                  rho_pdist{ind1}{k1, k2}{3}, hist_edges{ind1}{k1, k2}{1}, hist_edges{ind1}{k1, k2}{2}, ...
                  hist_edges{ind1}{k1, k2}{3});
              otherwise
                error('SOD_Learn:perform_histcount:exception', 'Only 1D, 2D and 3D histcounts are supported!!');
            end
          end
        end
      end
    end
  end
end
end