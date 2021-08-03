function knots = refine_knots(knots_old)
% function knots = refine_knots(knots_old)
 
% (C) M. Zhong

dim   = size(knots_old, 1);
knots = zeros(dim, 2 * size(knots_old, 2) - 1);
for idx = 1 : dim
  mid_pts       = (knots_old(idx, 2 : end) + knots_old(idx, 1 : end - 1))/2;
  knots(idx, :) = union(knots_old(idx, :), mid_pts);
end
end