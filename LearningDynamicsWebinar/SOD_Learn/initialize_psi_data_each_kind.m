function [pdist_data, pdiff_data] = initialize_psi_data_each_kind(sys_info, kind)
% function [pdist_data, pdiff_data] = initialize_psi_data_each_kind(sys_info, kind)

% (C) M. Zhong

phi_dim                = get_phi_dim_each_kind(kind, sys_info);
pdist_data             = cell(sys_info.K);
pdiff_data             = cell(sys_info.K);
for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    pdist_data{k1, k2} = cell(1, phi_dim(k1, k2));
  end
end
end