function thetas = get_JPL_precession_advance(apsides)
% function thetas = get_JPL_precession_advance(apsides)

% (C) M. Zhong

if ~isempty(apsides)
  apsis1        = apsides(:, 1);
  thetas        = zeros(1, size(apsides, 2));
  for idx = 2 : length(thetas)
    thetas(idx) = get_JPL_angle(apsis1, apsides(:, idx)) * 3600;
  end
else
  thetas        = [];  
end