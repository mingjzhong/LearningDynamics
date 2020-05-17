function rho_weight = get_rho_weight_each_kind(v, xi, agent_info, sys_info, learn_info, is_rhoLT, kind)
% function rho_weight = get_rho_weight_each_kind(v, xi, agent_info, sys_info, learn_info, is_rhoLT, kind)

% (C) M. Zhong

weight_ij                = [];
switch kind
  case 'energy'
    weight_ij            = [];
  case 'alignment'
    if is_rhoLT
      if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
        weight_ij        = sqrt(abs(sqdist_mod(v)));
      end
    else
      if isfield(learn_info, 'Abasis_info') && ~isempty(learn_info.Abasis_info)
        weight_ij        = sqrt(abs(sqdist_mod(v)));
      end      
    end
  case 'xi'
    if is_rhoLT
      if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi) 
        if ~isfield(sys_info, 'phiXi_weight') || isempty(sys_info.phiXi_weight) || sys_info.phiXi_weight
          weight_ij      = sqrt(abs(sqdist_mod(xi)));
        end
      end
    else
      if isfield(learn_info, 'Xibasis_info') && ~isempty(learn_info.Xibasis_info)
        if ~isfield(sys_info, 'phiXi_weight') || isempty(sys_info.phiXi_weight) || sys_info.phiXi_weight
          weight_ij      = sqrt(abs(sqdist_mod(xi)));
        end
      end      
    end 
  otherwise
    error('');
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