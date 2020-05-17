function traj_dist = traj_norm(traj_1, traj_2, sys_info, agent_info)
% traj_dist = traj_norm(traj_1, traj_2, sys_info, agent_info)

% (c) M. Zhong (JHU)

num_states            = calculate_sys_states(sys_info);
L                     = size(traj_1, 2);
traj_dist             = zeros(num_states, L);
[x1, v1, xi1]         = split_traj(traj_1, sys_info);
[x2, v2, xi2]         = split_traj(traj_2, sys_info);
Nk_mat                = get_Nk_mat(agent_info.Nks, sys_info.N, 1);
if ~isempty(xi1)
  xi1                 = Nk_mat * xi1;
  xi2                 = Nk_mat * xi2;
end
Nk_mat                = get_Nk_mat(agent_info.Nks, sys_info.N, sys_info.d);
x1                    = Nk_mat * x1;
x2                    = Nk_mat * x2;
if ~isempty(v1)
  v1                  = Nk_mat * v1;
  v2                  = Nk_mat * v2;
end
traj_dist(1, :)       = sum((x1 - x2).^2).^(0.5);
x1                    = sum(x1.^2).^(0.5);
ind                   = x1 ~= 0;
traj_dist(1, ind)     = traj_dist(1, ind) ./ x1(ind);
if ~isempty(v1)
  traj_dist(2, :)     = sum((v1 - v2).^2).^(0.5);
  v1                  = sum(v1.^2).^(0.5);
  ind                 = v1 ~= 0;
  traj_dist(2, ind)   = traj_dist(2, ind) ./ v1(ind);
end
if ~isempty(xi1)
  if sys_info.ode_order == 1
    idx               = 2;
  elseif sys_info.ode_order == 2
    idx               = 3;
  end
  traj_dist(idx, :)   = sum((xi1 - xi2).^2).^(0.5);
  xi1                 = sum(xi1.^2).^(0.5);
  ind                 = xi1 ~= 0;
  traj_dist(idx, ind) = traj_dist(idx, ind) ./ xi1(ind);                                            
end
traj_dist             = max(traj_dist, [], 2);                                                      % maximum over time
end