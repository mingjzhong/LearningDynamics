function [yn, nfevals] = get_yn_for_BD_method(tn, y_prevs, a_vec, beta, ode_fun, h, kind)
% function yn = get_yn_for_BD_method(tn, y_prevs, a_vec, beta, ode_fun, h, kind)

% (C) M. Zhong

% on the main diagonal
a_mat                 = spdiags(a_vec, 0, length(a_vec), length(a_vec));
% sum_{j = 1}^k a_j \vec{y}_{n - j}
y_tilde               = sum(y_prevs * a_mat, 2);
% BD: y_n + sum_{j = 1}^k a_j * \vec{y}_{n - j} = h * \beta * f(t_n, y_n)
F                     = @(y) y - beta * h * ode_fun(tn, y) + y_tilde;
tol                   = 1.e-12;
if tol > h^length(a_vec)
  tol                 = h^length(a_vec);
end
switch kind
  case 1
% use Explicit Euler as an initial guess
    yn_guess          = get_initial_guess_for_BD_method(y_prevs); 
    max_iters         = 1000;
    opts              = optimoptions('fsolve', 'Display', 'none', 'FunctionTolerance', tol, ...
                        'MaxFunctionEvaluations', max_iters * 5, 'MaxIterations', max_iters, ...
                        'OptimalityTolerance', 10 * tol, 'StepTolerance', tol, ...
                        'Algorithm', 'Trust-Region-Dogleg'); % this method uses Jacobian
    [yn, ~, ~, fs_op] = fsolve(F, yn_guess, opts);
    nfevals           = fs_op.funcCount;    
  case 2
    done              = false;
    yn_i              = get_initial_guess_for_BD_method(y_prevs);
    Fac               = [];
    thresh            = 10 * tol;
    nfevals           = 0;
    while ~done
      [Jac, Fac]      = numjac(ode_fun, tn, yn_i, ode_fun(tn, yn_i), thresh, Fac);
      delta_i         = (eye(length(yn_i)) - h * beta *Jac)\(-F(yn_i));
      yn_ip1          = yn_i + delta_i;
      if norm(yn_ip1 - yn_i) < tol, done = true; end
      yn_i            = yn_ip1;
      nfevals         = nfevals + 2;
    end
    yn                = yn_ip1;
  otherwise
    error('');
end
end