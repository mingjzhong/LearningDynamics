function alphas = solve_for_alphas_with_regularization(A, b, R, h, lambda, method)
% function alphas = solve_for_alphas_with_regularization(A, b, R, h, lambda, method)

% (C) M. Zhong

switch method
  case {'L2', 'H1semi'}
    obj_func = @(alpha) 1/2 * alpha' * A * alpha - alpha' * b + lambda * sqrt(sum((R * alpha).^2) * h);
  case {'L1', 'TV'}
    obj_func = @(alpha) 1/2 * alpha' * A * alpha - alpha' * b + lambda * sum(abs(R * alpha) * h);    
  otherwise
    error('SOD_Learn:solve_for_alphas_with_regularization:exception', ...
      'Regularization method can be L2, L1, TV, or H1semi!!');
end
max_iters    = 50000;
max_funEva   = 50000;
tol          = 1.e-15;
options      = optimset('Display', 'off', 'MaxFunEvals', max_funEva, ...
               'MaxIter', max_iters, 'TolFun', tol, 'TolX', tol);
alpha0       = ones(size(A, 1), 1)/size(A, 1);
alphas       = fminsearch(obj_func, alpha0, options);
end