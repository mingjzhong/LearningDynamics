function [phi_range, rho_range] = partition_the_data(x, v, xi, agent_info, sys_info, learn_info, ...
                                  cpuID)
% function [phi_range, rho_range] = partition_the_data_new(x, v, xi, agents_info, sys_info, learn_info, ...
%                                   cpuID)

% (c) M. Zhong (JHU)

if nargin < 7, cpuID = 1; end                                                                       % for serial assemble, it is always on cpu 1
% set up indicators and initialize storages         
is_rhoLT                                                 = isfield(learn_info, 'is_rhoLT') && learn_info.is_rhoLT;
[phi_range, rho_range]                                   = initialize_range_data(sys_info, learn_info, is_rhoLT, size(x, 3));
% go through each m, each initial condition
for m = 1 : size(x, 3)
  [x_m, v_m, xi_m]                                       = get_the_data_at_m(x, v, xi, [], [], m); 
  file_name                                              = sprintf(learn_info.pd_file_form, ...
                                                           learn_info.temp_dir, sys_info.name, ...
                                                           learn_info.time_stamp, cpuID, m);
% pairwise distance/difference data for the the basis functions
  [psi_pdist, psi_pdiff]                                 = initialize_psi_data(sys_info, learn_info, is_rhoLT); 
% pairwise distance/difference data for the rho's
  rho_pdist                                              = initialize_rho_data(sys_info, learn_info, is_rhoLT);   
% pairwise restriction on the basis functions
  phi_rest                                               = initialize_phi_restriction(sys_info, is_rhoLT);
% row indices in the learning matrices, Psi, and/or PsiXi, and/or PsiTheta 
  Psi_row_ind                                            = initialize_Psi_row_ind(sys_info, learn_info, is_rhoLT);
% ranges at all time t, for phi's
  [phi_range_l, rho_range_l]                             = initialize_range_data(sys_info, learn_info, is_rhoLT, size(x_m, 2));
% go through time
  for l = 1 : size(x_m, 2)
% find out the pairwise distance data and pairwise difference data
    [x_l, v_l, xi_l]                                     = get_the_data_at_t(x_m, v_m, xi_m, l, ...
      sys_info);
    psi_pdiff_l                                          = get_psi_pdiff_at_t(x_l, v_l, xi_l, sys_info, ...
      learn_info, is_rhoLT);
    [psi_pdist_l, rho_weight_l]                          = get_psi_pdist_at_t(x_l, v_l, xi_l, agent_info, ...
      sys_info, learn_info, is_rhoLT);
    phi_rest_l                                           = get_phi_restriction_at_t(x_l, v_l, xi_l, ...
      sys_info, is_rhoLT);
% now partition the data according to each (Ck1, Ck2) pair    
    for k1 = 1 : sys_info.K  
      Nk1                                                = agent_info.num_agents(k1);
      [row_in_NkL_mat, row_in_NkdL_mat]                  = get_row_ind_in_mat(Nk1, l, sys_info, is_rhoLT);
      Psi_row_ind                                        = set_phi_row_indices(k1, l, Nk1, size(x_m, 2), row_in_NkL_mat, ...
        row_in_NkdL_mat, agent_info, sys_info, Psi_row_ind, is_rhoLT);
      for k2 = 1 : sys_info.K
        Nk2                                              = agent_info.num_agents(k2);
        if l == 1
          [psi_pdist, psi_pdiff]                         = initialize_psi_data_Ck1Ck2(k1, Nk1, k2, ...
            Nk2, sys_info.d, size(x_m, 2), psi_pdist, psi_pdiff, sys_info);
          rho_pdist                                      = initialize_rho_data_Ck1Ck2(k1, Nk1, k2, ...
            Nk2, size(x_m, 2), rho_pdist);
          phi_rest                                       = initialize_phi_restriction_Ck1Ck2(k1, Nk1, ...
            k2, Nk2, size(x_m, 2), phi_rest);
        end
        [psi_pdist, rho_pdist, phi_range_l, rho_range_l] = set_psi_and_rho_pdist(k1, Nk1, k2, Nk2, l, ...
          row_in_NkL_mat, psi_pdist_l, rho_weight_l, psi_pdist, rho_pdist, phi_range_l, rho_range_l);
        psi_pdiff                                        = set_psi_pdiff(k1, k2, agent_info, sys_info, ...
          row_in_NkL_mat, row_in_NkdL_mat, psi_pdiff_l, psi_pdiff);
        phi_rest                                         = set_phi_restriction(k1, k2, agent_info, ...
          row_in_NkL_mat, phi_rest_l, phi_rest);
      end
    end
  end
% save the processed data for each m
  save(file_name, '-v7.3', 'psi_pdist', 'psi_pdiff', 'phi_rest', 'rho_pdist', 'Psi_row_ind'); 
% find out the ranges for t \in [T_0, T]
  [phi_range, rho_range]                                 = set_the_range_for_all_t(phi_range_l, ...
    rho_range_l, m, sys_info.K, phi_range, rho_range);
end
% find out the ranges for all m = 1, \cdots, M
[phi_range, rho_range]                                   = set_the_range_for_all_m(phi_range, ...
  rho_range, sys_info.K);
end