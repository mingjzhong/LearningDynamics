function traj_dist = traj_norm(y1, y2, sys_info, agent_info)
% traj_dist = traj_norm(y1, y2, sys_info, agent_info)

% (c) M. Zhong (JHU)

L                         = size(y1, 2);
if isfield(sys_info, 'on_manifold') && sys_info.on_manifold && sys_info.ode_order == 1              % first-order dynamics on manifold only
  traj_dist               = zeros(sys_info.N, L);
  for l = 1 : L
    traj_dist(:, l)       = sys_info.geodesic_dist_mat(y1(:, l), y2(:, l)).^2;
  end
  Nk_mat                  = get_Nk_mat(1./agent_info.Nks, sys_info.N, 1);
  traj_dist               = Nk_mat * traj_dist;
  traj_dist               = sum(traj_dist).^(0.5);
else
  num_states              = calculate_sys_states(sys_info);
  traj_dist               = zeros(num_states, L);
  [x1, v1, xi1]           = split_y_or_dy(y1, sys_info);
  [x2, v2, xi2]           = split_y_or_dy(y2, sys_info);
  Nk_mat                  = get_Nk_mat(1./agent_info.Nks, sys_info.N, 1);
  if ~isempty(xi1)
    xi1                   = Nk_mat * xi1;
    xi2                   = Nk_mat * xi2;
  end
  Nk_mat                  = get_Nk_mat(1./agent_info.Nks, sys_info.N, sys_info.d);
  x1                      = Nk_mat * x1;
  x2                      = Nk_mat * x2;
  if ~isempty(v1)
    v1                    = Nk_mat * v1;
    v2                    = Nk_mat * v2;
  end
  traj_dist(1, :)         = sum((x1 - x2).^2).^(0.5);
  x1_norm                 = sum(x1.^2).^(0.5);
  ind                     = x1_norm ~= 0;
  traj_dist(1, ind)       = traj_dist(1, ind) ./ x1_norm(ind);
  if ~isempty(v1)
    traj_dist(2, :)       = sum((v1 - v2).^2).^(0.5);
    v1_norm               = sum(v1.^2).^(0.5);
    ind                   = v1_norm ~= 0;
    traj_dist(2, ind)     = traj_dist(2, ind) ./ v1_norm(ind);
  end
  if ~isempty(xi1)
    if sys_info.ode_order == 1
      idx                 = 2;
    elseif sys_info.ode_order == 2
      idx                 = 3;
    end
    traj_dist(idx, :)     = sum((xi1 - xi2).^2).^(0.5);
    xi1_norm              = sum(xi1.^2).^(0.5);
    ind                   = xi1_norm ~= 0;
    traj_dist(idx, ind)   = traj_dist(idx, ind) ./ xi1_norm(ind);                                            
  end
  if sys_info.ode_order == 1
    if ~isempty(xi1)
      y1_norm             = sqrt(x1_norm.^2 + xi1_norm.^2);
      traj_dist(end, :)   = sqrt(traj_dist(1, :).^2 + traj_dist(2, :).^2);
      ind                 = y1_norm ~= 0;
      traj_dist(end, ind) = traj_dist(end, ind) ./ y1_norm(ind);
    end
  elseif sys_info.ode_order == 2
    if ~isempty(xi1)
      y1_norm             = sqrt(x1_norm.^2 + v1_norm.^2 + xi1_norm.^2);
      traj_dist(end, :)   = sqrt(traj_dist(1, :).^2 + traj_dist(2, :).^2 + traj_dist(3, :).^2);
    else
      y1_norm             = sqrt(x1_norm.^2 + v1_norm.^2);
      traj_dist(end, :)   = sqrt(traj_dist(1, :).^2 + traj_dist(2, :).^2);    
    end
    ind                   = y1_norm ~= 0;
    traj_dist(end, ind)   = traj_dist(end, ind) ./ y1_norm(ind);
  end  
end
traj_dist                 = max(traj_dist, [], 2);                                                  % maximum over time
end