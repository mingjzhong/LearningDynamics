function [Estimator, Timings] = assemble_Anb_serial_adaptive(x, v, xi, dot_xv, dot_xi, time_vec, sys_info, learn_info)
% function [Estimator, Timings] = assemble_Anb_serial_adaptive(x, v, xi, dot_xv, dot_xi, time_vec, sys_info, learn_info)
% OUT:
%   Estimator:  structure with fields:
%     Ebasis, Timings

% (c) M. Zhong (JHU)

Timings.assemble_total                                  = tic;
% initialize storage                                     
M = size(x, 3); L = length(time_vec); agent_info = getAgentInfo(sys_info);
if ispc, learn_info.temp_dir = [learn_info.SAVE_DIR, '\tempOut']; 
else, learn_info.temp_dir = [learn_info.SAVE_DIR, '/tempOut']; end
if ~exist(learn_info.temp_dir, 'dir'), mkdir(learn_info.temp_dir); end
% maximum interaction radii
% find the maximum interaction radii Rs
Timings.findRange                                       = tic;
[phi_range, rho_range]                                  = partition_the_data(x, v, xi, agent_info, ...
                                                          sys_info, learn_info);
Timings.findRange                                       = toc(Timings.findRange);
if learn_info.VERBOSE > 1, fprintf('\n\tAssembling Rs takes %10.4e sec.', Timings.findRange);   end
Timings.constructBasis                                  = tic;
% prepare the bins for hist count
[hist_binwidths, hist_edges]                            = prepare_hist_items(learn_info.hist_num_bins, ...
                                                          rho_range);
% construct the necessary basis
if learn_info.VERBOSE > 1, fprintf('\nConstruct the basis...');      end                            % now we are ready to build the basis
basis                                                   = construct_basis_uniform(phi_range, sys_info, learn_info);
Timings.constructBasis                                  = toc(Timings.constructBasis);
% prepar for assembly of the learning matrices Phi and Phi_xi
Timings.assembleALM                                     = tic; 
A_cols                                                  = get_total_number_of_basis_functions(basis);
Estimator.ALM = zeros(A_cols.total); Estimator.bLM = zeros(A_cols.total, 1); rhs_in_l2_norm_sq = 0; % save the square of l_2 norm of d_vec - F_vec over all m's
Estimator.ALMXi = []; Estimator.bLMXi = []; rhs_in_l2_norm_sq_xi = [];
if A_cols.Xi ~= 0, Estimator.ALMXi = zeros(A_cols.Xi); Estimator.bLMXi = zeros(A_cols.Xi, 1); rhs_in_l2_norm_sq_xi = 0; end
if learn_info.VERBOSE > 1, fprintf('\nAssembling the matrices for the optimization problem...'); end
for m = 1 : M                                                                                       % start the MC loop
  [x_m, v_m, xi_m, dot_xv_m, dot_xi_m]                  = get_the_data_at_m(x, v, xi, dot_xv, dot_xi, m);
  file_name                                             = sprintf('%s/%s_%s_CPU%d_%d_partitioned_data.mat', ...
  learn_info.temp_dir, sys_info.name, learn_info.time_stamp, 1, m);
  [PsiE_m, PsiA_m, PsiXi_m, F_vec_m, d_vec_m, Fxi_vec_m, dxi_vec_m, assemble_single_m] ...
                                                        = assemble_Anb_at_m(x_m, v_m, xi_m, dot_xv_m, ...
  dot_xi_m, time_vec, agent_info, sys_info, basis, file_name);
  [hist_counts_m, assemble_single_m.assemble_the_rhoLTM] ...
                                                        = assemble_histcounts_at_m(hist_edges, file_name);
  if m == 1
    hist_counts                                         = hist_counts_m;
    assemble_single                                     = assemble_single_m;
  else
    hist_counts                                         = add_histcounts(hist_counts_m, hist_counts);  
    assemble_single                                     = add_two_timings(assemble_single_m, assemble_single);
  end
  if ~isempty(F_vec_m), rhs_vec = d_vec_m - F_vec_m; else, rhs_vec = d_vec_m; end
  Psi                                                   = [PsiE_m, PsiA_m]; 
  rhs_in_l2_norm_sq                                     = rhs_in_l2_norm_sq + norm(rhs_vec)^2/(L * M);
  Estimator.ALM                                         = Estimator.ALM + (transpose(Psi) * Psi)/(L * M); % assemble the approximated Estimator.ALM matrix
  Estimator.bLM                                         = Estimator.bLM + (transpose(Psi) * rhs_vec)/(L * M);  
  if ~isempty(Estimator.ALMXi)
    if ~isempty(Fxi_vec_m), rhs_vec_xi = dxi_vec_m - Fxi_vec_m; else, rhs_vec_xi = dxi_vec_m; end
    rhs_in_l2_norm_sq_xi                                = rhs_in_l2_norm_sq_xi + norm(rhs_vec_xi)^2/(L * M);  
    Estimator.ALMXi                                     = Estimator.ALMXi + (transpose(PsiXi_m) * PsiXi_m)/(L * M);
    Estimator.bLMXi                                     = Estimator.bLMXi + (transpose(PsiXi_m) * rhs_vec_xi)/(L * M);
  else
    if m == 1, rhs_in_l2_norm_sq_xi = []; end
  end
% delete the data file
  delete(file_name);  
end
Timings.assemble_single_m                               = average_timings(assemble_single, M);
Timings.assembleALM                                     = toc(Timings.assembleALM);
if learn_info.VERBOSE > 1, fprintf('It took %10.4e seconds to assemble Estimator.ALM and Estimator.bLM.\n', Timings.assembleALM); end
Estimator                                               = set_basis_in_Estimator(basis, sys_info, Estimator);
Estimator.rhs_in_l2_norm_sq                             = rhs_in_l2_norm_sq;                        % we also need the square of the l_2 norm of d_vec - F_vec over all m's
Estimator.rhs_in_l2_norm_sq_xi                          = rhs_in_l2_norm_sq_xi;
Estimator.rhoLTM                                        = package_rhoLT(hist_edges, hist_binwidths, ...
                                                          hist_counts, sys_info, rho_range); 
Timings.assemble_total                                  = toc(Timings.assemble_total);
end