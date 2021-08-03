function num_subs = get_num_subs_from_knots(knots)
% function num_subs = get_num_subs_from_knots(knots)

% (C) M. Zhong

dim      = size(knots, 1);
num_subs = size(knots, 2) - 1;
num_subs = num_subs^dim;
end