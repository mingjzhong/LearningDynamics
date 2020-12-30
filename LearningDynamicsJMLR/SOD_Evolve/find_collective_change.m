function collective_change = find_collective_change(x, v, xi, pdist_mat, sys_info, type)
% function collective_change = find_collective_change(x, v, xi, pdist_mat, sys_info)
%   calculates \sum_{i' \in K_i'} kappa_{K_i'}/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'
%   where pdiff_ii' = x_i - x_i', v_i - v_i', or xi_i - xi_i', which is given in the_pdiff variable
% IN:
%
% OUT:
%   collective_change : \sum_{i' \in K_i'} kappa_{K_i'}/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'

% (c) M. Zhong, JHU

% prepare phis_of_pdist (with regulation)
phis_of_pdist     = find_phis_of_pdist(pdist_mat, sys_info, type);                                  % construct the phi_of_pdist matirx, first order it is energy based
phis_of_pdist     = add_regulation(x, v, xi, phis_of_pdist, sys_info, type);                        % add regulation to the dynamics

% prepare pairwise differences
switch type
    case 'energy'
        the_pdiff     = find_pair_diff(x);
        if sys_info.d > 1, phis_of_pdist = kron(phis_of_pdist, ones(sys_info.d, 1)); end            % when d > 1, change phis_of_pdist to size (d * N) * N
    case 'alignment'
        the_pdiff     = find_pair_diff(v);
        if sys_info.d > 1, phis_of_pdist = kron(phis_of_pdist, ones(sys_info.d, 1)); end
    case 'xi'
        the_pdiff     = find_pair_diff(xi);
    otherwise
end
% pointwise multiplication of kappa_{K_i'}/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'
agent_change      = phis_of_pdist .* the_pdiff;                                                     % for each agent, it is kappa_{K_i'}/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'
collective_change = sum(agent_change, 2);                                                           % the class influence for agent i is: \sum_{i' \in K_i'} kappa_{K_i'}/N_i' * \phi_{K_i, K_i'}(|x_i - x_i'|) * pdiff_ii'

return