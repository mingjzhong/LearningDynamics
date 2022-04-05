function [bin_ratios, bin_idxs] = get_bin_items(histedges, bins)
% function [bin_ratios, bin_idxs] = get_bin_items(histedges, bins)

% (C) M. Zhong (JHU)

switch size(bins, 1)
  case 1
    [bin_idxs, bin_width, edges]    = get_bin_items_1D(histedges, bins);
    bin_ratios                      = (edges(2 : end) - edges(1 : end - 1))/bin_width;
  case 2
    [bin_idxs1, bin_width1, edges1] = get_bin_items_1D(histedges(1, :), bins(1, :));
    [bin_idxs2, bin_width2, edges2] = get_bin_items_1D(histedges(2, :), bins(2, :));
    bin_idxs                        = [bin_idxs1; bin_idxs2];
    bin_ratios1                     = (edges1(2 : end) - edges1(1 : end - 1))/bin_width1;   
    bin_ratios2                     = (edges2(2 : end) - edges2(1 : end - 1))/bin_width2;
    [X, Y]                          = ndgrid(bin_ratios1, bin_ratios2);
    bin_ratios                      = X .* Y;
  case 3
    [bin_idxs1, bin_width1, edges1] = get_bin_items_1D(histedges(1, :), bins(1, :));
    [bin_idxs2, bin_width2, edges2] = get_bin_items_1D(histedges(2, :), bins(2, :));
    [bin_idxs3, bin_width3, edges3] = get_bin_items_1D(histedges(3, :), bins(3, :));
    bin_idxs                        = [bin_idxs1; bin_idxs2; bin_idxs3];
    bin_ratios1                     = (edges1(2 : end) - edges1(1 : end - 1))/bin_width1;   
    bin_ratios2                     = (edges2(2 : end) - edges2(1 : end - 1))/bin_width2;
    bin_ratios3                     = (edges3(2 : end) - edges3(1 : end - 1))/bin_width3;
    [X, Y, Z]                       = ndgrid(bin_ratios1, bin_ratios2, bin_ratios3);
    bin_ratios                      = X .* Y .* Z;
  otherwise
end
end