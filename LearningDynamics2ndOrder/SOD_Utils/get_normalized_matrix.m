function xhat = get_normalized_matrix(x, d, N)
% function xhat = get_normalized_matrix(x, d, N)

% (C) M. Zhong

validateattributes(d, {'numeric'}, {'positive', 'integer'});
validateattributes(N, {'numeric'}, {'positive', 'integer'});
validateattributes(x, {'numeric'}, {'size', [d, N]});
x_norm      = sum(x.^2).^(0.5);
ind         = x_norm == 0;
x_norm(ind) = 1;
xhat        = x./repmat(x_norm, d, 1);                                                              % normalized by |x|
end