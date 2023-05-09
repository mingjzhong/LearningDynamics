function [y_n, nfevals] = single_rk_step(t_n, y_nm1, h, ode_fun, order)
% [y_n, nfevals] = single_rk_step(t_n, y_nm1, h, ode_fun, order)
% calculates the numerical approximation of y(t_{n}) when y, as a function of t (usually 
% representing time), sastisfies the ODE: dy/dt = ode_fun(t, y).
% The function uses explicit single step Runge Kutta method of order up to 4.
% Input:
%   t_n     -
%   y_nm1   -
%   h       -
%   ode_fun -
%   order   -
% Output:
%   y_n     -
%   nfevals -

% (C) M. Zhong

if ~iscolumn(y_nm1), y_nm1 = y_nm1'; end
[A, b_vec, c_vec, stage] = generate_Runge_Kutta_items(order, 'explicit');
nfevals                  = stage;
y_stage                  = zeros(length(y_nm1), stage);
y_stage(:, 1)            = ode_fun(t_n, y_nm1);
if stage == 1
  y_n                    = y_nm1 + h * y_stage(:, 1);
else
  for s_idx = 2 : stage
    A_diag               = spdiags(A(s_idx, 1 : s_idx - 1)', 0, s_idx - 1, s_idx - 1);
    y_stage(:, s_idx)    = ode_fun(t_n + h * c_vec(s_idx), ...
                           y_nm1 + h * sum(y_stage(:, 1 : s_idx - 1) * A_diag, 2)); 
  end
  if ~iscolumn(b_vec), b_vec = b_vec'; end
  b_diag                 = spdiags(b_vec, 0, stage, stage);
  y_n                    = y_nm1 + h * sum(y_stage * b_diag, 2);  
end
end