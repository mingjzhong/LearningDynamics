function [Psi, dvec, PsiXi, dvecXi] = assemble_A_and_b_at_m(m, L, basis, agent_info, learn_info)
% function [Psi, dvec, PsiXi, dvecXi] = assemble_A_and_b_at_m(m, L, basis, agent_info, learn_info)

% (c) M. Zhong 

file_name    = sprintf(learn_info.pd_file_form, learn_info.temp_dir, learn_info.sys_info.name, ...
               learn_info.time_stamp, m);
if ~learn_info.is_parallel
  load(file_name, 'dvec', 'dvecXi');
else
  dvec       = [];
  dvecXi     = [];
end
% assemble the learning matrices
load(file_name, 'psi_pdist', 'psi_pdiff', 'phi_rest');
[Psi, PsiXi] = assemble_the_learning_matrix_all_kinds(psi_pdist, psi_pdiff, phi_rest, basis, ...
               L, agent_info, learn_info.sys_info); 
if learn_info.is_parallel
  save(file_name, '-append', 'Psi', 'PsiXi');
end
end