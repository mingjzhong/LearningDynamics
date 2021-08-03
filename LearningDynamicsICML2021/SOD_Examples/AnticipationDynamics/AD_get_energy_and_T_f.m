function [U_prime, U_dprime, T_f] = AD_get_energy_and_T_f(kind)
% function [U_prime, U_dprime, T_f] = AD_get_energy_and_T_f(kind)

% (C) M. Zhong

switch kind
  case 1     
% U(r) = r^p/p, with 1 < p <= 2, p = 2 gives the constant functions (not interesting)
    p        = 1.5;
    U_prime  = @(r) r.^(p - 1);
    U_dprime = @(r) (p - 1) * r.^(p - 2);    
    T_f      = 10;
  case 2     
% U''(r) = 1/sqrt(1 + r^2), the function used in CS model with \beta = 1/2,
% we need U(r) = 0, U'(r) = 0, and U'' is bounded as r \rightarrow \infty
    U_prime  = @(r) log(sqrt(r.^1 + 1) + r);
    U_dprime = @(r) (1 + r.^2).^(-1/2); 
    T_f      = 10;  
  case 3
% U(r) = 0, U'(r) = 0, and U'' is bounded as r \rightarrow \infty, I'm also assuming that 
% U''(r) > 0?  We use a sin function
%   U        = @(r) r - sin(r) + r.^2/2;
    U_prime  = @(r) 1 - cos(r) + r;
    U_dprime = @(r) 1 + sin(r);
    T_f      = 10;    
  case 4
% a special U(r) = r, homogeneous of degree 0, case (might have finite time flocking??)
    U_prime  = @(r) ones(size(r));
    U_dprime = @(r) zeros(size(r));    
    T_f      = 10;
  case 5
% a special U(r) = r^3/3, not sure if it will flock, but numerically interesting
    U_prime  = @(r) r.^2;
    U_dprime = @(r) 2 * r;    
    T_f      = 10;    
  otherwise
    error('SOD_Examples:AD_get_energy_and_T_f:exception', ...
      'Only choice between 1 and 5 is considered!!');
end
end