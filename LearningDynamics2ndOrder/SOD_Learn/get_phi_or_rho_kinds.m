function [num_kinds, kinds_names] = get_phi_or_rho_kinds(sys_info, type)
% function [num_kinds, kinds_names] = get_phi_or_rho_kinds(sys_info, type)

% (C) M. Zhong (JHU)

switch type
  case 'phi'
    if sys_info.ode_order == 1
      num_kinds             = 2;
    elseif sys_info.ode_order == 2
      num_kinds             = 3;
    end
    kinds_names             = cell(1, num_kinds);
    kind_idx                = 0;
    if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
      kind_idx              = kind_idx + 1;
      kinds_names{kind_idx} = 'energy';
    end
    if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
      kind_idx              = kind_idx + 1;
      kinds_names{kind_idx} = 'alignment';
    end
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      kind_idx              = kind_idx + 1;
      kinds_names{kind_idx} = 'xi';      
    end
    if kind_idx ==  0, error(''); end
    if kind_idx < num_kinds
      idx                   = (kind_idx + 1) : num_kinds;
      kinds_names(idx)      = [];
      num_kinds             = kind_idx;
    end
  case 'rho'  % should be different from phi, but stay the same for now
    if sys_info.ode_order == 1
      num_kinds  = 2;
    elseif sys_info.ode_order == 2
      num_kinds  = 3;
    end
    kinds_names             = cell(1, num_kinds);
    kind_idx                = 0;
    if isfield(sys_info, 'phiE') && ~isempty(sys_info.phiE)
      kind_idx              = kind_idx + 1;
      kinds_names{kind_idx} = 'energy';
    end
    if isfield(sys_info, 'phiA') && ~isempty(sys_info.phiA)
      kind_idx              = kind_idx + 1;
      kinds_names{kind_idx} = 'alignment';
    end
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      kind_idx              = kind_idx + 1;
      kinds_names{kind_idx} = 'xi';      
    end
    if kind_idx ==  0, error(''); end
    if kind_idx < num_kinds
      idx                   = (kind_idx + 1) : num_kinds;
      kinds_names(idx)      = [];
      num_kinds             = kind_idx;
    end    
  otherwise
    error('');
end
end