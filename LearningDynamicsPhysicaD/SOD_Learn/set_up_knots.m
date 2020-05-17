function knots = set_up_knots(range, learn_info, basis_info)
% function knots = set_up_knots(range, learn_info, basis_info)

% (C) M. Zhong

dim           = size(range, 1);
if isfield(learn_info, 'knot_type') && ~isempty(learn_info.knot_type)
  if strcmp(learn_info.knot_type, 'adaptive')
    knots_ext = learn_info.knots; 
  elseif strcmp(learn_info.knot_type, 'uniform')
    knots_ext = cell(1, dim);
  end
else
  knots_ext   = cell(1, dim);
end
knots         = cell(1, dim);
for idx = 1 : dim
  knots{idx}  = set_up_knots_by_type(idx, range, basis_info, knots_ext{idx});
end
end