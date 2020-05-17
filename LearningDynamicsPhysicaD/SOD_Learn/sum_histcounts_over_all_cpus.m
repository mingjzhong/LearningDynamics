function hist_counts = sum_histcounts_over_all_cpus(hist_counts_cpus)
% function hist_counts = sum_histcounts_over_all_cpus(hist_counts_cpus)

% (C) M. Zhong (JHU)

% initialize storage
hist_counts     = hist_counts_cpus{1};
for cpu_id = 2 : length(hist_counts_cpus)
  hist_counts_l = hist_counts_cpus{cpu_id};
  hist_counts   = add_histcounts(hist_counts_l, hist_counts);
end
end