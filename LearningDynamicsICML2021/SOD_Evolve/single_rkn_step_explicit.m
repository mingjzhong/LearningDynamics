function [y_n, nfevals] = single_rkn_step_explicit(y_nm1, h, ode_fun, order)
% [y_n, nfevals] = single_rkn_step_explicit(y_nm1, h, ode_fun, order)
% calculates the numerical approximation of y(t_{n}) when y, as a function of t (usually 
% representing time), sastisfies the ODE: d^2x/dt^2 = ode_fun(x), and y = [x, dx/dt], with ode_fun 
% comes from a Hamiltonian system
% The function uses explicit single step Runge Kutta Nystrom method of order from 2 to 4

% the formulas are taken from the paper: Explicit Canonical Methods for Hamiltonian Systems, D.
% Okunbor and R. D. Skeel, Mathematics of Computation, Vol. 59, No. 200, Oct. 1992, page 439 - 455.
% Using the formula from Theorem 2, on page 5/18, with d^2x/dt^2 = f(x), y = [x, v] where v =
% dx/dt, formula (11) reads
% x_i = x_nm1 + c_i * h * v_nm1 + h^2 * \sum_{j = 1}^{i - 1} B_j * (c_i - c_j) * f(x_j), i = 1 to s
% x_n = x_nm1 + h * v_nm1 + h^2 * \sum_{i = 1}^s B_i * (1 - c_i) * f(x_i)
% v_n = v_nm1 + h * sum_{i = 1}^s B_i * f(x_i)
% x_i's are the immediate stages of x_nm1 to x_n (nm1 = n - 1)
% how to find c_i, and B_i based on the order condition, details found in
% generate_Runge_Kutta_Nystrom_items.m

% (C) M. Zhong

if ~iscolumn(y_nm1), y_nm1 = y_nm1'; end
[b_vec, c_vec, num_stages] = generate_Runge_Kutta_Nystrom_items_explicit(order);
nfevals                    = num_stages;
length_of_x                = length(y_nm1)/2;
x_nm1                      = y_nm1(1 : length_of_x);
v_nm1                      = y_nm1(length_of_x + 1 : end);
x_stages                   = zeros(length(x_nm1), num_stages);
f_stages                   = zeros(length(x_nm1), num_stages);
x_stages(:, 1)             = x_nm1 + c_vec(1) * h * v_nm1;
f_stages(:, 1)             = ode_fun(x_stages(:, 1));
if ~iscolumn(b_vec), b_vec = b_vec'; end
if ~iscolumn(c_vec), c_vec = c_vec'; end
for idx = 2 : num_stages
  Dmat                     = spdiags(b_vec(1 : idx - 1) .* (c_vec(idx) - c_vec(1 : idx - 1)), ...
                             0, idx - 1, idx - 1);
  x_stages(:, idx)         = x_nm1 + c_vec(idx) * h * v_nm1 + h^2 * ...
                             sum(f_stages(:, 1 : idx - 1) * Dmat, 2);
end
Dmat                       = spdiags(b_vec .* (1 - c_vec), 0, num_stages, num_stages);
x_n                        = x_nm1 + h * v_nm1 + h^2 * sum(f_stages * Dmat, 2);
Dmat                       = spdiags(b_vec, 0, num_stages, num_stages);
v_n                        = v_nm1 + h * sum(f_stages * Dmat, 2);
y_n                        = [x_n; v_n];
end