function range = initialize_range(dim, K, M)
% function range = initialize_range(dim, K, M)

% (C) M. Zhong

if ~isempty(dim)
  range             = cell(K);
  for k1 = 1 : K
    for k2 = 1 : K
      range{k1, k2} = zeros(dim(k1, k2), 2, M);
    end
  end
else
  range             = [];
end
end