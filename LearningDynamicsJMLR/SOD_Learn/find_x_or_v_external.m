function external = find_x_or_v_external(x, v, xi, sys_info)
% external = find_x_or_v_external(x, v, xi, sys_info, learning_info)

% Ming Zhong
% Postdoc Research at JHU

% find out the size of the state vector
d                = sys_info.d;
% find out the number of agents
N                = sys_info.N;
% find out the number of time instances when observation is made
L                = size(v, 2);
% find out the order of the ODE in the system
ode_order        = sys_info.ode_order;
% prepare the storage
external         = zeros(size(x));
% which out which external (non-collective) influence function to use
if ode_order == 2
  v_external     = sys_info.Fv;
end
% go through in time
for l = 1 : L
% find out external influence based on the order of the ODE  
  if ode_order == 2
% second order on v and (possibly) xi (when there is xi)    
    v_at_t         = reshape(v(:, l), [d, N]);
    if ~isempty(xi)
      xi_at_t      = transpose(xi(:, l));
    else
      xi_at_t      = [];
    end    
    external(:, l) = v_external(v_at_t, xi_at_t);
  end
end
% change it into a big vector
external         = external(:);
end