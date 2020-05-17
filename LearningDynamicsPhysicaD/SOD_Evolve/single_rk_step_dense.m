function [y_nptheta, nfevals] = single_rk_step_dense(t_n, y_n, h, ode_fun, order, theta, degree)
% [y_nptheta, nfevals] = single_rk_step_dense(t_n, y_n, h, ode_fun, order, theta, degree)
% calculates the Natural Continuous Extension (NCE) of Runge-Kutta method up to order 4
% Formulas taken from the Paper by M. Zennano
% Input:
%   t_n     -
%   y_n     -
%   h       -
%   ode_fun -
%   order   -
% Output:
%   y_np1   -
%   nfevals -

% (C) M. Zhong

if ~iscolumn(y_n), y_n = y_n'; end
[A, b_vec, c_vec, stage]    = generate_Runge_Kutta_items(order, 'explicit');
nfevals                     = stage;
y_stage                     = zeros(length(y_n), stage);
y_stage(:, 1)               = ode_fun(t_n, y_n);
if stage == 1
  y_nptheta                 = y_n + h * theta * y_stage(:, 1);
else
  switch order
    case 2
      switch degree
        case 1
          btheta_vec        = b_vec * theta;
        case 2
          btheta_vec        = zeros(size(b_vec));
          btheta_vec(1)     = (b_vec(1) - 1) * theta^2 + theta;
          btheta_vec(2)     = b_vec(2) * theta^2;
        otherwise
      end
    case 3
      lambda                = 6 * c_vec(2) * (2 * c_vec(2) - 1)/b_vec(2);
      w_vec                 = [-lambda * ((c_vec(3) - c_vec(2)) + c_vec(2))/(2 * c_vec(2) * c_vec(3)); ...
                            lambda/(2 * c_vec(2)); (1 - lambda)/(2 * c_vec(3))];
      btheta_vec            = zeros(size(b_vec));
      for ind = 1 : length(b_vec)
        btheta_vec(ind)     = w_vec(ind) * theta^2 + (b_vec(ind) - w_vec(ind)) * theta;
      end
    case 4
      btheta_vec            = zeros(size(b_vec));
      switch degree
        case 2
          for ind = 1 : length(b_vec)
            btheta_vec(ind) = 3 * (2 * c_vec(ind) - 1) * b_vec(ind) * theta^2 + 2 * (2 - 3 * c_vec(ind)) * b_vec(ind) * theta;
          end
        case 3
          btheta_vec(1)     = 2 * (1 - 4 * b_vec(1)) * theta^3 + 3 * (3 * b_vec(1) - 1) * theta^2 + theta;
          for ind = 2 : length(b_vec)
            btheta_vec(ind) = 4 * (3 * c_vec(ind) - 2) * b_vec(ind) * theta^3 + 3 * (3 - 4 * c_vec(ind)) * b_vec(ind) * theta^2;
          end
        otherwise
      end
    otherwise
  end
  for s_idx = 2 : stage
    A_diag                  = spdiags(A(s_idx, 1 : s_idx - 1)', 0, s_idx - 1, s_idx - 1);
    y_stage(:, s_idx)       = ode_fun(t_n + h * c_vec(s_idx), y_n + h * sum(y_stage(:, 1 : s_idx - 1) * A_diag, 2)); 
  end
  if ~iscolumn(btheta_vec), btheta_vec = btheta_vec'; end
  b_diag                    = spdiags(btheta_vec, 0, stage, stage);
  y_nptheta                 = y_n + h * sum(y_stage * b_diag, 2);  
end
end