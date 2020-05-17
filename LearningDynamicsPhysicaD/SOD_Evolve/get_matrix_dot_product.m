function mat_dotp = get_matrix_dot_product(A, B)
% function mat_dotp = get_matrix_dot_product(A, B)

% (C) M. Zhong (JHU)

[Nd, N]    = size(A);
if mod(Nd, N) ~=0, error(''); end
d          = Nd/N;
if norm(size(B) - [Nd, N], Inf) ~= 0
  error('SOD_Examples:find_matrix_dot_product:exception', ...
    'A and B should have the same size: [%d, %d]!!', Nd, N);  
end
AtimesB    = A .* B;
ind        = 1 : d : (N - 1) * d + 1;
mat_dotp   = AtimesB(ind, :);
for idx = 2 : d
  ind      = idx : d : (N - 1) * d + idx;
  mat_dotp = mat_dotp + AtimesB(ind, :);
end
end