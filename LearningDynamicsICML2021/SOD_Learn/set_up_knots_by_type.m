function knots = set_up_knots_by_type(idx, phi_range, basis_info, knots_ext)
% function knots = set_up_knots_by_type(idx, phi_range, basis_info, knots_ext)

% (C) M. Zhong

switch basis_info.type{idx}
  case 'B-spline'
    knots   = set_up_knots_B_spline(phi_range(idx, :), basis_info.degree(idx), ...
              basis_info.n(idx), basis_info.sub_type{idx}, knots_ext);
  case 'PW-polynomial'
    knots   = set_up_knots_PW_polynomial(phi_range(idx, :), basis_info.degree(idx), ...
              basis_info.n(idx), knots_ext);
  case 'Polynomial'
    knots   = phi_range(idx, :);
  otherwise
    error('');
end
end