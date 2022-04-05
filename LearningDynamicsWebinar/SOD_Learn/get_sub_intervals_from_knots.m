function subInts = get_sub_intervals_from_knots(idx, knots)
% function subInts = get_sub_intervals_from_knots(idx, knots)

% (C) M. Zhong

dim            = size(knots, 1);
subInts        = cell(1, 2^dim);
switch dim
  case 1
    supp       = knots(idx : idx + 1);
    mid_pt     = (supp(1) + supp(2))/2;
    subInts{1} = [supp(1), mid_pt];
    subInts{2} = [mid_pt, supp(2)];
%   case 2
%     num_subs1 = length(knots{1});
%     idx1      = mod(idx - 1, num_subs1) + 1;
%     idx2      = floor((idx - 1)/num_subs1) + 1;
%     supp      = [knots{1}(idx1), knots{1}(idx1 + 1); ...
%                  knots{2}(idx2), knots{2}(idx2 + 1)];
%   case 3
%     num_subs1 = length(knots{1});
%     num_subs2 = length(knots{2});
%     idx1      = mod(idx - 1, num_subs1 * num_subs2) + 1;
%     idx12     = floor((idx - 1)/(num_subs1 * num_subs2)) + 1;
%     idx2      = mod(idx12 - 1, num_subs2) + 1;
%     idx3      = floor((idx12 - 1)/num_subs2) + 1;
%     supp = [knots{1}(idx1), knots{1}(idx1 + 1); ...
%                  knots{2}(idx2), knots{2}(idx2 + 1); ...
%                  knots{3}(idx3), knots{3}(idx3 + 1)];
  otherwise
    error('SOD_Learn:get_range_from_knots:exception', ...
      'Only 1D support is implemented!!');
end
end