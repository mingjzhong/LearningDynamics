function range_data = initialize_range_data(L, sys_info, type)
% function range_data = initialize_range_data(L, sys_info, type)

% (C) M. Zhong

[num_kinds, kind_names] = get_phi_or_rho_kinds(sys_info, type);
range_data              = cell(1, num_kinds);
for idx = 1 : num_kinds
  range_data{idx}       = initialize_range_data_each_kind(L, sys_info, kind_names{idx}, type); 
end
end