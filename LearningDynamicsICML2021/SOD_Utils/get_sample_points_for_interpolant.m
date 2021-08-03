function sample_pts = get_sample_points_for_interpolant(knots)
% function sample_pts = get_sample_points_for_interpolant(knots)

% (C) M. Zhong

% if nargin < 2, end_pt_type = 'both'; end
% if degree >= 0 && degree <= 1, degree = 0; else, degree = 1; end
% hs         = (knots(2 : end) - knots(1 : end - 1))/(degree + 2);
% le_pts     = knots(1 : end - 1);
% deg_vec    = (1 : (degree + 1))';
% sample_pts = repmat(le_pts, [length(deg_vec), 1]) + deg_vec * hs;
% sample_pts = sample_pts(:);
sample_pts = (knots(2 : end) + knots(1 : end - 1))/2;
sample_pts = union(sample_pts, [knots(1), knots(end)]);
% switch end_pt_type
%   case 'both'
%     sample_pts = union(sample_pts, [knots(1), knots(end)]);
%   case 'left'
%     sample_pts = union(sample_pts, knots(1));
%   case 'right'
%     sample_pts = union(sample_pts, knots(end));
%   case 'neither'
% % do nothing
%   otherwise
%     error('');
% end
end