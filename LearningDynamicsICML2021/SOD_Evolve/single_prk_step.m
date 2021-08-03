function [y_n, nfevals] = single_prk_step(y_nm1, h, ode_fun, order)
% [y_n, nfevals] = single_prk_step(y_nm1, h, ode_fun, order)
% calculates the numerical approximation of y(t_{n}) when y, as a function of t (usually 
% representing time), sastisfies the ODE: d^2x/dt^2 = f(x), with y = [x, dx/dt], with f = ode_fun 
% comes from a Hamiltonian system

% the function uses an implicit partitioned Runge-Kutta method, specially designed for Hamiltonian
% system without friction, that is f depends only on x (the position, no velocity v)
% equation (2.22) on page 15/42 from the paper: GniCodes - Matlab Programs for Geometric Numerical
% Integration, E. Hairer, M. Hairer
% l_i = f(x_nm1 + hc_iv_nm1 + h^2 \sum_{j = 1}^s \tilde{a}_ij l_j), i = 1, \ldots, s
% x_n = x_nm1 + hv_nm1 + h^2 \sum_{i = 1}^s \tilde{b}l_i
% v_n = v_nm1 + h\sum_{i = 1}^s \hat{b}_il_i, where
% c_i = sum_{j = 1}^s a_ij, and \tilde{b}_i is from \tilde{b}^T = b^T\hat{A}, and \tilde{A} =
% A\hat{A}, and b = \hat{b} due to being symplectic

% (C) M. Zhong

if ~iscolumn(y_nm1), y_nm1 = y_nm1'; end
[A, c_vec, bb_vec, b_vec]  = generate_partitioned_Runge_Kutta_items(order);
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