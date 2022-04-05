function bLM_ind = initialize_bLM_ind(sys_info)
% function bLM_ind = initialize_bLM_ind(sys_info)

% (C) M. Zhong (JHU)

num_bLMs       = get_num_bLMs(sys_info);
bLM_ind        = cell(1, num_bLMs);
for ind = 1 : num_bLMs
  bLM_ind{ind} = cell(1, sys_info.K);
end
end