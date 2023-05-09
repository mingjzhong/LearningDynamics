function [A, b_vec, c_vec, stage] = generate_Runge_Kutta_items(order, type)
% function [A, b_vec, c_vec, stage] = generate_Runge_Kutta_items(order, type)

% (C) M. Zhong

% find out the coefficients depending on type
switch type
  case 'explicit'
% c_i's, a_{i, j}'s and b_i's are given in the Butchner Tableau:
% c_1    | a_11   a_12   \ldots a_1s
% c_2    | a_21   a_22   \ldots a_2s
% \vdots | \vdots \vdots \ddots \vdots
% c_s    | a_s1   a_s2   \ldots a_ss
% ------------------------------------
%        | b_1    b_2    \ldots b_s
% for Explicit method, c_1 = 0, and a_{1, j} = 0 for all j, and a{i, j} = 0 for j >= i.  The table to 
% have the minimal s stages for a certain p-order explicit Runge-Kutta method is given as follows:
% -------------------------------------------
% | p      | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8  |
% -------------------------------------------
% | min(s) | 1 | 2 | 3 | 4 | 6 | 7 | 9 | 11 |
% -------------------------------------------    
    switch order
      case 1
% Euler method        
        A           = 0; 
        b_vec       = 1; 
        c_vec       = sum(A, 2);
        stage       = 1; 
      case 2
% the Butchner Tableau
% 0 | 0             0
% d | d             0
% ---------------------------
%   | 1 - 1/(2 * d) 1/(2 * d)
% d = 1/2 (midpoint), d = 1 (Heun's), d = 2/3 (Ralston), use Ralson
        d           = 2/3;
        stage       = 2;
        A           = zeros(stage);
        A(2, 1)     = d;
        b_vec       = [1 - 1/(2 * d); 1/(2 * d)];
        c_vec       = sum(A, 2);
      case 3
% the Butchner Tableau
% 0   | 0   0   0
% 1/2 | 1/2 0   0
% 1   | -1  2   0
% ------------------
%     | 1/6 2/3 1/6
        stage       = 3;
        A           = zeros(stage);
        A(2, 1)     = 1/2;
        A(3, 1 : 2) = [-1, 2];
        b_vec       = [1/6; 2/3; 1/6];
        c_vec       = sum(A, 2);
      case 4
% the Butchner Tableau for another 4th order Runge-Kutta, commonly known as
% the 3/8 rule
% 0   |  0    0   0   0
% 1/3 |  1/3  0   0   0
% 2/3 | -1/3  1   0   0
% 1   |  1   -1   1   0
% ------------------------
%     |  1/8  3/8 3/8 1/8
        stage       = 4;
        A           = zeros(stage);
        A(2, 1)     = 1/3;
        A(3, 1 : 2) = [-1/3, 1];
        A(4, 1 : 3) = [1, -2, 1];
        b_vec       = [1/8; 3/8; 3/8; 1/8];
        c_vec       = sum(A, 2);
      otherwise
        error(''); 
    end
  case 'implicit'
  otherwise
end
end