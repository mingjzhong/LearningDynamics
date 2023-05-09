function has_intersect = check_intersection(idx_start, idx_end, supp, supp_range)
% function has_intersect = check_intersection(idx_start, idx_end, supp, supp_range)

% (C) M. Zhong

num_checks    = idx_end - idx_start;
indicators    = false(1, num_checks);
for idx1 = 1 : num_checks
  supp_idx    = idx_start + idx1 - 1;
  numSubs     = length(supp) - 1;
  inter_indic = false(1, numSubs);
  for idx2 = 1 : numSubs
    interval  = intersectInterval(supp(idx2 : idx2 + 1), supp_range{supp_idx});
    if ~isempty(interval), inter_indic(idx2) = true; end
  end
  if nnz(inter_indic) > 0, indicators(idx1) = true; end
end
if nnz(indicators) > 0, has_intersect = true; else, has_intersect = false; end
end