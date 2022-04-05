function new_sys_info = set_sys_info(sys_info, phiE, phiA, phiXi)
%

% (c) M. Zhong (JHU)

% re-package the structure
new_sys_info       = sys_info;
new_sys_info.phiE  = phiE;
new_sys_info.phiA  = phiA;
new_sys_info.phiXi = phiXi;
end