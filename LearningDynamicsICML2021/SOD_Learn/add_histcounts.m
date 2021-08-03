function hist_counts2 = add_histcounts(m, hist_counts, hist_counts1, learn_info)  
% function hist_counts2 = add_histcounts(m, hist_counts, hist_counts1, learn_info) 
 
% (C) M. Zhong (JHU)

if learn_info.is_parallel
  file_name                                   = sprintf(learn_info.pd_file_form, ...
    learn_info.temp_dir, learn_info.sys_info.name, learn_info.time_stamp, m);
  load(file_name, 'hist_counts');
end
if m ~= 1
  hist_counts2                                = hist_counts1;
  for ind1 = 1 : length(hist_counts)
    if ~isempty(hist_counts{ind1})
      for k1 = 1 : size(hist_counts{ind1}, 1)
        for k2 = 1 : size(hist_counts{ind1}, 1)
          if ~isempty(hist_counts{ind1}{k1, k2})
            for ind2 = 1 : length(hist_counts{ind1}{k1, k2})
              hist_counts2{ind1}{k1, k2}{ind2} = hist_counts{ind1}{k1, k2}{ind2} + ...
                                                 hist_counts1{ind1}{k1, k2}{ind2};
            end
          end
        end
      end
    end
  end
else
  hist_counts2                                = hist_counts;  
end
end