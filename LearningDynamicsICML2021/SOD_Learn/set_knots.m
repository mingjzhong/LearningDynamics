function knots = set_knots(j, knots_j, knots)
% function knots = set_knots(j, knots_j, knots)

% (C) M. Zhong

if ~isempty(knots_j)
  for idx = 1 : length(knots_j)
    for k1 = 1 : size(knots_j{1}, 1)
      for k2 = 1 : size(knots_j{1}, 1)
        knots{idx}{k1, k2}{j} = knots_j{idx}{k1, k2};
      end
    end
  end
end
end