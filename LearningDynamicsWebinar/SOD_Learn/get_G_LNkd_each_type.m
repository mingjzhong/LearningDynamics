function G_LNkd = get_G_LNkd_each_type(y, var_type, sys_info)
% function G_LNkd = get_G_LNkd_each_type(y, var_type, sys_info)

% (C) M. Zhong

switch var_type
  case 'x'
    G_LNkd = sys_info.gx(y);
  case 'xi'
    G_LNkd = sys_info.gxi(y);
  otherwise
    error('');
end
end