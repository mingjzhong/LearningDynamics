function Psi_kind = get_Psi_kind(ind, sys_info)
% function Psi_kind = get_Psi_kind(ind, sys_info)

% (C) M. Zhong

if sys_info.ode_order == 1
  if ind == 1
    Psi_kind = 1;
  elseif ind == 2
    Psi_kind = 2;
  end
elseif sys_info.ode_order == 2
  if ind == 1
    Psi_kind = 1;
  elseif ind == 2
    Psi_kind = 1;
  elseif ind == 3
    Psi_kind = 2;
  end  
end
end