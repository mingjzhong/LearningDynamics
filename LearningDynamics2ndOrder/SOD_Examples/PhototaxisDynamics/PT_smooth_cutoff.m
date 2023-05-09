function y = PT_smooth_cutoff(xi, cutoff)
% y = smooth_cutoff(xi, cutoff)
% provides a smooth cutoff function satisfying
% for xi < cutoff,                 y(xi) = 1
% for xi > 2 * cutoff,             y(xi) = 0
% for cutoff <= xi <= 2 * cutoff,  y is a smooth function decaying from 1 to 0, 
% In this particular case, we pick (cos((xi - cutoff) * pi/cutoff) + 1)/2.
% Input:
%   x
%   cutoff
% Output:
%   xi

% (C) M. Zhong (JHU)

% validate parameters
validateattributes(cutoff, {'numeric'}, {'scalar', 'positive'}, 'PT_smooth_cutoff', 'cutoff', 2);
y      = zeros(size(xi));
ind    = xi < cutoff;
y(ind) = 1;
ind    = cutoff <= xi & xi <= 2 * cutoff;
y(ind) = (cos((xi(ind) - cutoff) * pi/cutoff) + 1)/2;
end