function phi_weight = get_phi_weight_each_kind(x, v, xi, kind, sys_info)
% function phi_weight = get_phi_weight_each_kind(x, v, xi, kind, sys_info)

% (C) M. Zhong

% do it according to is_rhoLT
phi_weight           = [];
switch kind
  case 'energy'
    if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
      phi_weight   = get_weight_direction(x, sys_info); 
    end      
  case 'alignment'
    if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
      phi_weight   = get_pair_diff(v);
    end         
  case 'xi'
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      if ~isfield(sys_info, 'phiXi_weight') || isempty(sys_info.phiXi_weight) ...
          || sys_info.phiXi_weight
        phi_weight = get_pair_diff(xi); 
      end
    end      
  otherwise
    error('');
end
end