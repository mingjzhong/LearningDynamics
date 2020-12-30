function [first_traj, first_time, second_traj, second_time] = split_traj(dynamics, T)
% [first_traj, first_time, second_traj, second_time] = split_traj(dynamics, T)

% Ming Zhong
% Postdoc Research at JHU

% find out the time instances when the ODE integration is made
time_vec      = dynamics.x;
% find out the corresponding trajectory
traj          = dynamics.y;
% find out the trajectory in [0, T]
ind           = find(time_vec <= T);
% prepare the storage
first_traj    = traj(:, ind);
first_time    = time_vec(ind);
% find out the trajectory in [T, 2T];
ind           = find(time_vec >= T);
second_traj   = traj(:, ind);
second_time   = time_vec(ind);
end