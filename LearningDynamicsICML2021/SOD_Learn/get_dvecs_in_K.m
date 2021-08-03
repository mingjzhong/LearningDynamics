function [d_new, dxi_new] = get_dvecs_in_K(d_vec, dxi_vec, agent_info, sys_info, bLM_ind)
% function [d_new, dxi_new] = get_dvecs_in_K(d_vec, dxi_vec, agent_info, sys_info, bLM_ind)

% (C) M. Zhong

d_new      = cell(1, sys_info.K);
if ~isempty(dxi_vec), dxi_new = cell(1, sys_info.K); else, dxi_new = []; end
for k = 1 : sys_info.K
  Nk       = agent_info.num_agents(k);
  d_new{k} = d_vec(bLM_ind{1}{k})/sqrt(Nk);
  if ~isempty(dxi_new), dxi_new{k} = dxi_vec(bLM_ind{2}{k})/sqrt(Nk); end
end
end