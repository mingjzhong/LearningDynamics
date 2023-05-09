function x_norm = get_vmatrix_lpnorm(x, d, p)
% function x_norm = get_vmatrix_lpnorm(x, d, p)

% (C) M. Zhong

validateattributes(d, {'numeric'}, {'positive', 'integer'});
validateattributes(p, {'numeric'}, {'positive', 'real', '>=', 1});
N1       = size(x, 1)/d;
N2       = size(x, 2);
validateattributes(x, {'numeric'}, {'size', [N1 * d, N2]});
x        = x.^p;
x_norm   = zeros(N1, N2);
for idx = 1 : d
  ind    = idx : d : (N1 - 1) * d + idx;
  x_norm = x_norm + x(ind, :);
end
x_norm   = x_norm.^(1/p);
end