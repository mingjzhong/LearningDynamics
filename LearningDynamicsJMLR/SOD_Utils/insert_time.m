function [first_traj, first_time, second_traj, second_time] = insert_time(dynamics, T)
%
%

% Ming Zhong
% Postdoc Research at JHU

% find out the time instances when the ODE integration is made
time_vec      = dynamics.x;
% find out the corresponding trajectory
traj          = dynamics.y;
% find out the first time, t_0, such that t_0 >= T
ind           = find(time_vec >= T, 1);
% check to see if we need to insert T
if time_vec(ind) == T
% T is already saved in time_vec: the first half of the time and trajectory: [0, T]  
  first_traj  = traj(:, 1 : ind);
  first_time  = time_vec(1 : ind);
% the second half of the time and trajectory: [T, T_f]
  second_traj = traj(:, ind : end);
  second_time = time_vec(ind : end);
else
% now we have to insert T, find out what the dynamics is at time T
  traj_at_T   = deval(dynamics, T);
% find out the first half: [0, T]
  first_time  = [time_vec(1 : (ind - 1)), T];
  first_traj  = [traj(:, 1 : (ind - 1)), traj_at_T];
% find out the second half: [T, T_f]
  second_time = [T, time_vec(ind : end)];
  second_traj = [traj_at_T, traj(:, ind : end)];
end
end