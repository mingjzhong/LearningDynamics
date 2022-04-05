function indic = get_refinement_indicators(rhoLT, knots, thredshold)
% function indic = get_refinement_indicators(rhoLT, knots, thredshold)

% (C) M. Zhong

num_subInt     = length(knots) - 1;
indic          = zeros(1, num_subInt);
for idx = 1 : num_subInt
  mid_pt       = (knots(idx) + knots(idx + 1))/2;
  prob1        = get_probability_from_rhoLT(rhoLT, [knots(idx), mid_pt]);
  prob2        = get_probability_from_rhoLT(rhoLT, [mid_pt, knots(idx + 1)]);
  if prob1 >= thredshold && prob2 >= thredshold, indic(idx) = 1; end
end
end