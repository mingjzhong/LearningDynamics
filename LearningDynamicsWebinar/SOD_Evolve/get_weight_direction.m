function phi_weight = get_weight_direction(x, sys_info)
%

% (C) M. Zhong

if isfield(sys_info, 'on_manifold') && sys_info.on_manifold
  phi_weight = sys_info.weight_on_manifold(x);
else
  phi_weight = get_pair_diff(x);  
end
end