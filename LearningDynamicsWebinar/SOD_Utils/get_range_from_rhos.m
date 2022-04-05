function range = get_range_from_rhos(rhos)
% function range = get_range_from_rhos(rhos)

% (C) M. Zhong (JHU)

range       = [];
if ~isempty(rhos)
  if ~isempty(rhos{1})
    range   = rhos{1}.supp;
  end
  if length(rhos) > 1
    for idx = 2 : length(rhos)
      range = max(range, rhos{idx}.supp);
    end
  end
end
end
