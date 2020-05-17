function psi = basis_Fourier_1st_derivative(r, eta, knots, type)
% function psi = basis_Fourier_1st_derivative(r, eta, knots, type)

% (C) M. Zhong

validateattributes(eta,   {'numeric'}, {'integer', 'positive'},    'basis_Fourier', 2);
validateattributes(p,     {'numeric'}, {'integer', 'nonnegative'}, 'basis_Fourier', 3);
validateattributes(knots, {'numeric'}, {'size', [1, 2]},           'basis_Fourier', 4);
T           = knots(2);
r           = mod(r + T, 2 * T) - T;
if eta == 1
  psi       = zeros(size(r));
else
  switch type
    case 'Full'
      k     = floor(eta/2);
      if mod(eta, 2) == 0
        psi = -sqrt(2/T) * sin(2 * k * pi/T * r) * 2 * k * pi/T;
      else
        psi =  sqrt(2/T) * cos(2 * k * pi/T * r) * 2 * k * pi/T;  
      end
    case 'Cosine'
      k     = eta - 1;
      psi   = -sqrt(2/T) * sin(2 * k * pi/T * r) * 2 * k * pi/T;
    case 'Sine'
      k     = eta - 1;
      psi   =  sqrt(2/T) * cos(2 * k * pi/T * r) * 2 * k * pi/T;
    otherwise
      error('');
  end
end
end