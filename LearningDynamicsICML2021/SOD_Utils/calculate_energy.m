function total_energy = calculate_energy(traj, sys_info)
% function total_energy = calculate_energy(traj, sys_info)

% (C) M. Zhong

L                    = size(traj, 2);
total_energy         = zeros(sys_info.N - 1, L);
block                = sys_info.N * sys_info.d;
masses               = sys_info.known_mass(2 : sys_info.N);
if ~iscolumn(masses), masses = masses'; end
for l = 1 : L
  x                  = reshape(traj(1 : block, l),             [sys_info.d, sys_info.N]);
  v                  = reshape(traj(block + 1 : 2 * block, l), [sys_info.d, sys_info.N]);
  dist_to_sun        = pdist2(x(:, 2 : sys_info.N)', x(:, 1)');
  speedsq            = sum(v(:, 2 : sys_info.N).^2)';
  total_energy(:, l) = masses .* (-sys_info.G * sys_info.known_mass(1)./dist_to_sun + speedsq/2);
end
end