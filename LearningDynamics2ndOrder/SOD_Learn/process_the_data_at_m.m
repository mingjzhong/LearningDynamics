function [phi_range, rho_range] = process_the_data_at_m(m, y, dy, learn_info, agent_info)
% function [phi_range, rho_range] = process_the_data_at_m(m, y, dy, learn_info, agent_info)

% (C) M. Zhong

% create the data file to save data later 
L                                       = size(y, 2);
file_name                               = sprintf(learn_info.pd_file_form, learn_info.temp_dir, ...
                                          learn_info.sys_info.name, learn_info.time_stamp, m);
% split (y, dy)
[x, v, xi]                              = split_y_or_dy(y, learn_info.sys_info);
clear y
if ~learn_info.is_rhoLT
  [dx, dv, dxi]                         = split_y_or_dy(dy, learn_info.sys_info);
  clear dy
% assemble the derivative vectors and external vectors containing non-collective forces  
  if learn_info.sys_info.ode_order == 1
    dvec                                = dx(:);
  else
    dvec                                = dv(:);  
  end
  if ~isempty(xi), dvecXi = dxi(:); else, dvecXi = []; end  
% pairwise distance/difference data for the the basis functions  
  [psi_pdist, psi_pdiff]                = initialize_psi_data(learn_info.sys_info);
% pairwise restriction on the basis functions
  phi_rest                              = initialize_phi_restriction(learn_info.sys_info);  
% ranges at all time t, for phi's  
  phi_range_l                           = initialize_range_data(L, learn_info.sys_info, 'phi');  
% initialize for non-collective forces
  [Fvec, FvecXi]                        = initialize_noncollective_forces(L, learn_info.sys_info);
% initialize the indices for bLM
  bLM_ind                               = initialize_bLM_ind(learn_info.sys_info);
% initialize the data storage for the Riemannian metric g at each point, \bx_i \in M
  if isfield(learn_info.sys_info, 'on_manifold') && learn_info.sys_info.on_manifold && ...
      isfield(learn_info.sys_info, 'g_type') && ~isempty(learn_info.sys_info.g_type) && ...
      ~strcmp(learn_info.sys_info.g_type, 'L2')
    G_LNkd                              = initialize_G_LNkd(L, agent_info, learn_info.sys_info);
  else
    G_LNkd                              = []; 
  end
else
  dvec                                  = [];
  dvecXi                                = [];
  psi_pdist                             = []; 
  psi_pdiff                             = []; 
  phi_rest                              = [];
  G_LNkd                                = [];
end
% pairwise distance/difference data for the rho's
rho_pdist                               = initialize_rho_data(learn_info.sys_info);   
% range for the rho's
rho_range_l                             = initialize_range_data(L, learn_info.sys_info, 'rho');
% go through time
for l = 1 : L
% find out the pairwise distance data and pairwise difference data
  [x_l, v_l, xi_l]                      = get_the_data_at_t(x, v, xi, l, learn_info.sys_info);
  if ~learn_info.is_rhoLT
    [Fvec, FvecXi]                      = get_the_externals(l, x_l, v_l, xi_l, Fvec, FvecXi, ...
                                          learn_info.sys_info);
  end
  r_plus_V_l                            = get_the_r_plus_V_map(x_l, v_l, xi_l, agent_info, ...
                                          learn_info.sys_info);
  if ~learn_info.is_rhoLT
    psi_pdiff_l                         = get_phi_weight(x_l, v_l, xi_l, learn_info.sys_info);
    psi_pdist_l                         = get_pdist_data(r_plus_V_l, learn_info.sys_info);
    phi_rest_l                          = get_phi_restriction_at_t(x_l, v_l, xi_l, ...
                                          learn_info.sys_info);
    if isfield(learn_info.sys_info, 'on_manifold') && learn_info.sys_info.on_manifold && ...
       isfield(learn_info.sys_info, 'g_type') && ~isempty(learn_info.sys_info.g_type) && ...
       ~strcmp(learn_info.sys_info.g_type, 'L2')                                    
      G_LNkd_l                          = get_G_LNkd(x_l, xi_l, agent_info, learn_info.sys_info);
      G_LNkd                            = set_G_LNkd(G_LNkd_l, l, agent_info, learn_info.sys_info, ...
                                          G_LNkd);
    end
  end
  rho_pdist_l                           = get_rho_pdist_data(v_l, xi_l, r_plus_V_l, agent_info, ...
                                          learn_info.sys_info); 
