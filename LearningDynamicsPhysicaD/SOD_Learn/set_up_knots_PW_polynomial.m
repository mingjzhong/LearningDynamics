function knots = set_up_knots_PW_polynomial(range, p, n, knots_ext, knot_size)
% function knots = set_up_knots_PW_polynomial(range, p, n, knots_ext, knot_size)

% (C) M. Zhong

if nargin < 5, knot_size = []; end
if isempty(knots_ext)
  num_psi_each_knot_span = p + 1;
  if mod(n, num_psi_each_knot_span) ~= 0
    error('SOD_Learn:set_up_knots_PW_polynomial:exception', ...
    'The n (=%d) has to be a multiple of %d.', n, num_psi_each_knot_span);
  end  
  if ~isempty(knot_size)
    n_thresh             = ceil((range(2) - range(1))/knot_size) * num_psi_each_knot_span;
  else
    n_thresh             = n;
  end
  n                      = min([n, n_thresh]);
  num_sub_int            = n/num_psi_each_knot_span;
  num_knots              = num_sub_int + 1;
  knots                  = linspace(range(1), range(2), num_knots);
else
  if n ~= (p + 1) * (length(knots_ext) - 1)
    error('SOD_Learn:set_up_knots_PW_polynomial:exception', ...
    'The n (=%d) has to be %d * %d.', n, p + 1, length(knots_ext) - 1);    
  end
  knots                  = knots_ext;
end
end