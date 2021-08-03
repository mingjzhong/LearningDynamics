function [I_flock, v_CM] = get_flocking_info(v, sys_info)
% function [I_flock, v_CM] = get_flockin_info(v, sys_info)

% (C) M. Zhong

[~, v_CM, ~] = computeCenterOfMassQuantities([], v, [], sys_info);
vij_norm     = pdist(v');                                                                           % |vi - vj| for 1 = i < j < N
I_flock      = sum(vij_norm);
end