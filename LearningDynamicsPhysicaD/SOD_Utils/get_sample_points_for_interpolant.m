function sample_pts = get_sample_points_for_interpolant(knots, degree)
% function sample_pts = get_sample_points_for_interpolant(knots, degree)

% (C) M. Zhong

hs         = (knots(2 : end) - knots(1 : end - 1))/(degree + 2);
le_pts     = knots(1 : end - 1);
deg_vec    = (1 : (degree + 1))';
sample_pts = repmat(le_pts, [length(deg_vec), 1]) + deg_vec * hs;
sample_pts = sample_pts(:);
sample_pts = union(sample_pts, [knots(1), knots(end)]);
end