function rp = get_sample_points_in_knots(knots, degree)
% function rp = get_sample_points_in_knots(knots, degree)

% (C) M. Zhong

delta  = (knots(2 : end) - knots(1 : end - 1))/(degree + 1);

for ind = 1 : degree + 1
  if ind == 1
    rp = knots(1 : end - 1) + delta;
  else
    rp = union(rp, knots(1 : end - 1) + ind * delta);
  end
end
end