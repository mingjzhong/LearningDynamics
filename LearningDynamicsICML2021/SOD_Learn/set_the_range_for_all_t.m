function the_range = set_the_range_for_all_t(the_range_l, K)
% function the_range = set_the_range_for_all_t(the_range_l, K)

% (C) M. Zhong

if ~isempty(the_range_l)
  the_range                              = cell(size(the_range_l));
  for ind = 1 : length(the_range_l)
    if ~isempty(the_range_l{ind})
      the_range{ind}                     = cell(size(the_range_l{ind}));
      for k1 = 1 : K
        for k2 = 1 : K
          if ~isempty(the_range_l{ind}{k1, k2})
            the_range{ind}{k1, k2}       = zeros(size(the_range_l{ind}{k1, k2}, 1), 2);
            the_range{ind}{k1, k2}(:, 1) = get_optimum_of_a_matrix(...
                                           squeeze(the_range_l{ind}{k1, k2}(:, 1, :)), 'min');
            the_range{ind}{k1, k2}(:, 2) = get_optimum_of_a_matrix(...
                                           squeeze(the_range_l{ind}{k1, k2}(:, 2, :)), 'max');
          end
          if norm(the_range{ind}{k1, k2}(:, 1), Inf) == 0 && ...
             norm(the_range{ind}{k1, k2}(:, 2), Inf) == 0  
            the_range{ind}{k1, k2}(:, 2) = 1;
          end
        end
      end
    end
  end
else
  the_range                              = [];
end

end