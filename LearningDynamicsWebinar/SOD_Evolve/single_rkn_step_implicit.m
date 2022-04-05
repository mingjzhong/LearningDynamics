function [y_n, nfevals] = single_rkn_step_implicit(y_nm1, h, ode_fun, order)
% [y_n, nfevals] = single_rkn_step_implicit(y_nm1, h, ode_fun, order)
% calculates the numerical approximation of y(t_{n}) when y, as a function of t (usually 
% representing time), sastisfies the ODE: d^2x/dt^2 = f(x), and y = [x, dx/dt], with f = ode_fun 
% comes from a Hamiltonian system

% The function uses implicit 2-stage Runge Kutta Nystrom method of order 4 (two types)
% l_1 = f(x_nm1 + c_1 * h * v_nm1 + h^2 * (a_11 * l_1 + a_12 * l_2))
% l_2 = f(x_nm1 + c_2 * h * v_nm1 + h^2 * (a_21 * l_1 + a_22 * l_2))
% the above system has to be solved first, then
% x_n = x_nm1 + h * v_nm1 + h^2 * (bb_1 * l_1 + bb_2 * l_2)
% v_n = v_nm1 + h * (b_1 * l_1 + b_2 * l_2)

% (C) M. Zhong

if ~iscolumn(y_nm1), y_nm1 = y_nm1'; end
[A, c_vec, bb_vec, b_vec]  = generate_Runge_Kutta_Nystrom_items_implicit(order);
num_stages                 = length(c_vec);
nfevals                    = num_stages;
x_len                      = length(y_nm1)/2;
x_nm1                      = y_nm1(1 : x_len);
v_nm1                      = y_nm1(x_len + 1 : end);
if ~iscolumn(c_vec), c_vec   = c_vec';  end
if ~iscolumn(bb_vec), bb_vec = bb_vec'; end
if ~iscolumn(b_vec), b_vec   = b_vec';  end
l_stages                   = solve_for_l_stages(c_vec, A, x_nm1, v_nm1, h, ode_fun);
Dmat                       = spdiags(bb_vec, 0, num_stages, num_stages);
x_n                        = x_nm1 + h * v_nm1 + h^2 * sum(l_stages * Dmat, 2);
Dmat                       = spdiags(b_vec, 0, num_stages, num_stages);
v_n                        = v_nm1 + h * sum(l_stages * Dmat, 2);
y_n                        = [x_n; v_n];
end