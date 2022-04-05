function phi_dim = get_phi_dim_each_kind(kind, sys_info)
% function phi_dim = get_phi_dim_each_kind(kind, sys_info)

% (C) M. Zhong

% find the dimension of phi based on kind
phi_dim           = [];       
switch kind
  case 'energy'
    if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
      if isfield(sys_info, 'projE') && ~isempty(sys_info.projE)
        phi_dim = 1 + cellfun(@(x) length(x), sys_info.projE);
      else
        phi_dim = ones(sys_info.K);        % r is always present
      end
    end
  case 'alignment'
    if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
      if isfield(sys_info, 'projA') && ~isempty(sys_info.projA)
        phi_dim = 1 + cellfun(@(x) length(x), sys_info.projA);
      else
        phi_dim = ones(sys_info.K);        % r is always present
      end
    end
  case 'xi'
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      if isfield(sys_info, 'projXi') && ~isempty(sys_info.projXi)
        phi_dim = 1 + cellfun(@(x) length(x), sys_info.projXi);
      else
        phi_dim = ones(sys_info.K);        % r is always present
      end
    end
  otherwise
    error('SOD_Learn:get_phi_dim_each_kind:exception', ...
      'Energy, alignment and xi are the only supported kinds!!');  
end
end