function Nk_mat = get_Nk_mat(Nks, N, d)
% function Nk_mat = get_Nk_mat(Nks, N, d)

% (C) M. Zhong

if d == 1
  Nk_mat                                 = spdiags(sqrt(Nks), 0, N, N);
else
  Nk_mat                                 = zeros(N * d);
  for idx = 1 : N
    row_ind1                             = (idx - 1) * d + 1;
    row_ind2                             = idx * d;
    col_ind                              = (idx - 1) * d + 1;
    Nk_mat(row_ind1 : row_ind2, col_ind) = sqrt(Nks(idx));
  end
  Nk_mat                                 = sparse(Nk_mat);
end
end