function [r_range, s_range] = get_effective_range(histdata, R, S)
% function [r_range, s_range] = get_effective_range(histdata, R, S)

% (C) M. Zhong

hist_max     = max(max(histdata));
idx          = 0.1 * hist_max <= histdata & histdata <= hist_max;
r_min        = min(min(R(idx)));
r_max        = max(max(R(idx)));
r_range      = [r_min, r_max];
s_min        = min(min(S(idx)));
s_max        = max(max(S(idx)));
s_range      = [s_min, s_max];
end