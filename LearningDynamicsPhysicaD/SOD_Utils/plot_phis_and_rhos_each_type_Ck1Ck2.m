function plot_phis_and_rhos_each_type_Ck1Ck2(fig_handle, axis_handle, range, rhoLT, rhoLTM, phi, ...
         phihats, phihatsmooths, k1, k2, sys_info, plot_info)
% function plot_phis_and_rhos_each_type_Ck1Ck2(fig_handle, axis_handle, range, rhoLT, rhoLTM, phi, ...
% phihats, phihatsmooths, phihatregs, k1, k2, sys_info, plot_info)

% (c) M. Zhong (JHU)

switch size(range, 1)
  case 1
    plot_phis_and_rhos_each_type_Ck1Ck2_1D(fig_handle, axis_handle, range, rhoLT, rhoLTM, phi, ...
      phihats, phihatsmooths, k1, k2, sys_info, plot_info);
  case 2
    plot_phis_and_rhos_each_type_Ck1Ck2_2D(fig_handle, axis_handle, range, phi, phihats, ...
      phihatsmooths, k1, k2, sys_info, plot_info);
  otherwise
    error('');
end
end