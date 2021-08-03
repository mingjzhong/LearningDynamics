function [x_normalized, x_norm] = normalized_matrix_of_vectors(x, d)
% function [x_normalized, x_norm] = normalized_matrix_of_vectors(x, d)

% (C) M. Zhong (JHU)

[num_rows, N]          = size(x);
if num_rows ~= d && num_rows ~= N * d
  error('SOD_Examples:normalized_matrix_of_vectors:exception', 'The number of rows of x must be either %d or %d!!', d, N * d);
end
x_normalized           = x;
x                      = x.^2;
multiplier             = floor(num_rows/d);
if multiplier == 1
  x_norm               = sum(x);
else
  ind                  = 1 : d : (N - 1) * d + 1;
  x_norm               = x(ind, :);
  for idx = 2 : d
    ind                = idx : d : (N - 1) * d + idx;
    x_norm             = x_norm + x(ind, :);
  end
end
x_norm                 = x_norm.^(0.5);
ind                    = x_norm == 0;
x_norm(ind)            = 1;                                                                         % to avoid division by zero
for idx = 1 : d
  ind                  = idx : d : (multiplier - 1) * d + idx;
  x_normalized(ind, :) = x_normalized(ind, :)./x_norm;
end
end