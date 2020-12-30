function new_knot_vec = refine_knot_vec(knot_vec, level)
%
%

% Ming Zhong
% Postdoc Research at JHU

%
validateattributes(knot_vec, {'numeric'}, ...
  {'vector', 'row', 'nondecreasing'}, 'refine_knot_vec', 'knot_vec', 1);
%
validateattributes(level, {'numeric'}, ...
  {'integer', '>=', 1}, 'refine_knot_vec', 'level', 2);
% find out the number of knots
num_knots                = length(knot_vec);
% find out the number of sub-intervals
num_sub_int              = num_knots - 1;
% the new knot vector will have 2^{level} * num_sub_int sub-intervals
new_num_sub_int          = 2^(level) * num_sub_int;
% allocate the storage for the new knot vector
new_knot_vec             = zeros(1, new_num_sub_int + 1);
% populate the points in a loop
for ind = 1 : num_knots - 1
  new_ind                = ind + (ind - 1) * (2^(level) - 1);
  new_knot_vec(new_ind)  = knot_vec(ind);
  step_size              = knot_vec(ind + 1) - knot_vec(ind);
  new_step_size          = step_size * 2^(-level);
  new_inds               = (1 : (2^(level) - 1)) + new_ind;
  new_knot_vec(new_inds) = (new_step_size * (1 : (2^(level) - 1))) + ...
  knot_vec(ind);
end
%
new_knot_vec(end)        = knot_vec(end);