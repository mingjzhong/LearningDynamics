function G_LNkd = initialize_G_LNkd(L, agent_info, sys_info)
% function G_LNkd = initialize_G_LNkd(L, agent_info, sys_info)

% (C) M. Zhong

if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  G_LNkd                   = cell(1, 2);
else
  G_LNkd                   = cell(1);
end
for ind = 1 : length(G_LNkd)
  G_LNkd{ind}              = cell(1, sys_info.K);
  for k = 1 : sys_info.K
    G_LNkd{ind}{k}.row_ind = zeros(L * agent_info.num_agents(k) * sys_info.d^2, 1);
    G_LNkd{ind}{k}.col_ind = zeros(L * agent_info.num_agents(k) * sys_info.d^2, 1);
    G_LNkd{ind}{k}.nz_vals = zeros(L * agent_info.num_agents(k) * sys_info.d^2, 1);
  end
end
end