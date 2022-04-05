function bLM_ind = set_bLM_ind(k, l, Nk, L, row_in_NkL_mat, row_in_NkdL_mat, agent_info, ... 
                   sys_info, bLM_ind)
% function bLM_ind = set_bLM_ind(k, l, Nk, L, row_in_NkL_mat, row_in_NkdL_mat, agent_info, ... 
%                    sys_info, bLM_ind)

% (C) M. Zhong

num_bLMs                          = length(bLM_ind);
if l == 1
  bLM_ind{1}{k}                   = zeros(Nk * sys_info.d * L, 1);
  for ind = 2 : num_bLMs
    bLM_ind{ind}{k}               = zeros(Nk * L, 1);
  end
end
bLM_ind{1}{k}(row_in_NkdL_mat)    = agent_info.idxs_in_Nd{k} + (l - 1) * sys_info.N * sys_info.d;
for ind = 2 : num_bLMs
  bLM_ind{ind}{k}(row_in_NkL_mat) = agent_info.idxs{k} + (l - 1) * sys_info.N;
end 
end