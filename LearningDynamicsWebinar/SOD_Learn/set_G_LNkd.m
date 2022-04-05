function G_LNkd = set_G_LNkd(G_LNkd_l, l, agent_info, sys_info, G_LNkd)
% function G_LNkd = set_G_LNkd(G_LNkd_l, l, agent_info, sys_info, G_LNkd)

% (C) M. Zhong

for G_ind = 1 : length(G_LNkd_l)
  if G_ind == 1
    d                      = sys_info.d;
  else
    d                      = 1;
  end
  for k = 1 : sys_info.K
    Nk                            = agent_info.num_agents(k);
    ind                           = (l - 1) * Nk * d^2 + 1 : l * Nk * d^2;      
    block_inc                     = kron((0 : (Nk - 1)) * d, ones(1, d^2));
    G_LNkd{G_ind}{k}.row_ind(ind) = (repmat(repmat(1 : d,   [1, d]), [1, Nk]) + block_inc) + (l - 1) * Nk * d;
    G_LNkd{G_ind}{k}.col_ind(ind) = (repmat(kron(1 : d, ones(1, d)), [1, Nk]) + block_inc) + (l - 1) * Nk * d;
    G_LNkd{G_ind}{k}.nz_vals(ind) = G_LNkd_l{G_ind}{k};
  end
end
end