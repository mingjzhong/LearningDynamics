function [b_vec, c_vec, num_stages] = generate_Runge_Kutta_Nystrom_items_explicit(order)
% function [b_vec, c_vec, num_stages] = generate_Runge_Kutta_Nystrom_items_explicit(order)

% (C) M. Zhong

% the formulas are taken from the paper: Explicit Canonical Methods for Hamiltonian Systems, D.
% Okunbor and R. D. Skeel, Mathematics of Computation, Vol. 59, No. 200, Oct. 1992, page 439 - 455.

% we can put a Hamiltonian system into a 2nd order:
% d^2x/dt^2 = f(x), y = [x; v], with v = dx/dt.

% A s-stage Runge-Kutta-Nystrom method is given by
% x_i = x_nm1 + c_i * h * v_nm1 + h^2 * \sum_{j = 1}^s a_ij * f(x_j), i = 1 to s
% x_n = x_nm1 + h * v_nm1 + h^2 * \sum_{i = 1}^s b_i * f(x_i)
% v_n = v_nm1 + h * \sum_{i = 1}^s B_i * f(x_i)
% y_n = [x_n; v_n], x_i's are the intermediate stages, and nm1 = n - 1.
% The parameters are put into the following tableau:
% c_1    | a_11   a_12   \ldots a_1s
% c_2    | a_21   a_22   \ldots a_2s
% \vdots | \vdots \vdots \ddots \vdots
% c_s    | a_s1   a_s2   \ldots a_ss
% ------------------------------------
%        | b_1    b_2    \ldots b_s
%        | B_1    B_2    \ldots B_s
% with c_i = sum_{j = 1}^s a_ij.
% for it to be symplectic, we have to have:
% 1) b_i - B_i + c_i * B_i = 0,                            1 <= i <= s
% 2) -B_j * a_ji + B_i * a_ij + B_j * b_i - B_i * b_j = 0, 1 <= i <= s
% to simplify, we requrie: 
% for Explicit method, a{i, j} = 0 for 1 <= i <= j <= s, then we have b_i = B_i * (1 - c_i).

% there is a first order method, but we will not include here
switch order
  case 2
% according to ''3.1 one stage methods'', on page 8/18
    b_vec      = 1;
    c_vec      = 1/2;
    num_stages = 1;
  case 3
% a 2-stage, third order method is difficult to work with   
% on the bottom half of page 9/18, there is a 3-stage, third order method
    alpha      = 1/2;
    beta       = -1/12 * 1/alpha;
    c_vec      = [1/2 + alpha; 1/2 + beta; 1/2 + alpha];
    b_vec      = [beta/(2 * (beta - alpha)) - 1/(12 * alpha); -alpha/(beta - alpha); ...
                  beta/(2 * (beta - alpha)) + 1/(12 * alpha)];
    num_stages = 3; 
  case 4
% on the first half of page 10/18, 3-stage, fourth order
    gamma      = 1/12 * (2 - 4^(1/3) - 16^(1/3)); % the only zero of p(x) = 48x^3 - 24x^2 + 1
    c_vec      = [1/2 - gamma; 1/2; 1/2 + gamma];
    b_vec      = [1/(24 * gamma^2); 1 - 1/(12 * gamma^2); 1/(24 * gamma^2)];
    num_stages = 3;
  otherwise
    error('');
end
end