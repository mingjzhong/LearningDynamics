function basis_info = get_basis_info(learn_info, sys_info, ind)
% function basis_info = get_basis_info(learn_info, sys_info, ind)

% (C) M. Zhong

basis_info               = [];
switch ind
  case 1
    if isfield(learn_info, 'Ebasis_info') && ~isempty(learn_info.Ebasis_info)
      basis_info         = learn_info.Ebasis_info;
    end
  case 2
    if sys_info.ode_order == 1
      if isfield(learn_info, 'Xibasis_info') && ~isempty(learn_info.Xibasis_info)
        basis_info       = learn_info.Xibasis_info;
      end
    elseif sys_info.ode_order == 2
      if isfield(learn_info, 'Abasis_info') && ~isempty(learn_info.Abasis_info)
        basis_info       = learn_info.Abasis_info;
      end      
    end
  case 3
    if isfield(learn_info, 'Xibasis_info') && ~isempty(learn_info.Xibasis_info)
      basis_info         = learn_info.Xibasis_info;
    end    
  otherwise
    error('');
end
end