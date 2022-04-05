function rho_pdist = get_rho_pdist_data(v, xi, r_plus_V, agent_info, sys_info)
% function rho_pdist = get_rho_pdist_data(v, xi, r_plus_V, agent_info, sys_info)

% (C) M. Zhong (JHU)

psi_pdist                                  = get_pdist_data(r_plus_V, sys_info);
rho_weight                                 = get_rho_weight(v, xi, agent_info, sys_info);
num_kinds                                  = length(psi_pdist);
rho_pdist                                  = cell(size(psi_pdist));
for kind = 1 : num_kinds
  rho_pdist{kind}                          = cell(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      phi_dim                              = length(psi_pdist{kind}{k1, k2});
      if ~isempty(rho_weight{kind}) && ~isempty(rho_weight{kind}{k1, k2})
        rho_dim                            = phi_dim + 1;
      else
        rho_dim                            = phi_dim;
      end
      rho_pdist{kind}{k1, k2}              = cell(1, rho_dim);
      rho_pdist{kind}{k1, k2}(1 : phi_dim) = psi_pdist{kind}{k1, k2};
      if rho_dim > phi_dim
        rho_pdist{kind}{k1, k2}{rho_dim}   = rho_weight{kind}{k1, k2};
      end
    end
  end
end
end