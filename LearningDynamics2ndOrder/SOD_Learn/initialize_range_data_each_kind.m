function the_range = initialize_range_data_each_kind(L, sys_info, kind, range_type)
% function the_range = initialize_range_data_each_kind(L, sys_info, kind, range_type)

% (C) M. Zhong

switch range_type
  case 'phi'
    the_dim = get_phi_dim_each_kind(kind, sys_info);
  case 'rho'
    the_dim = get_rho_dim_each_kind(kind, sys_info);
  otherwise
    error('SOD_Learn:initialize_range_data_each_kind:exception', ...
      'Only phi or rho range is supported!!');
end
the_range   = initialize_range(the_dim, sys_info.K, L);
end