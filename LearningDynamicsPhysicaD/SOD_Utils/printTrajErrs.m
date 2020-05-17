function printTrajErrs(obs_info, solver_info, x_mean, x_std, v_mean, v_std, xi_mean, xi_std, type)
% function printTrajErrs(obs_info, solver_info, x_mean, x_std, v_mean, v_std, xi_mean, xi_std, type)

% (C) M. Zhong (JHU)

if solver_info.time_span(2) >= 3 * obs_info.T
  T_mid                                       = 2 * obs_info.T;
else
  T_mid                                       = (solver_info.time_span(2) + obs_info.T)/2;
end
fprintf(['\n------------------- Relative Trajectory Errors, ' , type, ':']);
err_kind                                      = size(x_mean, 1);
for idx = 1 : err_kind
  switch idx
    case 1
      fprintf('\n\tsup-norm  on [T_0, T] with T_0 = %10.4e and T = %10.4e:', obs_info.time_vec(1), obs_info.T); 
    case 2
      fprintf('\n\tsup-norm  on [T, %0.1fT]:', T_mid/obs_info.T);
    case 3
      fprintf('\n\tsup-norm  on [T, %0.1fT]:', solver_info.time_span(2)/obs_info.T);
    otherwise
      error('');
  end
  fprintf('\n\t\tFor  x: mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e.', ...
    mean(x_mean(idx, :)), 177, std(x_mean(idx, :)), mean(x_std(idx, :)), 177, std(x_std(idx, :)));  
  if ~isempty(v_mean)
    fprintf('\n\t\tFor  v: mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e.', ...
      mean(v_mean(idx, :)), 177, std(v_mean(idx, :)), mean(v_std(idx, :)), 177, std(v_std(idx, :)));
  end  
  if ~isempty(xi_mean)
    fprintf('\n\t\tFor xi: mean = %10.4e%c%10.4e, std = %10.4e%c%10.4e.', ...
      mean(xi_mean(idx, :)), 177, std(xi_mean(idx, :)), mean(xi_std(idx, :)), 177, std(xi_std(idx, :)));
  end  
end
end