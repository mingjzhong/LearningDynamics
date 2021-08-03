function psi = basis_polynomial(x, eta, knots, type)
% function psi = basis_polynomial(x, eta, knots, type)

% (C) M. Zhong (JHU)

% check parameters
validateattributes(eta,   {'numeric'}, {'integer', 'positive'});
validateattributes(knots, {'numeric'}, {'size', [1, 2], 'increasing'});
% initialization, going to assume that psi(x) outside of [a, b] are constants at psi(a)/psi(b)
h             = knots(2) - knots(1);
ind           = x < knots(1);
x(ind)        = knots(1);
ind           = x > knots(2);
x(ind)        = knots(2);
switch type 
  case 'Legendre'
% shift to the interval [-1, 1], then scaled to have unit L2-norm
% not using MATLAB's built-in routine (legendreP), too slow for large data set
    coeffs    = get_Legendre_coefficients(eta - 1);
    psi       = sqrt((2 * eta - 1)/h) * polyval(coeffs, 2 * (x - knots(1))/h - 1);                                                       
  case 'Standard' 
% shift to [-1, 1], scale to have unit L2-norm
    coeffs    = sparse([], [], [], 1, eta, 0);
    coeffs(1) = 1;
    psi       = sqrt((2 * eta - 1)/h) * polyval(coeffs, 2 * (x - knots(1))/h - 1);                                                   
  case 'Negative' % no need to shift to [-1, 1]
    if prod(knots) < 0, error(''); end % but the interval has to be either both pos. or both neg.
    psi       = x.^(-eta);
% re-scaled to have unit L2-norm in order to prevent the fast decay of negative power    
%    psi       = sqrt((1 - 2 * eta)/(knots(2)^(1 - 2 * eta) - knots(1)^(1 - 2 * eta))) * x.^(-eta);
%   case 'Orthogonal'
% this 3-term recursion is not numerically stable (and also slow) when n is bigger than 45-ish
%     if eta == 1
%       psi     = ones(x);
%     elseif eta == 2
%       a_etam1 = inner_product(@(x) x, @(x) ones(size(x)));
%       psi     = x - a_etam1;
%     else
%       a_etam1 = inner_product(@(x) x .* psi_etam1(x), psi_etam1)/inner_product(psi_etam1, psi_etam1);
%       b_etam1 = inner_product(psi_etam1, psi_etam1)/inner_product(psi_etam2, psi_etam2);
%       psi     = (x - a_etam1) .* psi_etam1(x) - b_etam1 * psi_etam2(x);
%     end
  otherwise
    error('SOD_Learn:basis_polynomial:exception', ...
      'We only support Standard, Negative and Orthogonal polynomial bases!!');
end
end