function theta = get_angle_between_vectors(u, v)
% function theta = get_angle_between_vectors(u, v)

% (C) M. Zhong

if size(u, 1) ~= 3, error(''); end
if size(v, 1) ~= 3, error(''); end
if size(u, 2) ~= size(v, 2), error(''); end
udotv   = dot(u, v);
ucrossv = cross(u, v);
theta   = atan2d(sum(ucrossv.^2).^(0.5), udotv);
end