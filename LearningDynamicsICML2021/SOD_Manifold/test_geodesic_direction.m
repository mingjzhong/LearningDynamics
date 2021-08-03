function test_geodesic_direction()
% function test_geodesic_direction()

% (C) M. Zhong

d            = 2;
N            = 20;
r            = 0.65;
xi           = uniform_dist(d, 5 * N, 'disk', r);
% same point, points on the opposite side (smaller), on the opposite side (same length), on the
% opposite side (larger), another random point (probably not on the opposite side)
xj           = [xi(:, 1 : N), -0.8 * xi(:, N + 1 : 2 * N), -xi(:, 2 * N + 1 : 3 * N), ...
                -1.1 * xi(:, 3 * N + 1: 4 * N), uniform_dist(d, N, 'disk', r)];
theta        = linspace(0, 2 * pi, 501);
figure;
for idx = 1 : size(xi, 2)
  plot(0, 0, 'ko');
  hold on;
  plot(xi(1, idx), xi(2, idx), 'rd');
  plot(xj(1, idx), xj(2, idx), 'rd');
  plot(sin(theta), cos(theta), '--k');
  [vij, Oij] = geodesic_direction_on_poincare_disk(xi(:, idx), xj(:, idx), d);
  vij        = vij/norm(vij);
  a          = norm(xi(:, idx) - Oij);
  quiver(xi(1, idx), xi(2, idx), vij(1), vij(2));
  plot(Oij(1), Oij(2), 'bo');
  plot(Oij(1) + a * sin(theta), Oij(2) + a * cos(theta), '-.b');
  title(sprintf('%d-th point', idx));
  hold off;
  pause;
end
end