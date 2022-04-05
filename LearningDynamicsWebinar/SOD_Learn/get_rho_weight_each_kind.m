function rho_weight = get_rho_weight_each_kind(v, xi, agent_info, sys_info, kind)
% function rho_weight = get_rho_weight_each_kind(v, xi, agent_info, sys_info, kind)

% (C) M. Zhong

weight_ij              = [];
switch kind
  case 'energy'
    weight_ij          = [];
  case 'alignment'
    if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
      weight_ij        = sqrt(abs(sqdist_mod(v)));
    end
  case 'xi'
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi) 
      if ~isfield(sys_info, 'phiXi_weight') || isempty(sys_info.phiXi_weight) ...
          || sys_info.phiXi_weight
        weight_ij      = sqrt(abs(sqdist_mod(xi)));
      end
    end
  otherwise
    error('SOD_Learn:get_rho_weight_each_kind:exception', ...
      'Only energy, alignment, or xi type is supported!!');
end
if ~isempty(weight_ij)
  rho_weight             = cell(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      rho_weight{k1, k2} = weight_ij(agent_info.idxs{k1}, agent_info.idxs{k2});
    end
  end
else
  rho_weight             = [];
end
end