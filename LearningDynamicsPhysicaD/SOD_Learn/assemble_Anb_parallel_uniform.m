function [Estimator, Timings] = assemble_Anb_parallel_uniform(x_d, v_d, xi_d, dot_xv_d, dot_xi_d, time_vec, sys_info, learn_info)
% function [Estimator, Timings] = assemble_Anb_parallel_uniform(x_d, v_d, xi_d, dot_xv_d, dot_xi_d, time_vec, sys_info, learn_info)
% OUT:
%   Estimator:  structure with fields:
%     Ebasis, Timings

% (c) M. Zhong (JHU)

% define the tags for data communication (shared by all workers)
phi_range_tags                               = 0 : 2;
rho_range_tags                               = length(phi_range_tags) + (0 : 2);
idle_cpu_tag                                 = length(phi_range_tags) + length(rho_range_tags);
% make x, v, xi, dot_xv, dot_xi into distributed variables for workers
x_d                                          = distributed(x_d); 
v_d                                          = distributed(v_d); 
xi_d                                         = distributed(xi_d); 
dot_xv_d                                     = distributed(dot_xv_d); 
dot_xi_d                                     = distributed(dot_xi_d);
% naming convention for the varaibles:
% 1) *_d, distributed data from client side (not individual worker)
% 2) *_l, local data (stored in each individual worker) needed for final assembly later on client side
% prepare the folder for temporary data file output
if ispc, learn_info.temp_dir = [learn_info.SAVE_DIR, '\tempOut']; else, learn_info.temp_dir = [learn_info.SAVE_DIR, '/tempOut']; end
if ~exist(learn_info.temp_dir, 'dir'), mkdir(learn_info.temp_dir); end
% start the parallelization using SPMD, variable de
spmd
  if labindex == 1, num_cores_l = numlabs; else, num_cores_l = []; end                              % Lab(1) is in charge of communicating
  work_cpu_list                              = [];                                                  % list of CPUs with actual work to do
  x                                          = getLocalPart(x_d);                                   % get local copies of v, xi, dot_xv and dot_x
  v                                          = getLocalPart(v_d); 
  xi                                         = getLocalPart(xi_d); 
  dot_xv                                     = getLocalPart(dot_xv_d); 
  dot_xi                                     = getLocalPart(dot_xi_d);                              
  if labindex ~= 1                                                                                  % create the list of working CPUs for CPU 1
    if learn_info.VERBOSE > 1
      fprintf('\nLab%2d: sending the indicator of working CPU (tagID = %d) to Lab ( 1).', labindex, ...
        idle_cpu_tag); 
    end    
    labSend(~isempty(x), 1, idle_cpu_tag);
  else
    work_cpu_tags                            = true(1, num_cores_l);
    for lab_ind = 2 : num_cores_l
      if learn_info.VERBOSE > 1
        fprintf('\nLab%2d: receiving the indicator of working CPU (tagID = %d) from Lab (%2d).', ...
          labindex, idle_cpu_tag, lab_ind); 
      end
      work_cpu_tags(lab_ind)                 = labReceive(lab_ind, idle_cpu_tag);
    end
    work_cpu_list                            = 1 : num_cores_l;
    work_cpu_list                            = work_cpu_list(work_cpu_tags);
  end  
  if ~isempty(x)
