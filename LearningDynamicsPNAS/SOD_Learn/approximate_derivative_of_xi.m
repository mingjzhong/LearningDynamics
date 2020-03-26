function d_vec = approximate_derivative_of_xi(xi, time_vec, sys_info)
% d_vecs = approximate_derivative(xi, time_vec, sys_info)
%
% (re-write)
% 
% (re-write)
%
% Input:
%   observation - a 3-dimensional tensor which contains the observation
%                 \{x_i(t_k)\}_{i = 1, \ldots, N; k = 1, \ldots, m}, each
%                 state vector x_i(t_k) is d-dimensional.
%   time_vec    -
%   options     -
% Output:
%   d_vec       - the right hand side in the Least Square problem:
%                 ||V * alphas - ds||^2.

% Ming Zhong
% Postdoc Research at JHU

% find out the number of time instances when observation are made
L                 = length(time_vec);
% it only works when we observe more than twice
if L == 1
  error('SOD_Learn:approximate_derivative_of_xi:invalidInput', 'Need L > 1!!');
end
% find out the number of agents in the system
N                 = sys_info.N;
% find out all the time steps
time_steps        = zeros(size(time_vec));
% t_k - t_{k - 1}
time_steps(2 : L) = time_vec(2 : L) - time_vec(1 : (L - 1));
% for the initial time, t_1 - t_2
time_steps(1)     = time_vec(1) - time_vec(2);
% transpose it to make it a column vector
time_steps        = transpose(time_steps);
% find out the number of rows in the pdiff_data
num_rows          = N;
% make it for every agent data 
time_steps_large  = kron(time_steps, ones(num_rows, 1));
% the difference between data
xi_diff           = zeros(size(xi));
% data_k - data_{k - 1}
xi_diff(:, 2 : L) = xi(:, 2 : L) - xi(:, 1 : (L - 1));
% for the data at initial time, data_1 - data_2
xi_diff(:, 1)     = xi(:, 1) - xi(:, 2);
% make it into a vector
xi_diff_vec       = reshape(xi_diff, [num_rows * L, 1]);
% the derivative: (data_k - data_{k - 1})/(t_k - t_{k -1}) except at the
% initial time: (data_1 - data_2)/(t_1 - t_2)
d_vec             = xi_diff_vec./time_steps_large;
return