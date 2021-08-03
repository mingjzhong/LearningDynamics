function knots = set_up_knots_PW_polynomial(x_range, p, n, ext_knots)
% function knots = set_up_knots_PW_polynomial(x_range, p, n, ext_knots)

% (C) M. Zhong

if isempty(ext_knots)
  num_psi_each_knot_span = p + 1;
  if mod(n, num_psi_each_knot_span) ~= 0
    error('SOD_Learn:set_up_knots_PW_polynomial:exception', ...
    'The n (=%d) has to be a multiple of %d.', n, num_psi_each_knot_span);
  end  
  num_sub_int            = n/num_psi_each_knot_span;
  num_knots              = num_sub_int + 1;
  knots                  = linspace(x_range(1), x_range(2), num_knots);
else
  validateattributes(ext_knots, {'numeric'}, {'increasing'}, 'set_up_knots_PW_polynomial', ...
    'knots_ext', 4);
  knots                  = ext_knots;
end
end