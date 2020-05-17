function show_JPL_precession_rate(sys_info, ts_s, thetas_s)
% function show_JPL_precession_rate(sys_info, ts_s, thetas_s)

% (C) M. Zhong

dyn_names        = {'Observed', 'EIH', 'CubicLD', 'Newton'};
for idx1 = 2 : sys_info.N
  PI_info.type   = sys_info.AO_names{idx1};
  fprintf('\nPrecession Rate on %8s for each dynamics:', sys_info.AO_names{idx1});
  for idx2 = 1 : length(dyn_names)
    ts           = ts_s{idx1 - 1, idx2};
    thetas       = thetas_s{idx1 - 1, idx2};
    [ts, thetas] = set_JPL_thetas_postprocessing(ts, thetas, PI_info.type);
    PR           = get_JPL_precession_rate(ts, thetas, PI_info);
    fprintf('\n\tFor %8s dynamics, the rate is: %10.4e%c%10.4e.', dyn_names{idx2}, PR(1), 177, PR(2));
  end
end
end