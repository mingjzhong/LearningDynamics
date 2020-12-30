function [y_out, f_of_y_out] = fixed_runge_kutta(odefun, ...
  time_vec, y_0, order)
%
%
%
%

% Ming Zhong
% Postdoc Research at Johns Hopkins

%
y_length                  = length(y_0);
%
num_steps                 = length(time_vec);
%
y_out                     = zeros(y_length, num_steps);
%
f_of_y_out                = zeros(size(y_out));
%
y_out(:, 1)               = y_0;
% simplify the Runge Kutta numerical integrator, which evolve the ODE
% system from (t, y) to (t + h, \hat{y})
rk_integrate              = @(t, x, delta_t) ...
single_rk_step(odefun, t, x, delta_t, order);
%    
y_prev                    = y_0;
%
for step = 1 : num_steps - 1
%
  delta_t                  = time_vec(step + 1) - time_vec(step);
%
  [y_current, f_of_y_prev] = rk_integrate(time_vec(step), y_prev, delta_t);
%
  y_out(:, step + 1)       = y_current;
%
  f_of_y_out(:, step)      = f_of_y_prev;
%
  y_prev                   = y_current;
end
%
f_of_y_prev                = odefun(time_vec(num_steps), y_current);
%
f_of_y_out(:, num_steps)   = f_of_y_prev;