function psi = basis_PW_polynomial(x, eta, p, knots, type)
% psi = basis_PW_polynomial(x, eta, p, knots, type)

% (C) M. Zhong (JHU)

% initialize storage
psi          = zeros(size(x));
% the index of the sub-interval within the knot vector, and the support [a, b)
subInt_idx   = fix((eta - 1)/(p + 1)) + 1;
a            = knots(subInt_idx);
b            = knots(subInt_idx + 1);
% only find those within the interval [a, b)
if b ~= knots(end), ind = a <= x & x < b; else, ind = a <= x & x <= b; end
% scale the originals
degree       = mod(eta - 1, p + 1);
h            = b - a;
switch type
  case 'Legendre'
    y        = basis_PW_polynomial_Legendre(2 * (x(ind) - a)/h - 1, degree);                        % shift to the interval [-1, 1]    
% scale them properly to have unit norm over [a, b]
    psi(ind) = sqrt(2 * p + 1)/sqrt(h) * y;
  case 'Standard'
    y        = basis_PW_polynomial_Standard(2 * (x(ind) - a)/h - 1, degree);                        % shift to the interval [-1, 1]
% scale them properly 
    psi(ind) = y;
  otherwise
    error('SOD_Utils:polynomial_basis_1D:exception', 'We only support Legendre and standard polynomial basis!!');
end
end