function C = smatrix_times_vmatrix(A, B, d)
% function C = smatrix_times_vmatrix(A, B, d)
% does a ''component-wise'' matrix mulciplication between A (a matrix of scalers) and B (a matrix of
% vectors), A is of the size [Nk1, Nk2] and B is of the size [Nk1 * d, Nk2], B contains a Nk1 * Nk2
% amount of column vectors of size [d, 1]. when d == 1, just perform the normal entry-wise 
% matrix-matrix multiplication.

% (C) M. Zhong

if ~isempty(B)
  validateattributes(d, {'numeric'}, {'positive', 'integer'}, 'smatrix_times_vmatrix', 'd', 3);
  Nk2           = size(B, 2);
  Nk1           = size(A, 1);
  validateattributes(A, {'numeric'}, {'size', [Nk1,     Nk2]}, 'smatrix_times_vmatrix', 'A', 1);
  validateattributes(B, {'numeric'}, {'size', [Nk1 * d, Nk2]}, 'smatrix_times_vmatrix', 'B', 2);
  if d == 1
    C           = A .* B;
  else
    C           = zeros(size(B));
    for idx = 1 : d
      ind       = idx : d : (Nk1 - 1) * d + idx;
      C(ind, :) = A .* B(ind, :);
    end
  end
else
  C             = A;
end
end