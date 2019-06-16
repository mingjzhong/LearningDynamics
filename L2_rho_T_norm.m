function L2rhoTnorm = L2_rho_T_norm( f, sys_info, rhoLT, basis, kind )
% function L2rhoTnorm = L2_rho_T_norm( f, sys_info, rhoLT, basis, kind )

% (c) M. Zhong

if ~iscell(f)
  g             = cell(sys_info.K);
  for k1 = 1 : sys_info.K
    for k2 = 1 : sys_info.K
      g{k1, k2} = f;
    end
  end
  f             = g; clear g;
end

switch kind
  case 'energy'
    rhoT = rhoLT.rhoLTE;
    
  case 'alignment'
    rhoT = rhoLT.rhoLTA;
    
  case 'xi'
    rhoT = rhoLT.rhoLTXi;
    
  otherwise
end

for k1 = 1 : sys_info.K
  for k2 = 1 : sys_info.K
    
  end
end
end