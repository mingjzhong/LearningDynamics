function knots = set_up_knots_by_type(idx, range, basis_info, knots_ext)
% function knots = set_up_knots_by_type(idx, range, basis_info, knots_ext)

% (C) M. Zhong

if isfield(basis_info, 'knot_size') && ~isempty(basis_info.knot_size)
  knot_size = basis_info.knot_size;
else
  knot_size = [];
end
switch basis_info.type{idx}
  case 'B-spline'
    knots   = set_up_knots_B_spline(range(idx, :), basis_info.degree(idx), basis_info.n(idx), ...
              basis_info.sub_type{idx}, knots_ext, knot_size);
  case 'PW-polynomial'
    knots   = set_up_knots_PW_polynomial(range(idx, :), basis_info.degree(idx), basis_info.n(idx), ...
              knots_ext, knot_size);
  case 'Fourier'
    knots   = set_up_knots_Fourier(basis_info.period(idx));
  otherwise
    error('');
end
end