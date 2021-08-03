function y_pro = projection_on_to_sphere(y, d, N, R)
%  function y_pro = projection_on_to_sphere(y, d, N, R)

% (C) M. Zhong

y      = reshape(y, [d, N]);
y_norm = sum(y.^2).^(0.5);
y      = y./repmat(y_norm, d, 1);
y_pro  = y(:) * R;
end