function agent_err = compare_traj_agent_wise_JPL(traj1, traj2, N, d)
% function agent_err = compare_traj_agent_wise_JPL(traj1, traj2, N, d)

% (C) M. Zhong

agent_err      = zeros(N, size(traj1, 2));
agent_norm     = zeros(N, size(traj1, 2));
for idx = 1 : d
  ind          = idx : d : ((N - 1) * d + idx);
  agent_err    = agent_err + (traj1(ind, :) - traj2(ind, :)).^2;
  agent_norm   = agent_norm + traj1(ind, :).^2;
end
agent_err      = agent_err.^(0.5);
agent_norm     = agent_norm.^(0.5);
ind            = agent_norm ~= 0;
agent_err(ind) = agent_err(ind)./agent_norm(ind);
agent_err      = max(agent_err, [], 2);
end