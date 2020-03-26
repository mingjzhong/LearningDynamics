function [Psi, F_vec, d_vec, Timings] = one_step_assemble_on_xi(x, xi, dot_xi, time_vec, agents_info, xi_basis, sys_info, learn_info)
% function [Psi, F_vec, d_vec, Timings] = one_step_assemble_on_xi(x, xi, dot_xi, time_vec, agents_info, xi_basis, sys_info, learn_info)

% (c) M. Zhong (JHU)

% construct the right hand side from the observation data and time vector
Timings.approximate_derivative_of_xi                = tic;
if ~isempty(dot_xi)
  d_vec                                             = dot_xi(:);
else
  d_vec                                             = approximate_derivative_of_xi(xi, time_vec, sys_info);
end
Timings.approximate_derivative_of_xi                = toc(Timings.approximate_derivative_of_xi);

Timings.partition_xi                                = tic;
[energy_pdist, xi_pdiff, xi_regulator, Psi_row_ind] = partition_xi(x, xi, sys_info);
Timings.partition_xi                                = toc(Timings.partition_xi);
% find out the learning matrix
Timings.assemble_the_learning_matrix_on_xi          = tic;
Psi                                                 = assemble_the_learning_matrix_on_xi(energy_pdist, ...
xi_pdiff, xi_regulator, xi_basis, time_vec, agents_info, Psi_row_ind, sys_info, learn_info);
% find out the F_vec on the external information
F_vec                                               = find_xi_external(x, xi, sys_info);
% scale the non-collective influence terms, derivative terms, and the learning matrix 
[F_vec, d_vec, Psi]                                 = scale_the_quantities(F_vec, d_vec, Psi,  [], ...
sys_info.N, sys_info.K, sys_info.type_info, time_vec, learn_info.Riemann_sum);
Timings.assemble_the_learning_matrix_on_xi          = toc(Timings.assemble_the_learning_matrix_on_xi);
end