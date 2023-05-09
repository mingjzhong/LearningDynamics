function rho_dim = get_rho_dim_each_kind(kind, sys_info)
% function rho_dim = get_rho_dim_each_kind(kind, sys_info)

% (C) M. Zhong

% find the dimension of rho based on kind
rho_dim         = [];                
switch kind
  case 'energy'
    if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
      if isfield(sys_info, 'projE') && ~isempty(sys_info.projE)
        rho_dim = 1 + cellfun(@(x) length(x), sys_info.projE);
      else
        rho_dim = ones(sys_info.K); % r is always present
      end
    end
  case 'alignment'  
    if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
      if isfield(sys_info, 'projA') && ~isempty(sys_info.projA)
        rho_dim = 1 + cellfun(@(x) length(x), sys_info.projE);
      else
        rho_dim = ones(sys_info.K); % r is always present
      end
      rho_dim   = rho_dim + 1;
    end    
  case 'xi'
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      if isfield(sys_info, 'projXi') && ~isempty(sys_info.projXi)
        rho_dim = 1 + cellfun(@(x) length(x), sys_info.projE);
      else
        rho_dim = ones(sys_info.K); % r is always present
      end
      if ~isfield(sys_info, 'phiXi_weight') || isempty(sys_info.phiXi_weight) ...
            || sys_info.phiXi_weight
        rho_dim = rho_dim + 1;
      end
    end      
  otherwise
    error('SOD_Learn:get_rho_dim_each_kind:exception', ...
      'Only energy, alignment and xi kinds are supported!!');
end
end