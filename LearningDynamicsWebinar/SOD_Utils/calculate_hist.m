function hist = calculate_hist(histcount, histedges)
% function hist = calculate_hist(histcount, histedges)

% (C) M. Zhong

total_counts = sum(histcount(:));
bin_widths   = histedges(:, 2) - histedges(:, 1);
bin_size     = prod(bin_widths, 'all');
hist         = histcount/(total_counts * bin_size);
end