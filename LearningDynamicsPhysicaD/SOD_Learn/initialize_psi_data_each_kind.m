function [pdist_data, pdiff_data] = initialize_psi_data_each_kind(sys_info, learn_info, is_rhoLT, kind)
% function [pdist_data, pdiff_data] = initialize_psi_data_each_kind(sys_info, learn_info, is_rhoLT, kind)

% (C) M. Zhong

phi_dim                  = get_phi_and_rho_dim_each_kind(kind, sys_info, learn_info, is_rhoLT);
if ~isempty(phi_dim)
  pdist_data             = cell(sys_info.K);
  pdiff_data             = cell(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      pdist_data{k1, k2} = cell(1, phi_dim(k1, k2));
    end
  end
else
  pdist_data             = [];
  pdiff_data             = [];
end
end