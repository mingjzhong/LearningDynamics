function psi = basis_Fourier(r, eta, knots, type)
% function psi = basis_Fourier(r, eta, knots, type)

% (C) M. Zhong

validateattributes(eta,   {'numeric'}, {'integer', 'positive'}, 'basis_Fourier', 'eta',   2);
validateattributes(knots, {'numeric'}, {'size', [1, 2]},        'basis_Fourier', 'knots', 3);
T           = knots(2);
r           = mod(r + T, 2 * T) - T;
if eta == 1
  psi       = 1/sqrt(T) * ones(size(r));
else
  switch type
    case 'Full'
      k     = floor(eta/2);
      if mod(eta, 2) == 0
        psi = sqrt(2/T) * cos(2 * k * pi/T * r);
      else
        psi = sqrt(2/T) * sin(2 * k * pi/T * r);  
      end
    case 'Cosine'
      k     = eta - 1;
      psi   = sqrt(2/T) * cos(2 * k * pi/T * r);
    case 'Sine'
      k     = eta - 1;
      psi   = sqrt(2/T) * sin(2 * k * pi/T * r);
    otherwise
      error('');
  end
end
end