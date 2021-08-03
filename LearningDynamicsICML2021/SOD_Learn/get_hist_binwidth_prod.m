function product = get_hist_binwidth_prod(binwidths)
% function product = get_hist_binwidth_prod(binwidths)

% (C) M. Zhong

product   = 1;
for ind = 1 : length(binwidths)
  product = product * binwidths{ind};
end
end