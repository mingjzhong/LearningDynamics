function [Fvec, FvecXi] = initialize_noncollective_forces(L, sys_info)
% function [Fvec, FvecXi] = initialize_noncollective_forces(L, sys_info)

% (C) M. Zhong

Fvec     = [];
FvecXi   = [];
if sys_info.ode_order == 1
  if isfield(sys_info, 'Fx') && ~isempty(sys_info.Fx)
    Fvec = zeros(sys_info.N * sys_info.d, L);
  end
else
  if isfield(sys_info, 'Fv') && ~isempty(sys_info.Fv)
    Fvec = zeros(sys_info.N * sys_info.d, L);
  end
end
if isfield(sys_info, 'Fxi') && ~isempty(sys_info.Fxi)
  FvecXi = zeros(sys_info.N, L);
end
end