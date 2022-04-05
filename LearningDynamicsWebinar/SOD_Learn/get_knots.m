function knots_j = get_knots(j, knots)
% function knots_j = get_knots(j, knots)

% (C) M. Zhong

if ~isempty(knots)
  knots_j                    = cell(size(knots));
  for idx = 1 : length(knots)
    knots_j{idx}             = cell(size(knots{1}, 1));
    for k1 = 1 : size(knots{1}, 1)
      for k2 = 1 : size(knots{1}, 1)
        knots_j{idx}{k1, k2} = knots{idx}{k1, k2}{j};
      end
    end
  end
else
  knots_j                    = [];
end
end