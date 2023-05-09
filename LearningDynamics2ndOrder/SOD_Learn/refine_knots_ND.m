function knots = refine_knots_ND(knots_old)
% function knots = refine_knots_ND(knots_old)

% (C) M. Zhong

dim          = length(knots_old);
knots        = cell(1, dim);
for idx = 1 : dim
  knots{idx} = refine_knots(knots_old{idx});
end
end