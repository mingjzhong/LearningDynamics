function G_LNkd = get_G_LNkd(x, xi, agent_info, sys_info)
% function G_LNkd = get_G_LNkd(x, xi, agent_info, sys_info)

% (C) M. Zhong

x                  = reshape(x, [sys_info.d, sys_info.N]);
if ~isempty(xi)
  xi               = xi';
  G_LNkd           = cell(1, 2);
else
  G_LNkd           = cell(1);
end
for ind = 1 : length(G_LNkd)
  switch ind
    case 1
      y            = x;
      var_type     = 'x';
    case 2
      y            = xi;
      var_type     = 'xi';
    otherwise
      error('');
  end
  G_LNkd{ind}      = cell(1, sys_info.K);
  for k = 1 : sys_info.K
    G_LNkd{ind}{k} = get_G_LNkd_each_type(y(:, agent_info.type_idx{k}), var_type, sys_info);
  end
end
end