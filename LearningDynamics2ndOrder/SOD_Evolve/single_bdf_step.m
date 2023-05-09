function [y_n, nfevals] = single_bdf_step(t_prevs, y_prevs, h, ode_fun, order)
% [y_n, nfevals] = single_bdf_step(t_ns, y_ns, h, ode_fun, order)
% calculates the numerical approximation of y(t_{n}) when y, as a function of t (usually 
% representing time), sastisfies the ODE: dy/dt = ode_fun(t, y).
% The function uses implicit multi- step Backward Differentiation formula of order up to 6.
% For details, see: https://en.wikipedia.org/wiki/Backward_differentiation_formula

% (C) M. Zhong

[a_vec, beta]      = generate_BDF_items(order);
if ~iscolumn(a_vec), a_vec = a_vec'; end
tn                 = t_prevs(end) + h;
[y_n, nfevals]     = get_yn_for_BD_method(tn, y_prevs, a_vec, beta, ode_fun, h, 1);
end