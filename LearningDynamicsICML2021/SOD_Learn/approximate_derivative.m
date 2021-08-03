function dtraj = approximate_derivative(traj, time_vec, kind)
% function dtraj = approximate_derivative(traj, time_vec, kind)

% (c) M. Zhong

% find out the number of time instances when observation are made
L                            = length(time_vec);
% it only works when we observe more than twice
if L == 1, error('SOD_Learn:approximate_derivative:exception', 'Need L > 1!!'); end
delta_ts                     = time_vec(2 : end) - time_vec(1 : end - 1);
if abs(min(delta_ts) - max(delta_ts)) > 1e-8, error('SOD_Learn:approximate_derivative:exception', 'Equidistant time points needed!!'); end
% initialize
dtraj                        = zeros(size(traj));
h                            = delta_ts(1);
% do it for first/second order derivative
switch kind
  case 1
    if L == 2
      dtraj(:, 1, :)         = (traj(:, 2, :) - traj(:, 1, :))/h;
      dtraj(:, 2, :)         = dtraj(:, 1, :);
    else
      dtraj(:, 1, :)         = (3 * traj(:, 1, :) - 4 * traj(:, 2, :) + traj(:, 3, :))/(-2 * h);
      dtraj(:, 2 : L - 1, :) = (traj(:, 3 : L, :) - traj(:, 1 : L - 2, :))/(2 * h);
      dtraj(:, L, :)         = (3 * traj(:, L, :) - 4 * traj(:, L - 1, :) + traj(:, L - 2, :))/(2 * h);     
    end
  case 2
    if L == 2
      error('SOD_Learn:approximate_derivative:exception', 'Second Order Derivative needs L > 2!!');
    else
      dtraj(:, 1, :)         = (traj(:, 3, :) - 2 * traj(:, 2, :) + traj(:, 1, :))/h^2;
      dtraj(:, 2 : L - 1, :) = (traj(: , 3 : L, :) - 2 * traj(:, 2 : L - 1, :) + traj(:, 1 : L - 2, :))/h^2;
      dtraj(:, L, :)         = (traj(:, L, :) - 2 * traj(:, L - 1, :) + traj(:, L - 2, :))/h^2;
    end    
  otherwise
    error('SOD_Learn:approximate_derivative:exception', 'It only finds first/second derivative!!'); 
end
end
