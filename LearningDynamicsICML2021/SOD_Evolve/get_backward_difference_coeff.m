function coeff_mat = get_backward_difference_coeff(order)
% function coeff_mat = get_backward_differene_coeff(order)

% (C) M. Zhong

% formula for backward differencing: \nabla^k y_n (k = order - 1)
switch order
  case 1
% \nabla^0 y_n = y_n
    coeff_vec = 1;
  case 2
% \nabla^1 y_n = y_n - y_{n - 1}    
    coeff_vec = [1, -1]';
  case 3
% \nabla^2 y_n = y_n - 2y_{n - 1} + y_{n - 2}
    coeff_vec = [1, -2, 1]';
  case 4
% \nabla^3 y_n = y_n - 3y_{n - 1} + 3y_{n - 2} - y_{n - 3}   
    coeff_vec = [1, -3, 3, -1]';
  case 5
% \nabla^4 y_n = y_n - 4y_{n - 1} + 6y_{n - 2} - 4y_{n - 3} + y_{n - 4}
    coeff_vec = [1, -4, 6, -4, 1]';
  case 6
% \nabla^5 y_n = y_n - 5y_{n - 1} + 10y_{n - 2} - 10y_{n - 3} + 5y_{n - 4} - y_{n - 5}
    coeff_vec = [1, -5, 10, -10, 5, -1]';
  otherwise
    error('');
end
coeff_mat     = spdiags(coeff_vec, 0, order, order);
end