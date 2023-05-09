function knots = set_up_knots(phi_range, basis_info, ext_knots)
% function knots = set_up_knots(phi_range, basis_info, ext_knots)

% (C) M. Zhong

if nargin < 3, ext_knots = []; end
dim            = size(phi_range, 1);
knots          = cell(1, dim);
for idx = 1 : dim
  if ~isempty(ext_knots)
    knots{idx} = set_up_knots_by_type(idx, phi_range, basis_info, ext_knots(idx, :));
  else
    knots{idx} = set_up_knots_by_type(idx, phi_range, basis_info, []);
  end
end
end