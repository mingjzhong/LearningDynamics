function phis_of_pdist = find_phis_of_pdist(pdist_mat, sys_info, type)
% function phis_of_pdist = find_phis_of_pdist(phis, pdist_mat, sys_info, type)
%   calculates \kappa_i'/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) for either energy based or alignement
%   based or xi based influence function \phi's for different class to class interaction
% IN:
%   pdist_mat     : pairwise distance, r_ii' = |x_i - x_i'| of the whole system
%   sys_info      : system information struct 
%   type          : phi and kappa type
% OUT:
%   phis_of_pdist : \kappa_i'/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) for i \in C_k1 and i' \in C_k2

% (c) M. Zhong, M. Maggioni, JHU

% initialize phi_of_pdist, size N * N, N the number of agents in the system
phis_of_pdist                           = zeros(sys_info.N);                                        
% pick a set of phis and kappa to work on
switch type                                                                                         
  case 'energy'
    phis                                = sys_info.phiE;
    kappa                               = sys_info.kappa;
  case 'alignment'
    phis                                = sys_info.phiA;
    kappa                               = sys_info.kappa;
  case 'xi'
    phis                                = sys_info.phiXi;
    kappa                               = sys_info.kappaXi;
  otherwise
end
% go through the number of classes instead of agents
for k1 = 1 : sys_info.K                                                                                 
  row_ind                               = find(sys_info.type_info == k1);                           % find out the rows in this class C_k1
  N_k1                                  = length(row_ind);
  for k2 = 1 : sys_info.K                                                                           % for the influence of C_k2 agents on C_k1 agents        
    col_ind                             = find(sys_info.type_info == k2);                           % find out the cols in this class C_{k2}        
    N_k2                                = length(col_ind);                                          % find out the number of agents in class C_k2
%   phi_of_pdist_Ck1_Ck2                = phis{k1, k2}(pdist_mat(row_ind, col_ind));
    pdist_Ck1_Ck2_mat                   = pdist_mat(row_ind, col_ind);
    pdist_Ck1_Ck2_vec                   = pdist_Ck1_Ck2_mat(:);
    phi_of_pdist_Ck1_Ck2                = reshape(phis{k1, k2}(pdist_Ck1_Ck2_vec), [N_k1, N_k2]) ;  % evaluate phi_{k_1, k_2}(r_{i, i'}) with i \in C_k1, j \in C_k2 
    phis_of_pdist(row_ind, col_ind)     = phi_of_pdist_Ck1_Ck2 * (kappa(k2)/N_k2);                  % scale by \kappa_k2/N_k2, and save it accordingly
  end
end

% exception check
phis_of_pdist(logical(eye(sys_info.N))) = 0;                                                        % for i = i', \phi_{k, k}(|x_i - x_i|) can be anything, default to 0
ind                                     = isinf(phis_of_pdist);                                     % error check, when r_ii' = 0, \phi(0) should not blow up
if nnz(ind) > 0
  error('SOD_Evolve:find_phis_of_pdist:exception', 'phi(0) = Inf!!');
end
ind                                     = isnan(phis_of_pdist);
if nnz(ind) > 0
  error('SOD_Evolve:find_phis_of_pdist:exception', 'phi(0) = NaN!!');
end
end