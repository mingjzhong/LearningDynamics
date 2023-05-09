function [bin_idxs, bin_width, edges]    = get_bin_items_1D(histedges, bins)
% function [bin_idxs, bin_width, edges]    = get_bin_items_1D(histedges, bins)

% (C) M. Zhong (JHU)

num_bins  = length(histedges) - 1;
bin_width = histedges(2) - histedges(1);
edges_idx = bins(1) <= histedges & histedges <= bins(2);
edges     = [bins(1), histedges(edges_idx), bins(2)];
bin_idxs  = [edges_idx(1) - 1, edges_idx];
if bins(1) < histedges(edges_idx(1))
  if edges_idx(1) == 1, edges(1) = []; bin_idxs(1) = []; end
else
  edges(1) = []; bin_idxs(1) = [];
end
if bins(2) > histedges(edges_idx(end))
  if edges_idx(end) > num_bins, edges(end) = []; bin_idxs(end) = []; end
else
  edges(end) = []; bin_idxs(end) = [];
end
end