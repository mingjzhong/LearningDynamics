function y_init = gravitation_init_config(d, N, Sun_mass, G, aphelions, perihelions)
% function y_init = gravitation_init_config(d, N, Sun_mass, G, aphelions, perihelions)

% (C) M. Maggioni, J. Mill, and M. Zhong (JHU)

% initial check
if d < 2, error('SOD_Examples:gravitation_init_config:exception', 'd has to be at least 2!!'); end
y_init                 = zeros(d, 2 * N);                                                           % initialize to zero, Sun has no initial velocity and sits at the Origin
% position/velocity for each planet
switch d
  case 2
     for k = 2 : N
      a                = (aphelions(k) + perihelions(k))/2;                                         % major axis
      c                = (aphelions(k) - perihelions(k))/2;                                         % focus
      b                = sqrt(a^2 - c^2);                                                           % minor axis
      theta            = 2 * pi * rand(1);                                                          % random angle
      pos              = [a * cos(theta) - c; b * sin(theta)];                                      % shifted elliptical traj, so that the Sun/Earth is sitting at (-c, 0) as the origin 
      r                = norm(pos);                                                                 % distance to the Sun
      y_init(:, k)     = pos;                                                                       % initial position
      vel              = [-a * sin(theta); b * cos(theta)];                                         % tangential velocity (tangent to the curve)
      vel              = vel/norm(vel);                                                             % normalized                                
      y_init(:, k + N) = vel * sqrt(G * Sun_mass * (2/r - 1/a));                                    % Vis-Viva equation, derived from conservation of energy
     end   
  otherwise
    error('SOD_Examples:gravitation_init_config:exception', 'Only 2D simulation is supported!!');
end
y_init                 = y_init(:);                                                                 % reshape into a column vector of [2 * d * N, 1]
end