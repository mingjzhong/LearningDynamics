function grad_f = hyperbolic_level_gradient(y)
% function grad_f = hyperbolic_level_gradient(y)

% (C) M. Zhong

% f(p) = -y(1)^2 + \sum_{i = 2}^d y(i)^2 + 1 = 0
% \nabla(f) = [-2y(1); 2y(2); \vdots; 2y(d)]
d        = size(y, 1);
d_vec    = 2 * ones(d, 1);
d_vec(1) = -2;
grad_f   = spdiags(d_vec, 0, d, d) * y;
end