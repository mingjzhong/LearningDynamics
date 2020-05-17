function [x, v, xi, dot_xv, dot_xi] = split_observation(obs_data, obs_info, sys_info, is_rhoLT)
% function [x, v, xi, dot_xv, dot_xi] = split_observation(obs_data, obs_info, sys_info, is_rhoLT)

% (C) M. Zhong (JHU)

if nargin < 4, is_rhoLT = true; end
one_block         = sys_info.d * sys_info.N;
v                 = []; 
xi                = []; 
dot_xi            = []; 
dot_xv            = [];
x                 = obs_data.y(1 : one_block, :, :);                                                % find out the position of the agents
if sys_info.ode_order == 1
  if ~is_rhoLT
    if obs_info.use_derivative
      dot_xv      = obs_data.dy(1 : one_block, :, :);
    else
      dot_xv      = approximate_derivative(x, obs_info.time_vec, 1);
    end
  end
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    xi            = obs_data.y(one_block + 1 : one_block + sys_info.N, :, :);
    if ~is_rhoLT
      if obs_info.use_derivative
        dot_xi    = obs_data.dy(one_block + 1 : one_block + sys_info.N, :, :); 
      else
        dot_xi    = approximate_derivative(xi, obs_info.time_vec, 1);
      end
    end
  end
elseif sys_info.ode_order == 2
  if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
    total_size    = 2 * one_block + sys_info.N;
  else
    total_size    = 2 * one_block;
  end
  if size(obs_data.y, 1) < total_size
    v             = approximate_derivative(x, obs_info.time_vec, 1);
    if ~is_rhoLT
      dot_xv      = approximate_derivative(x, obs_info.time_vec, 2);
    end
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      xi          = obs_data.y(one_block + 1 : one_block + sys_info.N, :, :);
      if ~is_rhoLT
        if obs_info.use_derivative
          dot_xi  = obs_data.dy(one_block + 1 : one_block + sys_info.N, :, :);
        else
          dot_xi  = approximate_derivative(xi, obs_info.time_vec, 1);
        end
      end
    end
  else
    v             = obs_data.y(one_block + 1 : 2 * one_block, :, :);
    if ~is_rhoLT
      if obs_info.use_derivative
        dot_xv    = obs_data.dy(one_block + 1 : 2 * one_block, :, :);
      else
        dot_xv    = approximate_derivative(v, time_vec, 1);
      end
    end
    if isfield(sys_info, 'phiXi') && ~isempty(sys_info.phiXi)
      xi          = obs_data.y(2 * one_block + 1 : 2 * one_block + sys_info.N, :, :);
      if ~is_rhoLT
        if obs_info.use_derivative
          dot_xi  = obs_data.dy(2 * one_block + 1 : 2 * one_block + sys_info.N, :, :);
        else
          dot_xi  = approximate_derivative(xi, obs_info.time_vec, 1);
        end
      end
    end    
  end
end
end