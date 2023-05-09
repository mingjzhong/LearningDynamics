function mat_dotp = get_matrix_dot_product(A, B, d)
% function mat_dotp = get_matrix_dot_product(A, B, d)

% (C) M. Zhong (JHU)

[N1d, N2]  = size(A);
validateattributes(B, {'numeric'}, {'size', [N1d, N2]});
if nargin < 3
  if mod(N1d, N2) ~=0, error(''); end
  d        = N1d/N2;  % assuming N1 = N2
else
  validateattributes(d, {'numeric'}, {'positive', 'integer'});
  if mod(N1d, d) ~= 0, error(''); end
end
mat_dotp   = zeros(N1d/d, N2);
for idx = 1 : d
  ind      = idx : d : (N1d - d + idx);
  mat_dotp = mat_dotp + A(ind, :) .* B(ind, :);
end
end