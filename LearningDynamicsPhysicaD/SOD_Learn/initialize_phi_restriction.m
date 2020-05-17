function phi_rest = initialize_phi_restriction(sys_info, is_rhoLT)
% function phi_res = initialize_phi_restriction(sys_info, is_rhoLT)

% (C) M. Zhong (JHU)
                      
if is_rhoLT
  phi_rest               = [];
else
  [num_kinds, kind_name] = get_phi_kinds(sys_info);
  phi_rest               = cell(1, num_kinds);
  for ind = 1 : num_kinds
    phi_rest{ind}        = initialize_phi_restriction_each_kind(kind_name{ind}, sys_info);
  end
end
end