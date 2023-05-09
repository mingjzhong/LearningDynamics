function psi = basis_PW_polynomial(x, eta, p, knots, type)
% function psi = basis_PW_polynomial(x, eta, p, knots, type)

% (C) M. Zhong (JHU)

validateattributes(eta,   {'numeric'}, {'integer', 'positive'});
validateattributes(p,     {'numeric'}, {'integer', 'nonnegative'});
validateattributes(knots, {'numeric'}, {'increasing', 'real', 'vector'});
% initialize storage
psi           = zeros(size(x));
% the index of the sub-interval within the knot vector, and the support [a, b)
subInt_idx    = fix((eta - 1)/(p + 1)) + 1;
a             = knots(subInt_idx);
b             = knots(subInt_idx + 1);
% only find those within the interval [a, b)
if b ~= knots(end), ind = a <= x & x < b; else, ind = a <= x & x <= b; end
% scale the originals
degree        = mod(eta - 1, p + 1);
h             = b - a;
switch type
  case 'Legendre'  
% shift to the interval [-1, 1], then scaled to have unit L2-norm, use MATLAB's built-in Leg. 
    psi(ind)  = sqrt((2 * degree + 1)/h) * legendreP(degree, 2 * (x(ind) - a)/h - 1); 
  case 'Standard' 
% shift to [-1, 1], scale to have unit L2-norm
    coeffs    = sparse([], [], [], 1, degree + 1, 0);
    coeffs(1) = 1;
    psi(ind)  = sqrt((2 * degree + 1)/h) * polyval(coeffs, 2 * (x(ind) - a)/h - 1);                                                
  otherwise
    error('SOD_Learn:basis_PW_polynomial:exception', ...
      'We only support Standard/Legendre polynomial basis!!');
end
end