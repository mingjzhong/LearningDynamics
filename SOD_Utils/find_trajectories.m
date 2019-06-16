function [traj, time_vec] = find_trajectories(solution, T)
%
%

%
%

%
whole_time              = solution.x;
%
whole_traj              = solution.y;
% find out the first index that the time >= T
ind                     = find(whole_time >= T, 1);
% and let us check to see if we need interpolation
the_t                   = whole_time(ind);
if the_t == T
% if T is already included in whole_time, we dont need any interpolation
  traj                  = whole_traj(:, 1 : ind);
  time_vec              = whole_time(1 : ind);
else
% if T is not included in whole_time
% pre-allocate memory
  traj                  = zeros(size(whole_traj, 1), ind);
  time_vec              = zeros(1, ind);
% take those already calculated
  traj(:, 1 : ind - 1)  = whole_traj(:, 1 : ind - 1);
  time_vec(1 : ind - 1) = whole_time(1 : ind - 1);
% now interpolate the solution at T
  traj(:, ind)          = deval(solution, T);
  time_vec(ind)         = T;
end
end