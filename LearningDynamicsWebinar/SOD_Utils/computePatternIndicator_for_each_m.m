function pattern_indicator = computePatternIndicator_for_each_m(traj, dtraj, trajhat, dtrajhat, ...
                             total_E, total_Ehat, sys_info)
% function pattern_indicator = computePatternIndicator_for_each_m(traj, dtraj, trajhat, dtrajhat, sys_info)

% (C) M. Zhong (JHU)

LimitCycles       = get_limit_cycles(traj,    dtraj,    total_E,    sys_info);
LimitCycleshat    = get_limit_cycles(trajhat, dtrajhat, total_Ehat, sys_info);
pattern_indicator = compare_limit_cycles(LimitCycles, LimitCycleshat, sys_info);
end