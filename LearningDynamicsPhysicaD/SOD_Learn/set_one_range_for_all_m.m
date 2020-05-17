function range_new = set_one_range_for_all_m(K, range)
% function range_new = set_one_range_for_all_m(K, range)

% (C) M. Zhong

if ~isempty(range)
  range_new                              = cell(size(range));
  for ind = 1 : length(range)
    if ~isempty(range{ind})
      range_new{ind}                     = cell(K);
      for k1 = 1 : K
        for k2 = 1 : K
          if ~isempty(range{ind}{k1, k2})
            range_new{ind}{k1, k2}(:, 1)       = get_optimum_of_a_matrix(squeeze(range{ind}{k1, k2}(:, 1, :)), 'min');
            range_new{ind}{k1, k2}(:, 2)       = get_optimum_of_a_matrix(squeeze(range{ind}{k1, k2}(:, 2, :)), 'max');
            rho_dim                            = size(range_new{ind}{k1, k2}, 1);
            for idx = 1 : rho_dim
              if range_new{ind}{k1, k2}(idx, 1) == range_new{ind}{k1, k2}(idx, 2)
                range_new{ind}{k1, k2}(idx, 2) = range_new{ind}{k1, k2}(idx, 1) + 1;
              end
            end
          end
        end
      end
    end
  end
else
  range_new                              = [];
end
end