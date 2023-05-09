function traj_data = set_coarse_traj(trajs, dtrajs, phases, time_vec)
% function traj_data = set_coarse_traj(trajs, dtrajs, phases, time_vec)

% (C) M. Zhong

L                  = length(time_vec); % use only 1/10 of the original data
L_skip             = floor(L/10);
idx                = 1 : L_skip : L;
if idx(end) ~= L, idx = [idx, L]; end
traj_data.time_vec = time_vec(idx);
for traj_idx = 1 : length(trajs)
  trajs{traj_idx}  = trajs{traj_idx}(:, idx);
  dtrajs{traj_idx} = dtrajs{traj_idx}(:, idx);
  if ~isempty(phases), phases{traj_idx} = phases{traj_idx}(:, idx); end
end
traj_data.trajs    = trajs;
traj_data.dtrajs   = dtrajs;
traj_data.phases   = phases;
end