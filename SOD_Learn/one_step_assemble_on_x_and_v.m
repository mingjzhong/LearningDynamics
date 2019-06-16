function [energy_Psi, align_Psi, F_vec, d_vec,Timings] = one_step_assemble_on_x_and_v(x, v, xi, dot_xv, time_vec, ...
    agents_info, energy_basis, align_basis, sys_info, learn_info)

%
% function [energy_Phi, align_Phi, the_F, d_vec] = one_step_assemble_on_x_and_v(x, v, xi, dot_xv, time_vec, ...
%    num_agents_each_class, energy_basis, align_basis, sys_info, learn_info)

% (c) Ming Zhong, Mauro Maggioni, JHU

Timings.approximate_derivative_of_x_or_v = tic;
if ~isempty(dot_xv),d_vec   = dot_xv(:);                                                            % find out what the derivatives are (with or without de-noising strategy), and the derivative can be given
else,               d_vec   = approximate_derivative_of_x_or_v( x,v,time_vec,sys_info); % construct the right hand side from the observation data and time vector
end
Timings.approximate_derivative_of_x_or_v = toc(Timings.approximate_derivative_of_x_or_v);

Timings.partition_x_and_v   = tic;
[energy_pdist, energy_pdiff, energy_reg, ~, align_pdiff, align_reg, Psi_row_ind]   ...
    = partition_x_and_v( x,v,sys_info,learn_info );                         % compute pairwise distance, pairwise differences, regulator, maximum interaction radii, row indices in the learning matrix to put the assembled data
Timings.partition_x_and_v   = toc(Timings.partition_x_and_v);

Timings.assemble_the_learning_matrix_on_x_and_v = tic;
F_vec                       = find_x_or_v_external(x, v, xi, sys_info);                             % find out the information on the non-collecitve force F
[energy_Psi, align_Psi]     = assemble_the_learning_matrix_on_x_and_v( ...                          % build the Phi matrices
    energy_pdist, energy_pdiff, energy_reg, ...
    energy_basis, align_pdiff, align_reg, align_basis, time_vec, agents_info, ...
    Psi_row_ind, sys_info, learn_info);

[F_vec, d_vec, energy_Psi, align_Psi] = scale_the_quantities(F_vec, d_vec, energy_Psi, ...          % scale the vectors and
    align_Psi, sys_info.N, sys_info.K, sys_info.type_info, time_vec, learn_info.Riemann_sum);
Timings.assemble_the_learning_matrix_on_x_and_v = toc(Timings.assemble_the_learning_matrix_on_x_and_v);

return