% now partition the data according to each (Ck1, Ck2) pair    
  for k1 = 1 : learn_info.sys_info.K  
    Nk1                                 = agent_info.num_agents(k1);
    if ~learn_info.is_rhoLT
      [row_in_NkL_mat, row_in_NkdL_mat] = get_row_ind_in_mat(Nk1, l, learn_info.sys_info);
      bLM_ind                           = set_bLM_ind(k1, l, Nk1, L, row_in_NkL_mat, ...
                                          row_in_NkdL_mat, agent_info, learn_info.sys_info, bLM_ind);
    end
    
    for k2 = 1 : learn_info.sys_info.K
      Nk2                               = agent_info.num_agents(k2);
      if l == 1
        if ~learn_info.is_rhoLT
          [psi_pdist, psi_pdiff]        = initialize_psi_data_Ck1Ck2(k1, Nk1, k2, Nk2, ...
                                          learn_info.sys_info.d, L, psi_pdist, psi_pdiff, ...
                                          learn_info.sys_info);
          phi_rest                      = initialize_phi_restriction_Ck1Ck2(k1, Nk1, k2, Nk2, ...
                                          L, phi_rest);
        end
        rho_pdist                       = initialize_rho_data_Ck1Ck2(k1, Nk1, k2, Nk2, L, rho_pdist);
      end
      if ~learn_info.is_rhoLT
        [psi_pdist, phi_range_l]        = set_psi_pdist(k1, Nk1, k2, Nk2, l, row_in_NkL_mat, ...
                                          psi_pdist_l, psi_pdist, phi_range_l);
        psi_pdiff                       = set_psi_pdiff(k1, k2, agent_info, learn_info.sys_info, ...
                                          row_in_NkL_mat, row_in_NkdL_mat, psi_pdiff_l, psi_pdiff);      
        phi_rest                        = set_phi_restriction(k1, k2, agent_info, row_in_NkL_mat, ...
                                          phi_rest_l, phi_rest);                              
      end
      [rho_pdist, rho_range_l]          = set_rho_pdist(k1, Nk1, k2, Nk2, l, rho_pdist_l, ...
                                          rho_pdist, rho_range_l);
    end
  end  
end
% Work out the right hand side vectors
if ~learn_info.is_rhoLT
  if ~isempty(Fvec), Fvec = Fvec(:); dvec = dvec - Fvec; end
  if ~isempty(FvecXi), FvecXi = FvecXi(:); dvecXi = dvecXi - FvecXi; end
  [dvec, dvecXi]                        = get_dvecs_in_K(dvec, dvecXi, agent_info, ...
                                          learn_info.sys_info, bLM_ind);
  if isfield(learn_info.sys_info, 'on_manifold') && learn_info.sys_info.on_manifold && ...
     isfield(learn_info.sys_info, 'g_type') && ~isempty(learn_info.sys_info.g_type) && ...
     ~strcmp(learn_info.sys_info.g_type, 'L2')                                        
    G_LNkd                              = get_G_LNkd_in_sparse_storage(G_LNkd, L, agent_info, ...
                                          learn_info.sys_info);
  end
end
% save the processed data for each m
save(file_name, '-v7.3', 'psi_pdist', 'psi_pdiff', 'phi_rest', 'rho_pdist', 'dvec', 'dvecXi', 'G_LNkd');
% find out the ranges for t \in [T_0, T]
if ~learn_info.is_rhoLT
  phi_range                             = set_the_range_for_all_t(phi_range_l, learn_info.sys_info.K);
else
  phi_range                             = [];
end
rho_range                               = set_the_range_for_all_t(rho_range_l, learn_info.sys_info.K);  
end