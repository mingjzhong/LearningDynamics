function the_counts = get_the_counts(histcount, histedges, bins)
% function the_counts = get_the_counts(histcount, histedges, bins)

% (C) M. Zhong

[bin_ratios, bin_idxs] = get_bin_items(histedges, bins);
switch size(bins, 1)
  case 1
    the_counts = sum(bin_ratios .* histcount(bin_idxs));
  case 2
    the_counts = sum(sum(bin_ratios .* histcount(bin_idxs(1, :), bin_idxs(2, :))));
  case 3
    the_counts = sum(sum(sum(bin_ratios .* histcount(bin_idxs(1, :), bin_idxs(2, :), bin_idxs(3, :)))));
  otherwise
end
end