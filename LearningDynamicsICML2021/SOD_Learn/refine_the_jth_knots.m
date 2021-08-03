function knots_jp1 = refine_the_jth_knots(knots_j)
% function knots_jp1 = refine_the_jth_knots(knots_j)

% (C) M. Zhong

if ~isempty(knots_j)
  knots_jp1                    = cell(size(knots_j));
  for idx = 1 : length(knots_j)
    knots_jp1{idx}             = cell(size(knots_j{1}));
    for k1 = 1 : size(knots_j{1}, 1)
      for k2 = 1 : size(knots_j{1}, 1)
        knots_jp1{idx}{k1, k2} = refine_knots(knots_j{idx}{k1, k2});
      end
    end
  end
else
  knots_jp1                    = [];
end
end