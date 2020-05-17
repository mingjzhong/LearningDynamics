function range = set_one_range_for_all_t(range_l, m, K, range)
% function range = set_one_range_for_all_t(range_l, m, K, range)

% (C) M. Zhong (JHU)

if ~isempty(range_l)
  for ind = 1 : length(range_l)
    if ~isempty(range_l{ind})
      for k1 = 1 : K
        for k2 = 1 : K
          if ~isempty(range_l{ind}{k1, k2})
            range{ind}{k1, k2}(:, 1, m) = get_optimum_of_a_matrix(squeeze(range_l{ind}{k1, k2}(:, 1, :)), 'min');
            range{ind}{k1, k2}(:, 2, m) = get_optimum_of_a_matrix(squeeze(range_l{ind}{k1, k2}(:, 2, :)), 'max');
          end
        end
      end
    end
  end
end
end