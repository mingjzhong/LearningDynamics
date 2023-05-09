function [new_min, new_max] = get_adjusted_traj_range(old_min, old_max)
% function [new_min, new_max] = get_adjusted_traj_range(old_min, old_max)

% (C) M. Zhong

range   = old_max - old_min;
if range == 0; range = 1; end
new_min = old_min - 0.05 * range;
new_max = old_max + 0.05 * range;
end