function n = set_n_in_basis_info_by_type(max_n, degree, type, sub_type)
% function n = set_n_in_basis_info_by_type(max_n, degree, type, sub_type)

% (C) M. Zhong

switch type
  case 'B-spline'
    switch sub_type
      case 'Clamped'
        if max_n < degree + 1
          n = degree + 1;
        else
          n = max_n;
        end
      otherwise
        error('');
    end
  case 'PW-polynomial'
    if mod(max_n, degree + 1) ~= 0
      n     = ceil(max_n/(degree + 1)) * (degree + 1);
    else
      n     = max_n;
    end
  case 'Fourier'
    switch sub_type
      case 'Full'
        n   = 2 * degree + 1;
      case 'Cosine'
        n   = degree + 1;
      case 'Sine'
        n   = degree + 1;
      otherwise
        error('');
    end
  otherwise
    error('');
end
end