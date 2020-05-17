function ts = get_JPL_apsidal_times(t_l, r_l)
% function ts = get_JPL_apsidal_times(t_l, r_l)

% (C) M. Zhong

[~, locs1] = findpeaks(r_l);                                                                        % find the local maximas
[~, locs2] = findpeaks(-r_l);                                                                       % find the local minimas
if length(locs1) >= length(locs2)
  ts       = t_l(locs1);
  if isempty(locs1), ts = []; end
else
  ts       = t_l(locs2);
end
end