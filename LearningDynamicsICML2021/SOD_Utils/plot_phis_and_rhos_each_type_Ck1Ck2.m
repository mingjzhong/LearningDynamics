function plot_phis_and_rhos_each_type_Ck1Ck2(fig_handle, axis_handle, supp, rhoLT, rhoLTM, phi, ...
         phihats, k1, k2, sys_info, plot_info)
% function plot_phis_and_rhos_each_type_Ck1Ck2(fig_handle, axis_handle, supp, rhoLT, rhoLTM, phi, ...
% phihats, k1, k2, sys_info, plot_info)

% (c) M. Zhong (JHU)

switch size(supp, 1)
  case 1
    plot_phis_and_rhos_each_type_Ck1Ck2_1D(fig_handle, axis_handle, supp, rhoLT, rhoLTM, phi, ...
      phihats, k1, k2, sys_info, plot_info);
  case 2
    plot_phis_and_rhos_each_type_Ck1Ck2_2D(fig_handle, axis_handle, supp, phi, phihats, ...
      k1, k2, sys_info, plot_info);
  otherwise
    error('');
end
end