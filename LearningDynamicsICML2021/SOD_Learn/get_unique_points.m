function [r_uni, s_uni] = get_unique_points(r, s)
% function [r_uni, r_uni] = get_unique_points(r, s)

% (C) M. Zhong

[r_uni, ~, IC] = unique(r);
s_uni          = zeros(size(r_uni));
for idx = 1 : length(r_uni)
  ind          = IC == idx;
  s_uni(idx)   = max(s(ind));
end
end