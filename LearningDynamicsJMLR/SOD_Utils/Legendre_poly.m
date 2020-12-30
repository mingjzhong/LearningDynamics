function [y, dy] = Legendre_poly(n, x)
% [y, dy] = legendre_poly(n, x)
%
%

% Ming Zhong
% Postdoc Research at JHU

% where x is in [-1, 1]
ind    = -1 <= x & x < 1;
% the polynomial value
y      = zeros(size(x));
% the derivative of the polynomial
dy     = zeros(size(x));
% do it by case, the degree of the Legendre polynomial
switch n
% prepare the coefficients for the Legendre Polynomial as in the polyval manner  
  case 0
    P   = 1;
  case 1
    P   = [1, 0];
  case 2
    P   = [3/2, 0, -1/2];
  case 3
    P   = [5/2, 0, -3/2, 0];
  case 4
    P   = [35/8, 0, -30/8, 0, 3/8];
  case 5
    P   = [63/8, 0, -70/8, 0, 15, 0];
  case 6
    P   = [231/16, 0, -315/16, 0, 105/16, 0, -5/16];
  case 7
    P   = [429/16, 0, -693/16, 0, 315/16, 0, -35/16, 0];
  case 8
    P   = [6435/128, 0, -12012/128, 0, 6930/128, 0, -1260/128, 0, 35/128];
  case 9
    P   = [12155/128, 0, -25740/128, 0, 18018/128, 0, -4620/128, 0, ...
    315/128, 0];
  case 10
    P   = [46189/256, 0, -109395/256, 0, 90090/256, 0, -30030/256, 0, ...
    3465/256, 0, -63/256];
  otherwise
% only upto degree 10 for now, throw an error    
    error('');
end
% for constant, nothing to do
if n == 0
  dP    = 0 ;
else
% for non-constant  
  dP    = P(1 : n) .* (n : -1 : 1);
end
% return the values
y(ind)  = polyval(P, x(ind));
dy(ind) = polyval(dP, x(ind));