function [A, c_vec, bb_vec, b_vec]  = generate_Runge_Kutta_Nystrom_items_implicit(order)
% function [A, c_vec, bb_vec, b_vec]  = generate_Runge_Kutta_Nystrom_items_implicit(order)

% (C) M. Zhong

switch order
  case 1
  case 2
  case 3
  case 4
    a      = 1;
    A      = [a, (2 + sqrt(3))/12 - a; (2 - sqrt(3))/12 - a, a];
    c_vec  = [(3 + sqrt(3))/6; (3 - sqrt(3))/6];
    bb_vec = [(3 - sqrt(3))/12; (3 + sqrt(3))/12];
    b_vec  = [1/2; 1/2];    
  otherwise
end
end