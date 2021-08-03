function [value, isterminal, direction] = manifold_events(z, sys_info)
% function [value, isterminal, direction] = manifold_events(z, sys_info)

% (C) M. Zhong

value      = get_atlas_condition(z, sys_info);  % the condition on how to stop
isterminal = ones(sys_info.N, 1);               % stop for all events
direction  = zeros(sys_info.N, 1);              % approaching it from both direction
end