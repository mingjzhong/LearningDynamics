function [Ebasis, Abasis, Xibasis] = uniform_basis_construct(Rs, sys_info, learn_info )
% function [Ebasis, Abasis, Xibasis] = construct_basis_uniform(Rs, sys_info, learn_info )

% (c) M. Zhong (JHU)

Ebasis = []; Abasis = []; Xibasis = [];

% Construct energy-based interaction basis
if ~isempty(learn_info.Ebasis_info)
  Ebasis   = uniform_basis_by_class(Rs, sys_info.K, learn_info.Ebasis_info);
end
% for second order system
if sys_info.ode_order == 2
% Construct alignment-based interaction basis
  if ~isempty(learn_info.Abasis_info)
    Abasis = uniform_basis_by_class(Rs, sys_info.K, learn_info.Abasis_info);
  end
% Construct xi-based interaction basis
  if sys_info.has_xi
    Xibasis = uniform_basis_by_class(Rs, sys_info.K, learn_info.Xibasis_info);
  end
end
