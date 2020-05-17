function legend_name = get_legend_name_for_rhos(sys_info, plot_info, type, k1, k2)
% function legend_name = get_legend_name_for_rhos(sys_info, plot_info, type, k1, k2)

% (c) M. Zhong (JHU)

if sys_info.K > 1
  type_indicator = sprintf(', %d%d', k1, k2);
else 
  type_indicator = [];
end
switch type
  case 'rhoLT'
    switch plot_info.rho_type
      case 'energy'
        if sys_info.ode_order == 1, legend_name = ['$\rho_T^{L' type_indicator '}$']; 
        else, legend_name = ['$\rho_{T, r}^{L' type_indicator '}$']; end
      case 'alignment'
        legend_name               = ['$\rho_{T, \dot{r}}^{L' type_indicator '}$'];
      case 'xi'
        legend_name               = ['$\rho_{T, \xi}^{L' type_indicator '}$'];
      otherwise
    end  
  case 'rhoLTM'
    switch plot_info.rho_type
      case 'energy'
        if sys_info.ode_order == 1, legend_name = ['$\rho_T^{L, M' type_indicator '}$']; 
        else, legend_name = ['$\rho_{T, r}^{L, M' type_indicator '}$']; end
      case 'alignment'
        legend_name               = ['$\rho_{T, \dot{r}}^{L, M' type_indicator '}$'];
      case 'xi'
        legend_name               = ['$\rho_{T, \xi}^{L, M' type_indicator '}$'];
      otherwise
    end     
  otherwise
end
end