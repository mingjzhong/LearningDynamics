function hist_counts2 = add_histcounts(hist_counts_m, hist_counts1)  
% function hist_counts2 = add_histcounts(hist_counts_m, hist_counts1) 
 
% (C) M. Zhong (JHU)

hist_counts2                                = hist_counts1;
for ind1 = 1 : length(hist_counts_m)
  if ~isempty(hist_counts_m{ind1})
    for k1 = 1 : size(hist_counts_m{ind1}, 1)
      for k2 = 1 : size(hist_counts_m{ind1}, 1)
        if ~isempty(hist_counts_m{ind1}{k1, k2})
          for ind2 = 1 : length(hist_counts_m{ind1}{k1, k2})
            hist_counts2{ind1}{k1, k2}{ind2} = hist_counts_m{ind1}{k1, k2}{ind2} + hist_counts1{ind1}{k1, k2}{ind2};
          end
        end
      end
    end
  end
end
end