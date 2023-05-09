function [hist_binwidths, hist_edges] = prepare_hist_items(hist_num_bins, rho_range)
% function [hist_binwidths, hist_edges] = prepare_hist_items(hist_num_bins, rho_range)

% (c) M. Zhong (JHU)

hist_binwidths                                 = cell(size(rho_range));                             % for rho^E, rho^A, rho^xi
hist_edges                                     = cell(size(rho_range));
for ind1 = 1 : length(rho_range)
  if ~isempty(rho_range{ind1})
    K                                          = size(rho_range{ind1}, 1);
    hist_binwidths{ind1}                       = cell(K);
    hist_edges{ind1}                           = cell(K);
    for k1 = 1 : K
      for k2 = 1 : K
        if ~isempty(rho_range{ind1}{k1, k2})
          rho_dim                              = size(rho_range{ind1}{k1, k2}, 1);
          hist_binwidths{ind1}{k1, k2}         = cell(1, rho_dim);
          hist_edges{ind1}{k1, k2}             = cell(1, rho_dim);
          for ind2 = 1 : rho_dim
            hist_edges{ind1}{k1, k2}{ind2}     = linspace(rho_range{ind1}{k1, k2}(ind2, 1), ...
              rho_range{ind1}{k1, k2}(ind2, 2), hist_num_bins + 1);
            hist_binwidths{ind1}{k1, k2}{ind2} = (rho_range{ind1}{k1, k2}(ind2, 2) - ...
              rho_range{ind1}{k1, k2}(ind2, 1))/hist_num_bins;
          end
        end
      end
    end
  end
end
end