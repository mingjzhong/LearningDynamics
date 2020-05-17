function thetas = get_JPL_difference_in_angle(xNs, xNp1, fNs_diff)
% function thetas = get_JPL_difference_in_angle(xNs, xNp1, fNs_diff)

% (C) M. Zhong

d                = 3;
thetas           = zeros(length(fNs_diff), size(xNs, 2));
for idx = 1 : length(fNs_diff)
  thetas(idx, :) = get_angle_between_vectors(xNp1 - xNs((idx - 1) * d + 1 : idx * d, :), ...
                   fNs_diff{idx});
end
end