function C = smatrix_times_vmatrix(A, B, d)
% function C = smatrix_times_vmatrix(A, B, d)
% does a ''component-wise'' matrix mulciplication between A (a matrix of scalers) and B (a matrix of
% vectors), A is of the size [Nk1, Nk2] and B is of the size [Nk1 * d, Nk2], B contains a Nk1 * Nk2
% amount of column vectors of size [d, 1]. when d == 1, just perform the normal entry-wise 
% matrix-matrix multiplication.

% (C) M. Zhong

if ~isempty(B)
  if d == 1
    if norm(size(A) - size(B), Inf) ~= 0, error('SOD_Utils:smatrix_times_vmatrix:exception', ...
        'A and B must have the same size!!'); end
    C                               = A .* B;
  else
    [N1, N2]    = size(A); 
    N1d         = N1 * d;  
    if norm(size(B) - [N1d, N2], Inf) ~= 0, error('SOD_Utils:smatrix_times_vmatrix:exception', ...
        'B must have size [%d, %d]!!', N1d, N2); end
    C           = zeros(size(B));
    for idx = 1 : d
      ind       = idx : d : N1d - d + idx;
      C(ind, :) = A .* B(ind, :);
    end
  end
else
  C             = A;
end
end