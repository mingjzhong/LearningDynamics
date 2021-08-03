function collective_change = get_collective_change(x, v, xi, pdist_data, pdiff_data, agent_info, ...
                            sys_info, kind)
% function collective_change = get_collective_change(x, v, xi, pdist_data, pdiff_data, agent_info, ...
%                              sys_info, kind)
% calculates \sum_{i' \in K_i'} 1/N_K_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'
% where pdiff_ii' = x_i - x_i', v_i - v_i', or xi_i - xi_i', or 1 which is given in pdiff_data 
% variable
% IN:
%
% OUT:
%   collective_change : \sum_{i' \in K_i'} 1/N_K_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'

% (c) M. Zhong, JHU

% prepare phis_of_pdist (with regulation)
phis_of_pdist = get_phis_of_pdist(pdist_data, agent_info, sys_info, kind);                          % construct the phi_of_pdist matirx
phi_res       = get_phi_restriction_each_kind(x, v, xi, sys_info, kind);                            % find the restriction on phi's from the dynamics
if ~isempty(phi_res), phis_of_pdist = phis_of_pdist .* phi_res; end                                 % restriction is applied entry-wise   
% prepare pairwise differences
switch kind
  case 'energy'
    d = sys_info.d;
  case 'alignment'
    d = sys_info.d;
  case 'xi'
    d = 1;
  otherwise
end
% pointwise multiplication of 1/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'
if ~isempty(pdiff_data), agent_change = smatrix_times_vmatrix(phis_of_pdist, pdiff_data, d);    
else, agent_change = phis_of_pdist; end                                                             % for each agent, it is 1/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'
collective_change = sum(agent_change, 2);                                                           % the class influence for agent i is: \sum_{i' \in K_i'} kappa_{K_i'}/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'
end