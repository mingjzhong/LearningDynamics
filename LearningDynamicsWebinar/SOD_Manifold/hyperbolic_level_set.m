function level_set = hyperbolic_level_set(y)
% function level_set = hyperbolic_level_set(y)

% (C) M. Zhong

d         = size(y, 1);
d_vec     = ones(d, 1);
d_vec(1)  = -1;
level_set = sum(spdiags(d_vec, 0, d, d) * y.^2) + 1;
end