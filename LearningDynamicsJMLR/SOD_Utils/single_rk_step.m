function [x_kp1, f_k] = single_rk_step(rhs, t_k, x_k, h, order)
% [x_kp1, f_k] = runge_kutta(rhs, t_k, x_k, h, order, options)
% calculates the numerical approximation of x(t_{k + 1}) when x, as a
% function of t (usually representing time), sastisfies the ODE:
% dx/dt = rhs(t, x).
% The function uses explicit single step Runge Kutta method of order up to
% 4.
% Input:
%   rhs   - The right hande side function of the ODE, it should return a
%           value of the same size of xk and takes tk and xk as its input
%   t_k   - time at the k-th step
%   x_k   - x at the k-th step
%   h     - the time step size
%   order - the order which the Runge Kutta takes, has to be an integer
% Output:
%   x_kp1 - x at next (k + 1)-th step
%   f_k   - rhs(tk, xk)

% Ming Zhong
% Postdoc Research

% 
if ~iscolumn(x_k)
  error('');
end
% evaluate the right hand side function at (tk, xk), since it will be used
% for every single order
f_k             = rhs(t_k, x_k);
% 
if ~isequal(size(f_k), size(x_k))
  error('basic_functions:runge_kutta:invalidParameter', ['The right' ...
    ' hand side function rhs should return something of the' ...
    ' same size as x_k']);
end
% for a s-stage (of order p) explicit Runge-Kutta method, it is of the form
% x_{k + 1} = x_k + h * \sum_{i = 1}^s b_i * k_i, where h is the time step
% size, and k_i's are given as follows:
% k_1 = f(t_k, x_k)
% k_2 = f(t_k + c_2 * h, x_k + h * a_{2, 1} * k_1)
% \vdots
% k_s = f(t_k + c_s * h, x_k + h * \sum_{i = 1}^{s - 1} a_{s, i} * k_i);
% where the c_i's, a_{i, j}'s and b_i's are given in the Butchner Tableau:
% c_1    | a_11   a_12   \ldots a_1s
% c_2    | a_21   a_22   \ldots a_2s
% \vdots | \vdots \vdots \ddots \vdots
% c_s    | a_s1   a_s2   \ldots a_ss
% ------------------------------------
%        | b_1    b_2    \ldots b_s
% for Explicit method, c_1 = 0, and a_{1, j} = 0 for all j, and a{i, j} = 0
% for j > i
% the table to have the minimal s stages for a certain p-order explicit
% Runge-Kutta method is given as follows:
% -------------------------------------------
% | p      | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8  |
% -------------------------------------------
% | min(s) | 1 | 2 | 3 | 4 | 6 | 7 | 9 | 11 |
% -------------------------------------------
if order == 1
% the Butchner Tableau
% 0 | 0
% ------
%   | 1
% basically the Euler's method
  x_kp1         = x_k + h * f_k;
elseif order == 2
% the Butchner Tableau
% 0 | 0             0
% d | d             0
% ---------------------------
%   | 1 - 1/(2 * d) 1/(2 * d)
% d = 1/2 (midpoint), d = 1 (Heun's), d = 2/3 (Ralston)
% we pick the Ralson
  d             = 2/3;
% two stages
  s             = 2;
% prepare the c vector
  c_vec         = zeros(s, 1);
  c_vec(2)      = d;
% prepare the a matrix
  a_mat         = zeros(s);
  a_mat(2, 1)   = d;
% now the b vector
  b_vec         = [1 - 1/(2 * d), 1/(2 * d)];
% prepare the intermediate steps
  K             = zeros(length(x_k), s);
  K(:, 1)       = f_k;
  K(:, 2)       = rhs(t_k + c_vec(2) * h, x_k + K(:, 1) * a_mat(2, 1) * h);
  x_kp1         = x_k + h * K * transpose(b_vec);
elseif order == 3
% the Butchner Tableau
% 0   | 0   0   0
% 1/2 | 1/2 0   0
% 1   | -1  2   0
% ------------------
%     | 1/6 2/3 1/6
% two stages
  s             = 3;
% prepare the c vector
  c_vec         = [0; 1/2; 1];
% prepare the a matrix
  a_mat         = [  0, 0, 0;
                   1/2, 0, 0;
                    -1, 2, 0];
% now the b vector
  b_vec         = [1/6, 2/3, 1/6];
% prepare the intermediate steps
  K             = zeros(length(x_k), s);
  K(:, 1)       = f_k;
  for s_ind = 2 : s
    K(:, s_ind) = rhs(t_k + c_vec(s_ind) * h, x_k + h * ...
      K(:, 1 : s_ind - 1) * transpose(a_mat(s_ind, 1 : s_ind - 1)));
  end
  x_kp1         = x_k + h * K * transpose(b_vec);
elseif order == 4
% the Butchner Tableau for another 4th order Runge-Kutta, commonly known as
% the 3/8 rule
% 0   |  0    0   0   0
% 1/3 |  1/3  0   0   0
% 2/3 | -1/3  1   0   0
% 1   |  1   -1   1   0
% ------------------------
%     |  1/8  3/8 3/8 1/8
% two stages
  s             = 4;
% prepare the c vector
  c_vec         = [0; 1/3; 2/3; 1];
% prepare the a matrix
  a_mat         = [   0,  0, 0, 0;
                    1/3,  0, 0, 0;
                   -1/3,  1, 0, 0;
                      1, -1, 1, 0];
% now the b vector
  b_vec         = [1/8, 3/8, 3/8, 1/8];
% prepare the intermediate steps
  K             = zeros(length(x_k), s);
  K(:, 1)       = f_k;
  for s_ind = 2 : s
    K(:, s_ind) = rhs(t_k + c_vec(s_ind) * h, x_k + h * ...
      K(:, 1 : s_ind - 1) * transpose(a_mat(s_ind, 1 : s_ind - 1)));
  end
  x_kp1         = x_k + h * K * transpose(b_vec);
end