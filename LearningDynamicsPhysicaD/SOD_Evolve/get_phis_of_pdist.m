function phis_of_pdist = get_phis_of_pdist(pdist_data, agent_info, sys_info, type)
% function phis_of_pdist = get_phis_of_pdist(pdist_data, sys_info, type)
%   calculates 1/N_i' * \phi_{K_i, K_i'}(H_{K_i, K_i'}(x, v, xi)), where H_{K_i, K_i'} is the
%   feature map of its corresponding phi
% IN:
%   H_{K_i, K_i'}(x, v, xi) : feature map, from R^{2Nd + 1} x R^{2Nd + 1} to R^d_{phi}
%   sys_info                : system information struct 
%   type                    : phi type
% OUT:
%   phis_of_pdist : 1/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) for i \in C_k1 and i' \in C_k2

% (c) M. Zhong, M. Maggioni, JHU

% initialize phi_of_pdist, size N * N, N the number of agents in the system
phis_of_pdist                           = zeros(sys_info.N);   
% pick a set of phis and kappa to work on
switch type                                                                                         
  case 'energy'
    phis                                = sys_info.phiE;
  case 'alignment'
    phis                                = sys_info.phiA;
  case 'xi'
    phis                                = sys_info.phiXi;
  otherwise
end
% go through the number of classes instead of agents
for k1 = 1 : sys_info.K                                                                                 
  row_ind                               = agent_info.idxs{k1};                                      % find out the rows in this class C_k1
  N_k1                                  = agent_info.num_agents(k1);
  for k2 = 1 : sys_info.K                                                                           % for the influence of C_k2 agents on C_k1 agents        
    col_ind                             = agent_info.idxs{k2};                                      % find out the cols in this class C_{k2}        
    N_k2                                = agent_info.num_agents(k2);                                % find out the number of agents in class C_k2
    phi_of_pdist_Ck1_Ck2                = evaluate_phi_at_pdist(phis{k1, k2}, pdist_data{k1, k2});
    phi_of_pdist_Ck1_Ck2                = reshape(phi_of_pdist_Ck1_Ck2, [N_k1, N_k2]);
    phis_of_pdist(row_ind, col_ind)     = phi_of_pdist_Ck1_Ck2/N_k2;                                % scale by 1/N_k2, and save it accordingly
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