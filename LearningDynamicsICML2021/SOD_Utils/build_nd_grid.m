function [R, S] = build_nd_grid(knots, degree, basis_plan)
% function [R, S] = build_nd_grid(knots, degree, basis_plan)

% (C) M. Zhong

first_deg                   = degree(basis_plan.first_dim);
if first_deg >= 0 && first_deg <= 1, first_num_pts = 1; else,  first_num_pts = 2; end
second_deg                  = degree(setdiff([1, 2], basis_plan.first_dim));
if second_deg >= 0 && second_deg <= 1, second_num_pts = 1; else,  second_num_pts = 2; end
num_subs_1st                = length(knots);
num_subs_2nd                = length(knots{1}{2}) - 1;
vec_1st                     = zeros(num_subs_1st * first_num_pts + 2, 1);
mat_2nd                     = zeros(num_subs_1st * first_num_pts + 2, num_subs_2nd * second_num_pts + 2);
for idx = 1 : num_subs_1st
  if idx == 1
    ind1                    = 1;
    ind2                    = first_num_pts + 1;
    vec_1st(ind1 : ind2)    = get_sample_points_for_interpolant(knots{idx}{1}, first_deg, 'left');
    vec_2nd                 = get_sample_points_for_interpolant(knots{idx}{2}, second_deg, 'both');
    if ~isrow(vec_2nd), vec_2nd = vec_2nd'; end
    mat_2nd(ind1 : ind2, :) = repmat(vec_2nd, [first_num_pts + 1, 1]);
  elseif idx == num_subs_1st
    ind1                    = (idx - 1) * first_num_pts + 2;
    ind2                    = idx * first_num_pts + 2;
    vec_1st(ind1 : ind2)    = get_sample_points_for_interpolant(knots{idx}{1}, first_deg, 'right');
    vec_2nd                 = get_sample_points_for_interpolant(knots{idx}{2}, second_deg, 'both');
    if ~isrow(vec_2nd), vec_2nd = vec_2nd'; end
    mat_2nd(ind1 : ind2, :) = repmat(vec_2nd, [first_num_pts + 1, 1]);
  else
    ind1                    = (idx - 1) * first_num_pts + 2;
    ind2                    = idx * first_num_pts + 1;
    vec_1st(ind1 : ind2)    = get_sample_points_for_interpolant(knots{idx}{1}, first_deg, 'neither');
    vec_2nd                 = get_sample_points_for_interpolant(knots{idx}{2}, second_deg, 'both');
    if ~isrow(vec_2nd), vec_2nd = vec_2nd'; end
    mat_2nd(ind1 : ind2, :) = repmat(vec_2nd, [first_num_pts, 1]);  
  end
end
mat_1st                     = repmat(vec_1st, [1, num_subs_2nd * second_num_pts + 2]);
if basis_plan.first_dim == 1
  R                         = mat_1st;
  S                         = mat_2nd;
else
  R                         = mat_2nd';
  S                         = mat_1st';
end
end