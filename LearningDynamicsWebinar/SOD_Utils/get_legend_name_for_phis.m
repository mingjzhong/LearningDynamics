function legend_name = get_legend_name_for_phis(sys_info, plot_info, type, k1, k2)
% function legend_name = get_legend_name_for_phis(sys_info, plot_info, type, k1, k2)

% (c) M. Zhong (JHU)

if sys_info.K > 1
  type_indicator = sprintf('_{%d%d}', k1, k2);
else 
  type_indicator = [];
end

switch type
  case 'phi'
    switch plot_info.phi_type
      case 'energy'
        if sys_info.ode_order == 1, legend_name = ['$\phi' type_indicator '$']; 
        else, legend_name = ['$\phi^E' type_indicator '$']; end
        if isfield(plot_info, 'phi_name') && ~isempty(plot_info.phi_name)
          legend_name             = plot_info.phi_name;
        end
      case 'alignment'
        legend_name               = ['$\phi^A' type_indicator '$'];
      case 'xi'
        legend_name               = ['$\phi^{\xi}' type_indicator '$'];
      otherwise
    end    
  case 'phihat'
    switch plot_info.phi_type
      case 'energy'
        if sys_info.ode_order == 1, legend_name = ['$\hat\phi' type_indicator '$']; 
        else, legend_name = ['$\hat\phi^E' type_indicator '$']; end
      case 'alignment'
        legend_name               = ['$\hat\phi^A' type_indicator '$'];
      case 'xi'
        legend_name               = ['$\hat\phi^{\xi}' type_indicator '$'];
      otherwise
    end     
%   case 'phihatsmooth'
%     switch plot_info.phi_type
%       case 'energy'
%         if sys_info.ode_order == 1, legend_name = ['$\phi^{Int}' type_indicator '$']; 
%         else, legend_name = ['$\phi^{E, Int}' type_indicator '$']; end
%       case 'alignment'
%         legend_name               = ['$\phi^{A, Int}' type_indicator '$'];
%       case 'xi'
%         legend_name               = ['$\phi^{\xi, Int}' type_indicator '$'];
%       otherwise
%     end     
  otherwise
end
end