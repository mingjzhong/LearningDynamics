function y_init = sphere_init_config(d, N, R, kind)
% function y_init = sphere_init_config(d, N, R, kind)

% (c) M. Zhong, JHU

if nargin < 4, kind = 1; end
switch kind
  case 1
    switch d
      case 2
        y_init   = uniform_dist(d, N, 'circle',         R);
        y_init   = y_init(:);
      case 3
        y_init   = uniform_dist(d, N, 'sphere_surface', R);
        y_init   = y_init(:);
      otherwise
        error('');
    end    
  case 2
    if d ~= 3, error(''); end
    theta_0      = 2 * pi * rand;
    psi_0        = pi/2 * rand + pi/4;
    y_pred       = uniform_dist(2, 1, 'disk', 0.1);
    r_pred       = norm(y_pred);
    theta_pred   = atan2(y_pred(2), y_pred(1));
    psi_pred     = 2 * atan(1/r_pred);
    theta_diff   = theta_0 - theta_pred;
    psi_diff     = psi_0 - psi_pred;
    y_prey       = uniform_dist(2, N - 1, 'annulus', [0.3, 0.8]);
    r_prey       = sum(y_prey.^2).^(0.5);
    theta_prey   = atan2(y_prey(2, :), y_prey(1, :));
    psi_prey     = 2 * atan(1./r_prey);
    thetas       = [theta_prey, theta_pred] + theta_diff;
    psis         = [psi_prey, psi_pred] + psi_diff;
    y_init       = zeros(d, N);
    y_init(1, :) = R * sin(psis) .* cos(thetas);
    y_init(2, :) = R * sin(psis) .* sin(thetas);
    y_init(3, :) = R * cos(psis);
    y_init       = y_init(:);
  otherwise
    error('');
end

end