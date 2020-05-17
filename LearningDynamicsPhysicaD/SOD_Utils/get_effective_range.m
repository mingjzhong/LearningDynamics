function range = get_effective_range(histdata, centers)
% function range = get_effective_range(histdata, centers)

% (C) M. Zhong

hist_max = max(histdata);
idx      = 0.05 * hist_max <= histdata & histdata <= hist_max;
r_min    = min(centers(idx));
r_max    = max(centers(idx));
range    = [r_min, r_max];
end