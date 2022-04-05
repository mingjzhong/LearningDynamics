function knots = set_up_knots_by_rho(phi_range, basis_info, rho)
% function knots = set_up_knots_by_rho(phi_range, basis_info, rho)

% (C) M. Zhong

dim            = size(phi_range, 1);
knots          = cell(1, dim);
if dim > 1, error('SOD_Learn:set_up_knots_by_rho:exception', 'Supports only 1D phis!!'); end
for idx = 1 : dim
  switch basis_info.type{idx}
    case 'B-spline'
      num_partitions = basis_info.n(idx);
    case 'PW-polynomial'
      num_partitions = basis_info.n(idx)/basis_info.degree(idx);
  end
  ext_knots          = find_partition_for_rho(phi_range, rho.dense, num_partitions);
  knots{idx}         = set_up_knots_by_type(idx, phi_range, basis_info, ext_knots);
end
end