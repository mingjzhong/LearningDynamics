function phi_map = get_phi_feature_map_each_kind_Ck1Ck2(states, sys_info, kind)
% function phi_map = get_phi_feature_map_each_kind_Ck1Ck2(states, sys_info, kind)

% (C) M. Zhong

feature_map       = @(state_i, state_j) default_feature_map(state_i, state_j);
switch kind
  case 'energy'
    if isfield(sys_info, 'phiE_feature') && ~isempty(sys_info.phiE_feature)
      feature_map = sys_info.phiE_feature;
    end
  case 'alignment'
    if isfield(sys_info, 'phiA_feature') && ~isempty(sys_info.phiA_feature)
      feature_map = sys_info.phiA_feature;
    end
  case 'xi'
    if isfield(sys_info, 'phiXi_feature') && ~isempty(sys_info.phiXi_feature)
      feature_map = sys_info.phiXi_feature;
    end
  otherwise
    error('');
end
phi_map           = feature_map(states{1}, states{2});
end
