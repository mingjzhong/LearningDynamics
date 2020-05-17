function n = get_n_from_basis_info_and_knots(idx, basis_info, knots)
% function n = get_n_from_basis_info_and_knots(idx, basis_info, knots)

% (C) M. Zhong

switch basis_info.type{idx}
  case 'B-spline'
    switch basis_info.sub_type{idx}
      case 'Clamped'
        n = length(knots) - basis_info.degree(idx) - 1;
      otherwise
        error('');
    end
  case 'PW-polynomial'
    n     = (basis_info.degree(idx) + 1) * (length(knots) - 1);
  case 'Fourier'
    switch basis_info.sub_type{idx}
      case 'Full'
        n = 2 * basis_info.degree(idx) + 1;
      case 'Cosine'
        n = basis_info.degree(idx) + 1;
      case 'Sine'
        n = basis_info.degree(idx) + 1;
      otherwise
        error('');
    end
  otherwise
    error('');
end
end