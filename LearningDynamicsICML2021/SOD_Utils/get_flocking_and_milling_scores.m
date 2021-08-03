function [I_flock, I_mill] = get_flocking_and_milling_scores(x, v, dv, sys_info)
% function [I_flock, I_mill] = get_flocking_and_milling_scores(x, v, dv, sys_info)

% (C) M. Zhong

switch sys_info.d
  case 2 
% from Physica D paper, State Transitions and the Continuum Limit for a 2D Interacting, 
% self-propelled particle system, on page 10
    v_l2_sum    = sum(sum(v.^2).^(0.5));
    I_flock     = norm(sum(v, 2))/v_l2_sum;   
    x_CM        = computeCenterOfMassQuantities(x, [], [], sys_info);
    if ~iscolumn(x_CM), x_CM = x_CM'; end
    ri          = x - repmat(x_CM, [1, sys_info.N]);
    ri_norm     = sum(ri.^2).^(0.5);
    vi_norm     = sum(v.^2).^(0.5);
    rivi_sum    = sum(ri_norm .* vi_norm);
    if sys_info.d == 2
      ri        = [ri; zeros(1, sys_info.N)];
      vi        = [v; zeros(1, sys_info.N)];
    end
    riXvi       = cross(ri, vi);
    riXvi_norm  = sum(riXvi.^2).^(0.5);
    I_mill      = sum(riXvi_norm)/rivi_sum;
  case 3
% from Physica E paper, swarming in viscous fluid, 2016, on page 043112-10
    [~, v_CM]   = computeCenterOfMassQuantities([], v, [], sys_info);
    v_norm      = sqrt(sys_info.alpha/sys_info.beta);
    v_diff      = v - repmat(v_CM, [1, sys_info.N]);
    I_flock     = 1 - sum(sum(v_diff.^2).^(0.5))/(sys_info.N * v_norm);   
    if isfield(sys_info, 'agent_mass') && ~isempty(sys_info.agent_mass)
      mass_vec  = sys_info.agent_mass;
    else
      mass_vec  = ones(1, sys_info.N);
    end
    if ~isrow(mass_vec), mass_vec = mass_vec'; end
    force       = dv .* repmat(mass_vec, [sys_info.d, 1]);
    v_hat       = normalized_matrix_of_vectors(v, sys_info.d);
    force_hat   = normalized_matrix_of_vectors(force, sys_info.d);
    omega       = cross(v_hat, force_hat);
    omega_i     = repmat(omega(:), [1, sys_info.N]);
    omega_j     = repmat(omega, [sys_info.N, 1]);
    for idx = 1 : sys_info.d
      ind       = idx : sys_info.d : (sys_info.N - 1) * sys_info.d + idx;
      if idx == 1
        I_mill  = omega_i(ind, :) .* omega_j(ind, :);
      else
        I_mill  = I_mill + omega_i(ind, :) .* omega_j(ind, :);
      end
    end
    ind         = logical(eye(sys_info.N));
    I_mill(ind) = 0;
    I_mill      = sum(I_mill, 2);
    I_mill      = sum(I_mill)/(sys_info.N * (sys_info.N - 1));      
  otherwise
    error('');
end
end