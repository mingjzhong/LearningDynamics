function [rel_err, abs_err] = get_error_of_a_NdL_matrix(x, x_app, N, d)
% function [rel_err, abs_err] = get_error_of_a_NdL_matrix(x, x_app, N, d)

% (C) M. Zhong

abs_err      = zeros(N, size(x, 2));
x_norm       = zeros(N, size(x, 2));
for d_idx = 1 : d
  ind        = d_idx : d : (N - 1) * d + d_idx; 
  abs_err    = abs_err + (x(ind, :) - x_app(ind, :)).^2;
  x_norm     = x_norm  + x(ind, :).^2;
end
abs_err      = abs_err.^(0.5);
x_norm       = x_norm.^(0.5);
rel_err      = abs_err;
ind          = x_norm ~= 0;
rel_err(ind) = abs_err(ind)./x_norm(ind);
abs_err      = max(abs_err, [], 2);
rel_err      = max(rel_err, [], 2);
end