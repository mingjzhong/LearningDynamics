function pdist_data = get_pdist_data(r_plus_V, sys_info)
% function pdist_data = get_pdist_data(r_plus_V, sys_info)

% (C) M. Zhong (JHU)

[num_kinds, kind_names] = get_phi_or_rho_kinds(sys_info, 'phi');
pdist_data              = cell(1, num_kinds);
for idx = 1 : num_kinds
  pdist_data{idx}       = get_pdist_data_each_kind(r_plus_V, sys_info, kind_names{idx});
end
end