% initialize some indicators                                    
    agent_info                               = getAgentInfo(sys_info); 
    M_l                                      = size(x, 3);
    if learn_info.VERBOSE > 1
      fprintf('\nLab = %2d: My copy of x has size [%d, %d, %d].', labindex, size(x, 1), size(x, 2), M_l);
    end
    findRange_l                              = tic;
    [phi_range_l, rho_range_l]               = partition_the_data(x, v, xi, agent_info, sys_info, learn_info, labindex);
    if labindex ~= 1
      for ind = 1 : length(phi_range_l)
        if learn_info.VERBOSE > 1, fprintf('\nLab%2d: sending my copy of phi_range{%d} (tagID = %d) to Lab ( 1).', labindex, ind, pdata_tags(ind)); end
        labSend(phi_range_l{ind}, 1, phi_range_tags(ind));
      end
      for ind = 1 : length(rho_range_l)
        if learn_info.VERBOSE > 1, fprintf('\nLab%2d: sending my copy of rho_range{%d} (tagID = %d) to Lab ( 1).', labindex, ind, pdata_tags(ind)); end
        labSend(rho_range_l{ind}, 1, rho_range_tags(ind));
      end      
    else
      phi_range_o                            = cell(size(phi_range_l));                             % for CPU1 to process the communication data
      rho_range_o                            = cell(size(rho_range_l));                             % for CPU1 to process the communication data      
      for lab_ind = 2 : length(work_cpu_list)
        for ind =  1 : length(phi_range_l)
          if learn_info.VERBOSE > 1, fprintf('\nLab%2d: receiving phi_range{%d} (tagID = %d) from Lab(%2d).', labindex, ind, pdata_tags(ind), lab_ind); end
          phi_range_o{ind}                   = labReceive(work_cpu_list(lab_ind), phi_range_tags(ind));
        end
        phi_range_l                          = process_range_data(phi_range_l, phi_range_o);
        for ind =  1 : length(rho_range_l)
          if learn_info.VERBOSE > 1, fprintf('\nLab%2d: receiving rho_range{%d} (tagID = %d) from Lab(%2d).', labindex, ind, pdata_tags(ind), lab_ind); end
          rho_range_o{ind}                   = labReceive(work_cpu_list(lab_ind), rho_range_tags(ind));
        end
        rho_range_l                          = process_range_data(rho_range_l, rho_range_o);
      end      
    end
    if labindex == 1                                                                                % send the processed pairwise data to other CPUs
      for lab_ind = 2 : length(work_cpu_list)
        for ind = 1 : length(phi_range_l)
          if learn_info.VERBOSE > 1, fprintf('\nLab%2d: sending phi_range{%d} (tagID = %d) to Lab(%2d).', labindex, ind, pdata_tags(ind), lab_ind); end
          labSend(phi_range_l{ind}, work_cpu_list(lab_ind), phi_range_tags(ind));
        end
        for ind = 1 : length(rho_range_l)
          if learn_info.VERBOSE > 1, fprintf('\nLab%2d: sending rho_range{%d} (tagID = %d) to Lab(%2d).', labindex, ind, pdata_tags(ind), lab_ind); end
          labSend(rho_range_l{ind}, work_cpu_list(lab_ind), rho_range_tags(ind));
        end
      end      
    else
      for ind = 1 : length(phi_range_l)
        if learn_info.VERBOSE > 1, fprintf('\nLab%2d: receiving phi_range{%d} (tagID = %d) from Lab( 1).', labindex, ind, pdata_tags(ind)); end
        phi_range_l{ind}                     = labReceive(1, phi_range_tags(ind));
      end
      for ind = 1 : length(rho_range_l)
        if learn_info.VERBOSE > 1, fprintf('\nLab%2d: receiving phi_range{%d} (tagID = %d) from Lab( 1).', labindex, ind, pdata_tags(ind)); end
        rho_range_l{ind}                     = labReceive(1, rho_range_tags(ind));
      end      
    end
    findRange_l                              = toc(findRange_l);
    % prepare the bins for hist count
    constructBasis_l                         = tic;
    [hist_binwidths_l, hist_edges_l]         = prepare_hist_items(learn_info.hist_num_bins, rho_range_l); % prepare items for doing histcounts
    % construct the necessary basis
    basis_l                                  = construct_basis(phi_range_l, sys_info, learn_info);
    % prepar for assembly of the learning matrices Phi and Phi_xi
    A_cols                                   = get_total_number_of_basis_functions(basis_l);        % find out the total number fo columns for the Estimator.ALM matrix
    ALM_l                                    = zeros(A_cols.total); 
    bLM_l                                    = zeros(A_cols.total, 1); 
    rhs_in_l2_norm_sq_l                      = 0;                                                   % save the square of l_2 norm of d_vec - F_vec over all m's
    if A_cols.Xi > 0
      ALMXi_l                                = zeros(A_cols.Xi); 
      bLMXi_l                                = zeros(A_cols.Xi, 1); 
      rhs_in_l2_norm_sq_xi_l                 = 0; 
    else
      ALMXi_l                                = []; 
      bLMXi_l                                = []; 
      rhs_in_l2_norm_sq_xi_l                 = [];
    end
    constructBasis_l                         = toc(constructBasis_l);
    assembleALM_l                            = tic;
    if learn_info.VERBOSE > 1, fprintf('\nAssembling the matrices for the optimization problem...'); end % now we are ready to build the basis
    for m = 1 : M_l                                                                                 % start the MC loop
      [x_m, v_m, xi_m, dot_xv_m, dot_xi_m]   = get_the_data_at_m(x, v, xi, dot_xv, dot_xi, m);
      file_name                              = sprintf(learn_info.pd_file_form, learn_info.temp_dir, ...
                                               sys_info.name, learn_info.time_stamp, labindex, m);      
      [PsiE_m, PsiA_m, PsiXi_m, F_vec_m, d_vec_m, Fxi_vec_m, dxi_vec_m, timings_assemble_single_m] ...
                                             = assemble_Anb_at_m(x_m, v_m, xi_m, dot_xv_m, dot_xi_m, ...
                                               time_vec, agent_info, sys_info, basis_l, file_name);
      [hist_counts_m, timings_assemble_single_m.assemble_the_rhoLTM] ...
                                             = assemble_histcounts_at_m(hist_edges_l, file_name);
      if m == 1
        hist_counts_l                        = hist_counts_m;
        timings_assemble_single_m_l          = timings_assemble_single_m;
      else
        hist_counts_l                        = add_histcounts(hist_counts_m, hist_counts_l);
        timings_assemble_single_m_l          = add_two_timings(timings_assemble_single_m, timings_assemble_single_m_l);                                     
      end
      if ~isempty(F_vec_m), rhs_vec = d_vec_m - F_vec_m; else, rhs_vec = d_vec_m; end
      Psi                                    = [PsiE_m, PsiA_m]; 
      rhs_in_l2_norm_sq_l                    = rhs_in_l2_norm_sq_l + norm(rhs_vec)^2;              
      ALM_l                                  = ALM_l + (transpose(Psi) * Psi);                      % assemble the approximated Estimator.ALM matrix
      bLM_l                                  = bLM_l + (transpose(Psi) * rhs_vec);  
      if A_cols.Xi > 0
        if ~isempty(Fxi_vec_m), rhs_vec_xi = dxi_vec_m - Fxi_vec_m; else, rhs_vec_xi = dxi_vec_m; end
        rhs_in_l2_norm_sq_xi_l               = rhs_in_l2_norm_sq_xi_l + norm(rhs_vec_xi)^2;                     
        ALMXi_l                              = ALMXi_l + (transpose(PsiXi_m) * PsiXi_m);
        bLMXi_l                              = bLMXi_l + (transpose(PsiXi_m) * rhs_vec_xi);
      end
