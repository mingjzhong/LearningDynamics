function basis_info = get_basis_info(learn_info, type)
% function basis_info = get_basis_info(learn_info, type)

% (C) M. Zhong

basis_info     = [];
switch type
  case 'energy'
    basis_info = learn_info.Ebasis_info;
  case 'alignment'
    basis_info = learn_info.Abasis_info;
  case 'xi'
    basis_info = learn_info.Xibasis_info;
  otherwise
    error('');
end
end