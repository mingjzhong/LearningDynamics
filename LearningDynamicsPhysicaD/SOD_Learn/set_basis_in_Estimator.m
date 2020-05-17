function Estimator = set_basis_in_Estimator(basis, sys_info, Estimator)
% function Estimator = set_basis_in_Estimator(basis, sys_info, Estimator)

% (C) M. Zhong

Estimator.Ebasis    = basis{1};
if sys_info.ode_order == 1
  Estimator.Abasis  = [];
  Estimator.Xibasis = basis{2};
elseif sys_info.ode_order == 2
  Estimator.Abasis  = basis{2};
  Estimator.Xibasis = basis{3};
end
end