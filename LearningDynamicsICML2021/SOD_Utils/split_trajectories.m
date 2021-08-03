function [X_coords, the_mins, the_maxs] = split_trajectories(trajs, sys_info, sys_info_Ntransfer)
% function [X_coords, the_mins, the_maxs] = split_trajectories(trajs, sys_info, sys_info_Ntransfer)

% (C) M. Zhong
X_coords                 = cell(length(trajs),  sys_info.d);
the_mins                 = zeros(length(trajs), sys_info.d);
the_maxs                 = zeros(length(trajs), sys_info.d);
for ind = 1 : length(trajs)
  traj                   = trajs{ind};
  if ind >= 1 && ind <= 4
    N                    = sys_info.N;
  else
    N                    = sys_info_Ntransfer.N;
  end
  for d_ind = 1 : sys_info.d
    X_cd                 = traj(d_ind : sys_info.d : (N - 1) * sys_info.d + d_ind, :);
    the_mins(ind, d_ind) = min(X_cd(:));
    the_maxs(ind, d_ind) = max(X_cd(:));
    X_coords{ind, d_ind} = X_cd;
  end
end