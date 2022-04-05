function rhs = eval_rhs_rkn(x, sys_info)
% function rhs = eval_rhs_rkn(x, sys_info)
%   evaluates the right handside of the dynamics d^2x/dt^2 = f(x) based on the system information
%   regarding the dynamics

% (c) M. Zhong

x          = reshape(x, [sys_info.d, sys_info.N]);
v          = [];
xi         = [];                                           
agent_info = getAgentInfo(sys_info);
r_plus_V   = get_the_r_plus_V_map(x, v, xi, agent_info, sys_info);
pdist_data = get_pdist_data(r_plus_V, sys_info);
pdiff_data = get_phi_weight(x, v, xi, sys_info);
% \sum_{i' = 1}^N \phi^E_{K_i, K_i'}(H^E_{K_i, K_i'}(x, v, xi))(x_i' - x_i)  
rhs        = get_collective_change(x, v, xi, pdist_data{1}, pdiff_data{1}, agent_info,sys_info, ...
             'energy'); 
end