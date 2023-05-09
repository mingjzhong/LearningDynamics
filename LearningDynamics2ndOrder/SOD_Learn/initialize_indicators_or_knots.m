function storage = initialize_indicators_or_knots(J, learn_info)
% function storage = initialize_indicators_or_knots(J, learn_info)

% (C) M. Zhong

num_kinds                  = get_phi_or_rho_kinds(learn_info.sys_info, 'phi');
storage                    = cell(1, num_kinds);
for idx = 1 : num_kinds
  storage{idx}             = cell(learn_info.sys_info.K);
  for k1 = 1 : learn_info.sys_info.K
    for k2 = 1 : learn_info.sys_info.K
      storage{idx}{k1, k2} = cell(1, J);
    end
  end
end
end