function num_bLMs = get_num_bLMs(sys_info)
% function num_bLMs = get_num_bLMs(sys_info)

% (C) M. Zhong

num_bLMs   = 1;
if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
  num_bLMs = num_bLMs + 1;
end
end