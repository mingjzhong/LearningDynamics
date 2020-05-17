function rdata3 = process_range_data(rdata1, rdata2)
% function rdata3 = process_range_data(rdata1, rdata2)

% (C) M. Zhong

validateattributes(rdata2, {'cell'}, {'size', size(rdata1)}, 'process_range_data', 'rdata2', 2);
rdata3                              = cell(size(rdata1));
for ind = 1 : length(rdata1)
  if ~isempty(rdata1{ind})
    rdata3{ind}                     = cell(size(rdata1{ind}));
    for k1 = 1 : size(rdata1{ind}, 1)
      for k2 = 1 : size(rdata1{ind}, 1)
        if ~isempty(rdata1{ind}{k1, k2})
          rdata3{ind}{k1, k2}       = zeros(size(rdata1{ind}{k1, k2}));
          rdata3{ind}{k1, k2}(:, 1) = min(rdata1{ind}{k1, k2}(:, 1), rdata2{ind}{k1, k2}(:, 1));
          rdata3{ind}{k1, k2}(:, 2) = max(rdata1{ind}{k1, k2}(:, 2), rdata2{ind}{k1, k2}(:, 2));
        end
      end
    end
  end
end
end