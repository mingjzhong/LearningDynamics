function rhoLT = package_rhoLT(hist_edges, hist_binwidths, hist_counts, sys_info, rho_range)
% function rhoLT = package_rhoLT(hist_edges, hist_binwidths, hist_counts, sys_info, rho_range)

% (c) M. Zhong (JHU)

[num_kinds, kind_name]             = get_phi_or_rho_kinds(sys_info, 'rho');
rhoLT                              = cell(1, num_kinds);
for ind = 1 : num_kinds
  if ~isempty(rho_range{ind})
    rhoLT{ind}                     = cell(sys_info.K);
    for k1 = 1 : sys_info.K
      for k2 = 1 : sys_info.K
        rhoLT{ind}{k1, k2}         = package_rhoLT_each_kind(hist_edges{ind}{k1, k2}, ...
                                     hist_binwidths{ind}{k1, k2}, hist_counts{ind}{k1, k2}, ...
                                     sys_info, rho_range{ind}{k1, k2}, kind_name{ind});
      end
    end
  end
end
if sys_info.ode_order == 2 && (isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)) && ...
  (isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA))
  rhoLT_old                        = rhoLT;
  kinds_old                        = length(rhoLT_old);
  rhoLT                            = cell(1, kinds_old + 1);
  rhoLT(1 : kinds_old)             = rhoLT_old;
  rhoLT{kinds_old + 1}             = cell(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      rhoLT{kinds_old + 1}{k1, k2} = package_rhoLTEA_each_kind(hist_edges{1}{k1, k2}, ...
                                     hist_edges{2}{k1, k2}, hist_binwidths{1}{k1, k2}, ...
                                     hist_binwidths{2}{k1, k2}, hist_counts{kinds_old + 1}{k1, k2});
    end
  end
end
end