% delete the data file
      delete(file_name);       
    end
    timings_assemble_single_m_l              = average_timings(timings_assemble_single_m_l, M_l);     
    assembleALM_l                            = toc(assembleALM_l);    
  else
    num_cores_l = []; M_l = []; basis_l = []; ALM_l = []; bLM_l = []; ALMXi_l = []; bLMXi_l = []; 
    rhs_in_l2_norm_sq_l = []; rhs_in_l2_norm_sq_xi_l = [];
    hist_edges_l = []; hist_binwidths_l = []; hist_counts_l = []; timings_assemble_single_m_l = [];
    assembleALM_l = []; constructBasis_l = []; findRange_l = [];
  end
end
M                                            = sum([M_l{:}]); 
L                                            = length(time_vec); 
Estimator.ALMXi                              = []; 
Estimator.bLMXi                              = [];
Timings.findRange                            = mean([findRange_l{:}]); 
Timings.constructBasis                       = mean([constructBasis_l{:}]); 
Timings.assembleALM                          = mean([assembleALM_l{:}]);
Timings.assemble_single_m                    = average_timings_over_cpus(timings_assemble_single_m_l);
Estimator                                    = set_basis_in_Estimator(basis_l{1}, sys_info, Estimator);
Estimator.ALM                                = ALM_l{1}/(L * M); 
Estimator.bLM                                = bLM_l{1}/(L * M);
if ~isempty(ALMXi_l{1})
  Estimator.ALMXi                            = ALMXi_l{1}/(L * M); 
  Estimator.bLMXi                            = bLMXi_l{1}/(L * M); 
else
  Estimator.ALMXi                            = []; 
end
for lab_ind = 2 : num_cores_l{1} 
  Estimator.ALM                              = Estimator.ALM + ALM_l{lab_ind}/(L * M); 
  Estimator.bLM                              = Estimator.bLM + bLM_l{lab_ind}/(L * M);
  if ~isempty(ALMXi_l{lab_ind})
    Estimator.ALMXi                          = Estimator.ALMXi + ALMXi_l{lab_ind}/(L * M); 
    Estimator.bLMXi                          = Estimator.bLMXi + bLMXi_l{lab_ind}/(L * M); 
  end
end
Estimator.rhs_in_l2_norm_sq                  = sum([rhs_in_l2_norm_sq_l{:}])/(L * M);               % we also need the square of the l_2 norm of d_vec - F_vec over all m's
Estimator.rhs_in_l2_norm_sq_xi               = sum([rhs_in_l2_norm_sq_xi_l{:}])/(L * M);
hist_counts                                  = sum_histcounts_over_all_cpus(hist_counts_l);
Estimator.rhoLTM                             = package_rhoLT(hist_edges_l{1}, hist_binwidths_l{1}, ...
                                               hist_counts, sys_info, rho_range_l{1});                                                       
end