function agent_info = getAgentInfo(sys_info)
% function agent_info = getAgentInfo(sys_info)

% (C) M. Maggioni, M. Zhong (JHU)

agent_info.type_idx        = cell(1, sys_info.K);
agent_info.num_agents      = zeros(1, sys_info.K);
agent_ind                  = 1 : sys_info.N;
agent_info.idxs            = cell(1, sys_info.K);
agent_info.idxs_in_Nd      = cell(1, sys_info.K);
d_vec                      = 1 : sys_info.d;
agent_info.Nks             = zeros(sys_info.N, 1);
for k = 1 : sys_info.K
  idx                      = sys_info.type_info == k;
  agent_info.type_idx{k}   = idx;                                                                   % logical type index for each agent  
  agent_info.idxs{k}       = agent_ind(agent_info.type_idx{k});                                     % numeric type index for each agent\
  agent_info.num_agents(k) = length(agent_info.idxs{k});                                            % number of agents in each type
  d_vec_long               = repmat(d_vec, [1, agent_info.num_agents(k)]);
  idx_vec                  = (agent_info.idxs{k} - 1) * sys_info.d;
  if ~isrow(idx_vec), idx_vec = idx_vec'; end
  idx_vec_long             = kron(idx_vec, ones(1, sys_info.d));
  agent_info.idxs_in_Nd{k} = d_vec_long + idx_vec_long;
  agent_info.Nks(idx)      = agent_info.num_agents(k); 
end
end