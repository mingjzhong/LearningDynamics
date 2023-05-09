function coeffs = get_Legendre_coefficients(degree, type)
% function coeffs = get_Legendre_coefficients(degree, type)

% (C) M. Zhong

if nargin < 2, type = 'original'; end
switch degree
% prepare the coefficients for the Legendre Polynomial as in the polyval manner  
% they are taken from legendreP(n, x) when x is declared as symbolic (i.e. syms x)
  case 0
    coeffs   = 1;
  case 1
    coeffs   = [1, 0];
% however, as tested, prescribed coeffes actually creates numerical instability, gonna just use the 
% 3-term recurseion instead (but then it will be slow, need  to pre-compute them first to speed, and
% also after abount degree = 40, numerical round-off errors catch up
%   case 2
%     coeffs   = [3/2, 0, -1/2];
%   case 3
%     coeffs   = [5/2, 0, -3/2, 0];
%   case 4
%     coeffs   = [35/8, 0, -30/8, 0, 3/8];
%   case 5
%     coeffs   = [63/8, 0, -70/8, 0, 15/8, 0];
%   case 6
%     coeffs   = [231/16, 0, -315/16, 0, 105/16, 0, -5/16];
%   case 7
%     coeffs   = [429/16, 0, -693/16, 0, 315/16, 0, -35/16, 0];
%   case 8
%     coeffs   = [6435/128, 0, -12012/128, 0, 6930/128, 0, -1260/128, 0, 35/128];
%   case 9
%     coeffs   = [12155/128, 0, -25740/128, 0, 18018/128, 0, -4620/128, 0, 315/128, 0];
%   case 10
%     coeffs   = [46189/256, 0, -109395/256, 0, 90090/256, 0, -30030/256, 0, 3465/256, 0, -63/256];
%   case 11
%     coeffs   = [88179/256, 0, 230945/256, 0, 109395/128, 0, 45045/128, 0, 15015/256, 0, 693/256, 0];
%   case 12
%     coeffs   = [676039/1024, 0, 969969/512, 0, 2078505/1024, 0, 255255/256, 0, 225225/2014, 0, ...
%                 9009/512, 0, 231/1024];
  otherwise
% the 3-term recursion, simplified in order to provide numerical stability    
    coeffs   = (2 - 1/degree) * [get_Legendre_coefficients(degree - 1), 0] - ...
               (1 - 1/degree) * [0, 0, get_Legendre_coefficients(degree - 2)];
end
switch type
  case '1st Derivative'
    if degree == 0
      coeffs = 0;
    else
      coeffs = coeffs(1 : degree) .* (degree : -1 : 1);
    end
  case '2nd Derivative'
    if degree == 0
      coeffs = 0;
    elseif degree == 1
      coeffs = [0, 0];
    else
      coeffs = coeffs(1 : (degree - 1)) .* (degree : -1 : 2) .* ((degree - 1) : -1 : 1);
    end
  case 'original'
% do nothing    
  otherwise
    error('');
end
end