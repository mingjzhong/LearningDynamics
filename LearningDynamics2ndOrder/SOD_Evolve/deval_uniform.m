function [yint, ypint] = deval_uniform(sol, tint)
% function [yint, ypint] = deval_uniform(sol, tint)

% (C) M. Zhong (JHU)

validateattributes(tint, {'numeric'}, {'row', 'increasing', 'nonnegative'});
yint                     = zeros(size(sol.y, 1), length(tint));
ypint                    = zeros(size(sol.y, 1), length(tint));
ode_fun                  = sol.extdata.odefun;
order                    = sol.extdata.options.order;
degree                   = sol.extdata.options.degree;
h                        = sol.extdata.options.h;
for t_idx = 1 : length(tint)
  t                      = tint(t_idx);
  ind                    = find(sol.x >= t, 1);
  if ~isempty(ind)
    if sol.x(ind) == t
      yint(:, t_idx)     = sol.y(:, ind); 
      ypint(:, t_idx)    = ode_fun(t, sol.y(:, ind)); 
    else      
      if contains(sol.solver, 'rk')   
        theta            = t - sol.x(ind - 1);
        yint(:, t_idx)   = single_rk_step_dense(sol.x(ind - 1), sol.y(:, ind - 1), h, ode_fun, ...
                           order, theta, degree);
        if contains(sol.solver, 'gni')
          yint(:, t_idx) = sol.extdata.options.sys_info.manifold_projection(yint(:, t_idx));
        end                         
      elseif contains(sol.solver, 'bd')
        if ind < order + 1
          t_ind          = ind : -1 : 1;
        else
          t_ind          = ind : -1 : (ind - order);
        end
        yint(:, t_idx)   = single_bdf_step_dense(sol.x(t_ind), sol.y(:, t_ind), t);
        if contains(sol.solver, 'gni')
          yint(:, t_idx) = sol.extdata.options.sys_info.manifold_projection(yint(:, t_idx));
        end
      end
      ypint(:, t_idx)    = ode_fun(t, yint(:, t_idx));
    end
  else
    error('');  
  end
end
end
