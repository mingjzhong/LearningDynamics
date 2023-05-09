function [y_n, nfevals] = single_lf_step(y_nm1, h, ode_fun, order)
% [y_n, nfevals] = single_lf_step(y_nm1, h, ode_fun, order)
% evolves the ODE system of the particular type: \ddot{x} = \frac{d^2}{dt^2} = A(x) (position only)
% a separable Hamiltonian system.
% Details see: https://en.wikipedia.org/wiki/Leapfrog_integration

% (C) M. Zhong

if ~iscolumn(y_nm1), y_nm1 = y_nm1'; end
length_of_x = length(y_nm1)/2;
x_nm1       = y_nm1(1 : length_of_x);
v_nm1       = y_nm1(length_of_x + 1 : end);
switch order 
  case 2
% 2nd order is the default Leapfrog    
    nfevals = 1;
    a_nm1   = ode_fun(x_nm1);
    x_n     = x_nm1 + v_nm1 * h +  1/2 * a_nm1* h^2;
    a_n     = ode_fun(x_n);
    v_n     = v_nm1 + 1/2 * (a_nm1 + a_n) * h;
  case 4
% 4th order Leapfrog using techniques due to Haruo Yoshida
    nfevals = 3;
    omega0  = -2^(1/3)/(2 - 2^(1/3));
    omega1  = 1/(2 - 2^(1/3));
    c1      = omega1/2;
    c2      = (omega0 + omega1)/2;
    c3      = (omega0 + omega1)/2;
    c4      = omega1/2;
    d1      = omega1;
    d2      = omega0;
    d3      = omega1;
    x1_nm1  = x_nm1  + c1 * v_nm1 * h;
    v1_nm1  = v_nm1  + d1 * ode_fun(x1_nm1) * h;
    x2_nm1  = x1_nm1 + c2 * v1_nm1 * h;
    v2_nm1  = v1_nm1 + d2 * ode_fun(x2_nm1) * h;
    x3_nm1  = x2_nm1 + c3 * v2_nm1 * h;
    v3_nm1  = v2_nm1 + d3 * ode_fun(x3_nm1) * h;
    x_n     = x3_nm1 + c4 * v3_nm1 * h;
    v_n     = v3_nm1;
  otherwise
end
y_n         = [x_n; v_n];
end