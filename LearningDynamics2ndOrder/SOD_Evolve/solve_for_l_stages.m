function [l_stages, nfevals] = solve_for_l_stages(c_vec, A, x_nm1, v_nm1, h, ode_fun)
% function [l_stages, nfevals] = solve_for_l_stages(c_vec, A, x_nm1, v_nm1, h, ode_fun)

% (C) M. Zhong

num_stages       = length(c_vec);
x_len            = length(x_nm1);
c_vec            = kron(c_vec, ones(x_len, 1));
Cmat             = spdiags(c_vec, 0, num_stages * x_len, num_stages * x_len);
A                = kron(A, eye(x_len));
L0               = repmat(x_nm1, [num_stages, 1]) + Cmat * h * repmat(v_nm1, [num_stages, 1]);
L_vec            = L0;
F                = @(L) get_the_ls_for_iprk_and_irkn(L, L_vec, A, h, ode_fun, x_len, num_stages);
max_iters        = 5000;
tol              = 1.e-13;
opts             = optimoptions('fsolve', 'Display', 'none', 'FunctionTolerance', tol, ...
                   'MaxFunctionEvaluations', max_iters * 5, 'MaxIterations', max_iters, ...
                   'OptimalityTolerance', 10 * tol, 'StepTolerance', tol, ...
                   'Algorithm', 'Levenberg-Marquardt'); % for non-sparse system
                 % 'Trust-Region-Dogleg', this method uses Jacobian
[L, ~, ~, fs_op] = fsolve(F, L0, opts);
nfevals          = num_stages * (fs_op.funcCount + 1);
l_stages         = reshape(L, [x_len, num_stages]);
end