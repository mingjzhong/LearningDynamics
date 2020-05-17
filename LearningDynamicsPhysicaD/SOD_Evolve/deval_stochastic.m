function [yint, ypint] = deval_stochastic(sol, tint)
% function [yint, ypint] = deval_stochastic(sol, tint)

% (C) M. Zhong (JHU)

validateattributes(tint, {'numeric'}, {'row', 'increasing', 'nonnegative'});
yint  = zeros(size(sol.y, 1), length(tint));
ypint = zeros(size(sol.y, 1), length(tint));
for t_idx = 1 : length(tint)
  t   = tint(t_idx);
  ind = find(sol.x >= t, 1);
  if ~isempty(ind)
    if sol.x(ind) == t, yint(:, t_idx) = sol.y(:, ind); ypint(:, t_idx) = sol.extdata.odefun(t, sol.y(:, ind)); 
    else 
      theta          = t - sol.x(ind - 1);
      h              = sol.extdata.options.h;
      ode_fun        = sol.extdata.odefun;
      stage          = sol.extdata.options.stage;
      order          = sol.extdata.options.order;
      degree         = sol.extdata.options.degree;
      yint(:, t_idx) = single_rk_step_dense(sol.x(ind - 1), sol.y(:, ind - 1), h, ode_fun, stage, order, theta, degree);
    end
  else
    error('');  
  end
end
end
