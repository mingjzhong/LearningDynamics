function rho_pdist = initialize_rho_data_each_kind(sys_info, kind)
% function rho_pdist = initialize_rho_data_each_kind(sys_info, kind)
% (C) M. Zhong

rho_dim                 = get_rho_dim_each_kind(kind, sys_info);
if ~isempty(rho_dim)
  rho_pdist             = cell(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      rho_pdist{k1, k2} = cell(1, rho_dim(k1, k2));
    end
  end
else
  rho_pdist             = [];
end
end