function [PI, apsis_locs] = get_JPL_PI_from_findpeaks(t_min, r_min, is_Neptune)
% function [PI, apsis_locs] = get_JPL_PI_from_findpeaks(t_min, r_min, is_Neptune)

% (C) M. Zhong

PI              = zeros(3, 2);
if ~is_Neptune
  [pks1, locs1] = findpeaks(r_min);
  [pks2, locs2] = findpeaks(-r_min);
else
  params        = sineFit_using_FFT(t_min, r_min, 'some padding');
  sineFit       = @(t) params(1) + params(2) * sin(2 * pi * params(3) * t + params(4));
  r_min_Fit     = sineFit(t_min);
  [~, locs1]    = findpeaks(r_min_Fit);
  [~, locs2]    = findpeaks(-r_min_fit);
  pks1          = r_min(locs1);
  pks2          = -r_min(locs2);
  clear r_min_Fit
end
PI(1, 1)        = mean(pks1);
PI(1, 2)        = std(pks1);
PI(2, 1)        = mean(-pks2);
PI(2, 2)        = std(-pks2);
periods1        = diff(t_min(locs1));
periods2        = diff(t_min(locs2));
if isempty(periods1) && isempty(periods2)
  if length(locs1) == 1 && length(locs2) == 1
    periods1    = 2 * abs(t_min(locs1) - t_min(locs2));
  end
end
PI(3, 1)        = mean([periods1, periods2]);
PI(3, 2)        = std([periods1, periods2]);
if length(locs1) >= length(locs2)
  apsis_locs    = locs1;
else
  apsis_locs    = locs2;
end
end