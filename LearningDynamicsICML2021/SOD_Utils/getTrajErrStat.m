function [x_mean, x_std, v_mean, v_std, xi_mean, xi_std, y_mean, y_std] ...
                      = getTrajErrStat(trajErrs, sys_info)
% function [x_mean, x_std, v_mean, v_std, xi_mean, xi_std, y_mean, y_std] ...
%                     = getTrajErrStat(trajErrs, sys_info)

% (C) M. Zhong (JHU)

[x_mean, x_std]       = getTrajErrStat_each_kind(1, trajErrs);
if sys_info.ode_order == 1
  v_mean              = []; 
  v_std               = [];
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    [xi_mean, xi_std] = getTrajErrStat_each_kind(2, trajErrs);
    [y_mean, y_std]   = getTrajErrStat_each_kind(3, trajErrs);
  else
    xi_mean           = [];
    xi_std            = [];
    y_mean            = [];
    y_std             = []; 
  end
elseif sys_info.ode_order == 2
  [v_mean, v_std]     = getTrajErrStat_each_kind(2, trajErrs);
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    [xi_mean, xi_std] = getTrajErrStat_each_kind(3, trajErrs); 
    [y_mean, y_std]   = getTrajErrStat_each_kind(4, trajErrs);
  else
    xi_mean           = []; 
    xi_std            = [];
    [y_mean, y_std]   = getTrajErrStat_each_kind(3, trajErrs);
  end  
end
end