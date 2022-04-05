function G_LNkd = get_G_LNkd_in_sparse_storage(G_LNkd_old, L, agent_info, sys_info)
% function G_LNkd = get_G_LNkd_in_sparse_storage(G_LNkd_old, L, agent_info, sys_info)

% (C) M. Zhong

if ~isempty(G_LNkd_old)
  G_LNkd               = cell(size(G_LNkd_old));
  for ind = 1 : length(G_LNkd_old)
    if ind == 1, d = sys_info.d; else, d = 1; end
    if ~isempty(G_LNkd_old{ind})
      G_LNkd{ind}      = cell(1, sys_info.K);
      for k = 1 : sys_info.K
        G_LNkd{ind}{k} = sparse(G_LNkd_old{ind}{k}.row_ind, G_LNkd_old{ind}{k}.col_ind, ...
                         G_LNkd_old{ind}{k}.nz_vals, L * agent_info.num_agents(k) * d, ...
                         L * agent_info.num_agents(k) * d);
      end
    end
  end
else
  G_LNkd               = [];
end
end