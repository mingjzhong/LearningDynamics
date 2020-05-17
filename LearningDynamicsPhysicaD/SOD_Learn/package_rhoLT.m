function rhoLT = package_rhoLT(hist_edges, hist_binwidths, hist_counts, sys_info, rho_range)
% function rhoLT = package_rhoLT(hist_edges, hist_binwidths, hist_counts, sys_info, rho_range)

% (c) M. Zhong (JHU)

[num_kinds, kind_name]     = get_phi_kinds(sys_info);
rhoLT                      = cell(1, num_kinds);
for ind = 1 : num_kinds
  if ~isempty(rho_range{ind})
    rhoLT{ind}             = cell(sys_info.K);
    for k1 = 1 : sys_info.K
      for k2 = 1 : sys_info.K
        rhoLT{ind}{k1, k2} = package_rhoLT_each_kind(hist_edges{ind}{k1, k2}, ...
          hist_binwidths{ind}{k1, k2}, hist_counts{ind}{k1, k2}, sys_info, rho_range{ind}{k1, k2}, ...
          kind_name{ind});
      end
    end
  end
end

end