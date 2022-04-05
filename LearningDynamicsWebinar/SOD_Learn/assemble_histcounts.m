function total_HC = assemble_histcounts(M, hist_edges, learn_info)
% function total_HC = assemble_histcounts(M, hist_edges, learn_info)

% (C) M. Zhong

if learn_info.is_parallel
  parfor m = 1 : M
    assemble_histcounts_at_m(m, hist_edges, learn_info);
  end
  total_HC        = [];
  for m = 1 : M
    total_HC      = add_histcounts(m, [], total_HC, learn_info);
  end
else
  total_HC        = [];
  for m = 1 : M
    hist_counts_m = assemble_histcounts_at_m(m, hist_edges, learn_info);
    total_HC      = add_histcounts(m, hist_counts_m, total_HC, learn_info);
  end
end
end