function d_vec = de_noise_diff(pdiff_data, time_vec, sys_info, learning_info)
%
%
%

% Ming Zhong
% Postdoc Researt at JHU

 % find out the number of time instances when observation are made
mp1                     = learning_info.num_observes;
% find out the number of agents in the system
N                       = sys_info.N;
% find out the size of the state vector for each agent
d                       = sys_info.d;
% find out the order of the ODE system
ode_order               = sys_info.ode_order;
% find out if we are solving for xi
solve_for_xi            = sys_info.solve_for_xi;
% check the size of pdiff_data
if ode_order == 1
% pdiff_data is x
  validateattributes(pdiff_data, {'numeric'}, {'size', [d * N, mp1]}, ...
    'approximate_derivative', 'pdiff_data', 1);
elseif ode_order == 2
  if ~solve_for_xi
% pdiff_data is v
    validateattributes(pdiff_data, {'numeric'}, {'size', [d * N, mp1]}, ...
      'approximate_derivative', 'pdiff_data', 1);  
  else
% pdiff_data is xi
    validateattributes(pdiff_data, {'numeric'}, {'size', [N, mp1]}, ...
      'approximate_derivative', 'pdiff_data', 1);
  end
end
% find out the number of rows in pdiff_data
num_rows                = size(pdiff_data, 1);
% allocate the storage for d_vec
d_vec                   = zeros(size(pdiff_data));
%
how_to_diff             = learning_info.how_to_diff;
% go through each row in pdiff_data
parfor row_ind = 1 : num_rows
% find out the data for regularized differentiation, and transpose it to a
% column vector
  data                  = transpose(pdiff_data(row_ind, :));
% set up the parameters for differentiation
  max_diff_iters        = 500;
  epsilon               = 1.0e-6;
  lambda                = 1.0e-5;
  data_deriv            = reg_diff(data, time_vec, lambda, ...
    max_diff_iters, epsilon, how_to_diff);
% put it back to d_vec
  d_vec(row_ind, :)     = transpose(data_deriv);
end
% change d_vec to a vector
d_vec                   = reshape(d_vec, [num_rows * mp1, 1]);