function theta = get_JPL_angle(u, v, method)
% function theta = get_JPL_angle(u, v, method)
% find the angle (in degree) between u and v using three different methods
% method - 1: acos, which gives  [0, pi]
%          2: atan2, which gives [0, -pi]
%          3: the angle (counter-clockwise) from u to v, which gives [0, 2 * pi], not stable*
%             theta(u, v) = -theta(v, u)

% (C) M. Zhong

if nargin < 3, method = 1; end
if ~iscolumn(u), u = u'; end
if ~iscolumn(v), v = v'; end
if length(u) == 2, u = [u; 0]; end
if length(v) == 2, v = [v; 0]; end
the_dot     = dot(u, v);
the_cross   = cross(u, v);
switch method
  case 1
    theta   = acosd(the_dot/(norm(u) * norm(v)));
  case 2
    theta   = atan2d(norm(the_cross), the_dot);
    if theta < 0
      theta = theta + 180;
    end
  case 3
    the_n   = [0; 0; 1]; % this normal vector has to be fixed
    theta   = atan2d(dot(the_n, the_cross), the_dot);
    if theta < 0
      theta = theta + 360;
    end
  otherwise
    error('');
end
end