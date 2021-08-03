function point_dist = uniform_dist(d, N, type, domain)
% function point_dist = uniform_dist(d, N, type, domain)

% (C) M. Zhong

if nargin < 3, domain = []; end
% based on the dimension of the state vector first
switch d
    case 1
        switch type
            case 'line'
                a                 = domain(1);
                b                 = domain(2);
                point_dist        = (b - a) * rand(1, N) + a;
            otherwise
                error('');
        end
    case 2
        switch type
            case 'rectangle'
                a                = domain(1);
                b                = domain(2);
                point_dist       = (b - a) * rand(2, N) + a;
            case 'disk'
                R                = domain(1);
                theta            = 2 * pi * rand(1, N);
                r                = R * sqrt(rand(1, N));
                point_dist       = zeros(2, N);
                point_dist(1, :) = r .* cos(theta);
                point_dist(2, :) = r .* sin(theta);
            case 'annulus'
                R_1              = domain(1);
                R_2              = domain(2);
                theta            = 2 * pi * rand(1, N);
                r                = sqrt((R_2^2 - R_1^2) * rand(1, N) + R_1^2);
                point_dist       = zeros(2, N);
                point_dist(1, :) = r .* cos(theta);
                point_dist(2, :) = r .* sin(theta);
            case 'circle'
                R                = domain(1);
                theta            = 2 * pi * rand(1, N);
                point_dist(1, :) = R * cos(theta);
                point_dist(2, :) = R * sin(theta);
            otherwise
        end
    case 3
        switch type
            case 'cube'
                a                = domain(1);
                point_dist       = 2  * a * rand(3, N) - a;          
            case 'rectangle'
                a                = domain(1);
                b                = domain(2);
                point_dist       = (b - a) * rand(3, N) + a;
            case 'cylinder'
                z_1              = domain(1);
                z_2              = domain(2);
                R                = domain(3);
                theta            = 2 * pi * rand(1, N);
                r                = R * sqrt(rand(1, N));
                point_dist       = zeros(3, N);
                point_dist(1, :) = r .* cos(theta);
                point_dist(2, :) = r .* sin(theta);
                point_dist(3, :) = (z_2 - z_1) * rand(1, N) + z_1;
            case 'sphere_surface'
                R                = domain(1);
                theta            = 2 * pi * rand(1, N);
                phi              = acos(2 * rand(1, N) - 1);
                point_dist       = zeros(3, N);
                point_dist(1, :) = R * cos(theta) .* sin(phi);
                point_dist(2, :) = R * sin(theta) .* sin(phi);
                point_dist(3, :) = R * cos(phi);
            case 'sphere'
                R                = domain(1);
                phi              = 2 * pi * rand(1, N);
                theta            = acos(2 * rand(1, N) - 1);
                r                = R * (rand(1, N))^(1/3);
                point_dist       = zeros(3, N);
                point_dist(1, :) = r .* sin(theta) .* cos(phi);
                point_dist(2, :) = r .* sin(theta) .* sin(phi);
                point_dist(3, :) = r .* cos(theta);
          otherwise
              error('');
        end
    otherwise
        switch type
            case 'hypercube'
                a                = domain(1);
                b                = domain(2);
                point_dist       = (b - a) * rand(d, N) + a;
          otherwise
              error('');
        end
end
end