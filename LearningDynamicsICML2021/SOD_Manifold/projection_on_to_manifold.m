function y_M = projection_on_to_manifold(y, sys_info)
% function y_M = projection_on_to_manifold(y, sys_info)
% finds the L_2 projection of y onto a manifold, i.e.,
% min |y - y_M|_2, for y_M on a manifold given by sys_info, where the manifold is given by the level
% set g(y_M) = 0

% (C) M. Zhong

% Using the Lagrange method, let L = 1/2 * |y - y_M|_2^2 - lambda * g(y_M) 
% \frac{\partial L}{\partial (y_M(i)} = 0 gives, y_M = y + lambda * \nabla g(y_M) and g(y_M) = 0
% so g(y + lambda * \nabla g(y)) = 0, replacing y_m with y in the inner g(\cdot),
% lambda_{i + 1} = lambda_i + \delta_lambda_i, where
% \delta_lambda_i = -(\nabla g(y)^T * \nabla g(y))^{-1} g(y + lambda * g(y)), starting from lambda_1
% = 0, with an error at around \mathcal{O}(h^{p + 1}), p is the order of the ODE method for y
% on page 24/55 of the lecture notes by 

y            = reshape(y, [sys_info.d, sys_info.N]);
lambda_k     = zeros(1, sys_info.N);
num_steps    = 1;            % three steps of Newton is good enough
for idx = 1 : num_steps
  y_new      = y + sys_info.level_set(y) * spdiags(lambda_k', 0, sys_info.N, sys_info.N);
  delta      = -sys_info.level_set(y_new)./sum(sys_info.level_grad(y_new).*sys_info.level_grad(y));
  lambda_kp1 = lambda_k + delta;
  lambda_k   = lambda_kp1;
end
y_M          = y + sys_info.level_grad(y) * spdiags(lambda_k', 0, sys_info.N, sys_info.N);
y_M          = y_M(:);
end