function [x_mean, x_std, v_mean, v_std, xi_mean, xi_std] = getTrajErrStat(trajErrs, sys_info)
% function [x_mean, x_std, v_mean, v_std, xi_mean, xi_std] = getTrajErrStat(trajErrs, sys_info)

% (C) M. Zhong (JHU)

x_mean            = zeros(3, length(trajErrs));
x_std             = zeros(3, length(trajErrs));
x_mean(1, :)      = cellfun(@(x) mean(x.sup(1, :)),     trajErrs);
x_std(1, :)       = cellfun(@(x)  std(x.sup(1, :)),     trajErrs);
x_mean(2, :)      = cellfun(@(x) mean(x.sup_mid(1, :)), trajErrs);
x_std(2, :)       = cellfun(@(x)  std(x.sup_mid(1, :)), trajErrs);
x_mean(3, :)      = cellfun(@(x) mean(x.sup_fut(1, :)), trajErrs);
x_std(3, :)       = cellfun(@(x)  std(x.sup_fut(1, :)), trajErrs);
if sys_info.ode_order == 1
  v_mean = []; v_std = [];
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    xi_mean       = zeros(3, length(trajErrs));
    xi_std        = zeros(3, length(trajErrs));
    xi_mean(1, :) = cellfun(@(x) mean(x.sup(2, :)),     trajErrs);
    xi_std(1, :)  = cellfun(@(x)  std(x.sup(2, :)),     trajErrs);
    xi_mean(2, :) = cellfun(@(x) mean(x.sup_mid(2, :)), trajErrs);
    xi_std(2, :)  = cellfun(@(x)  std(x.sup_mid(2, :)), trajErrs);        
    xi_mean(3, :) = cellfun(@(x) mean(x.sup_fut(2, :)), trajErrs);
    xi_std(3, :)  = cellfun(@(x)  std(x.sup_fut(2, :)), trajErrs);    
  else
    xi_mean = []; xi_std = [];
  end
elseif sys_info.ode_order == 2
  v_mean          = zeros(3, length(trajErrs));
  v_std           = zeros(3, length(trajErrs));  
  v_mean(1, :)    = cellfun(@(x) mean(x.sup(2, :)),     trajErrs);
  v_std(1, :)     = cellfun(@(x)  std(x.sup(2, :)),     trajErrs);  
  v_mean(2, :)    = cellfun(@(x) mean(x.sup_mid(2, :)), trajErrs);
  v_std(2, :)     = cellfun(@(x)  std(x.sup_mid(2, :)), trajErrs);  
  v_mean(3, :)    = cellfun(@(x) mean(x.sup_fut(2, :)), trajErrs);
  v_std(3, :)     = cellfun(@(x)  std(x.sup_fut(2, :)), trajErrs);  
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    xi_mean       = zeros(3, length(trajErrs));
    xi_std        = zeros(3, length(trajErrs));    
    xi_mean(1, :) = cellfun(@(x) mean(x.sup(3, :)),     trajErrs);
    xi_std(1, :)  = cellfun(@(x)  std(x.sup(3, :)),     trajErrs);
    xi_mean(2, :) = cellfun(@(x) mean(x.sup_mid(3, :)), trajErrs);
    xi_std(2, :)  = cellfun(@(x)  std(x.sup_mid(3, :)), trajErrs);      
    xi_mean(3, :) = cellfun(@(x) mean(x.sup_fut(3, :)), trajErrs);
    xi_std(3, :)  = cellfun(@(x)  std(x.sup_fut(3, :)), trajErrs);    
  else
    xi_mean = []; xi_std = [];
  end  
end
end