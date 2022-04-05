function new_range = get_the_range(range_m, old_range)
% function new_range = get_the_range(range_m, old_range)

% (C) M. Zhong

new_range    = range_m;
if ~isempty(old_range)
  for kind_idx = 1 : length(range_m)
    for k1 = 1 : size(range_m{kind_idx}, 1)
      for k2 = 1 : size(range_m{kind_idx}, 2)
        new_range{kind_idx}{k1, k2}(:, 1) = min([range_m{kind_idx}{k1, k2}(:, 1), ...
                                               old_range{kind_idx}{k1, k2}(:, 1)], [], 2);
        new_range{kind_idx}{k1, k2}(:, 2) = max([range_m{kind_idx}{k1, k2}(:, 2), ...
                                               old_range{kind_idx}{k1, k2}(:, 2)], [], 2);                                             
      end
    end
  end
end
end