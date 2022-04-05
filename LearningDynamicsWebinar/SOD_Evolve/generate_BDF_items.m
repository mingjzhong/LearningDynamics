function [as, beta] = generate_BDF_items(order)
% function [as, beta] = generate_BDF_items(order)
% the values of a's, and beta are given by the formulas listed on
% https://en.wikipedia.org/wiki/Backward_differentiation_formula

% (C) M. Zhong

switch order
  case 1
    as   = -1;
    beta = 1;
  case 2
    as   = [-4/3, 1/3];
    beta = 2/3;
  case 3
    as   = [-18/11, 9/11, -2/11];
    beta = 6/11;
  case 4
    as   = [-48/25, 36/25, -16/25, 3/25];
    beta = 12/25;
  case 5
    as   = [-300/137, 300/137, -200/137, 75/137, -12/137];
    beta = 60/137;
  case 6
    as   = [-360/147, 450/147, -400/147, 225/147, -72/147, 10/147];
    beta = 60/147;
  otherwise
end
end