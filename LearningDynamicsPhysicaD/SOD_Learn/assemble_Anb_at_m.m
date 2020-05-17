function [PsiE, PsiA, PsiXi, F_vec, d_vec, Fxi_vec, dxi_vec, Timings] = assemble_Anb_at_m(x, v, xi, ...
         dot_xv, dot_xi, time_vec, agents_info, sys_info, basis, file_name)
% function [PsiE, PsiA, PsiXi, Fv_vec, d_vec, Fxi_vec, dxi_vec, Timings] = assemble_Anb_at_m(x, ...
% v, xi, dot_xv, dot_xi, time_vec, agents_info, sys_info, basis, file_name)

% (c) M. Zhong (JHU)

% assemble the derivative vectors and external vectors containing non-collective forces
Timings.assemble_rhs                 = tic;
d_vec                                = dot_xv(:);
if ~isempty(dot_xi), dxi_vec = dot_xi(:); else, dxi_vec = []; end
[F_vec, Fxi_vec]                     = get_the_externals(x, v, xi, sys_info); 
Timings.assemble_rhs                 = toc(Timings.assemble_rhs);
% assemble the learning matrices, and scale them accordingly, namely by 1/N_k(i), where i is the agent index
Timings.assemble_the_learning_matrix = tic;
load(file_name, 'psi_pdist', 'psi_pdiff', 'phi_rest', 'Psi_row_ind');
[PsiE, PsiA, PsiXi]                  = assemble_the_learning_matrix_all_kinds(psi_pdist, psi_pdiff, ...
  phi_rest, basis, length(time_vec), Psi_row_ind, agents_info, sys_info);
[PsiE, PsiA, PsiXi, F_vec, d_vec, Fxi_vec, dxi_vec] ...
                                     = scale_the_quantities(PsiE, PsiA, PsiXi, F_vec, d_vec, Fxi_vec, ...
  dxi_vec, sys_info);  
Timings.assemble_the_learning_matrix = toc(Timings.assemble_the_learning_matrix);
end