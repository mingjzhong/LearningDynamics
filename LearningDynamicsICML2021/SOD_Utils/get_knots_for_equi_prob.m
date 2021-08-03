function [the_knots, indicators] = get_knots_for_equi_prob(rhoLT, J, sample_tol)
% function [the_knots, indicators] = get_knots_for_equi_prob(rhoLT, J, sample_tol)

% (C) M. Zhong

indicators      = cell(1, J);
knots           = cell(1, J);
for j = 1 : J
  if j == 1
    knots{j}    = rhoLT.supp;
  else
    knots{j}    = knots_jp1;  
  end
  knots_jp1     = refine_knots(knots{j});
  indicators{j} = get_refinement_indicators(rhoLT, knots{j}, sample_tol);
end
the_knots       = get_knots_from_indicators(knots, indicators);
end