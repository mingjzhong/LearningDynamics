function [ts_new, thetas_new] = set_JPL_thetas_postprocessing(ts, thetas, type)
% function [ts_new, thetas_new] = set_JPL_thetas_postprocessing(ts, thetas, type)

% (C) 

switch type   
  case 'Moon'
    ts_new                    = ts;
    [pks1, locs1]             = findpeaks(thetas);
    [pks2, locs2]             = findpeaks(-thetas);
    [~, pk_locs]              = findpeaks(pks1);
    [~, vy_locs]              = findpeaks(pks2);
    ext_locs                  = union(locs1(pk_locs), locs2(vy_locs));
    thetas_new                = thetas;
    for idx = 1 : length(ext_locs) - 1
      ind1                    = ext_locs(idx) + 1;
      ind2                    = ext_locs(idx + 1);
      thetas_new(ind1 : ind2) = thetas_new(ind1 : ind2) + idx * 180 * 3600;
    end
    if ext_locs(end) < length(thetas)
      ind1                    = ext_locs(end) + 1;
      ind2                    = length(thetas);
      thetas_new(ind1 :ind2)  = thetas_new(ind1 : ind2) + (idx + 1) * 180 * 3600;
    end
  otherwise
    ts_new                    = ts;
    thetas_new                = thetas;  
end
end