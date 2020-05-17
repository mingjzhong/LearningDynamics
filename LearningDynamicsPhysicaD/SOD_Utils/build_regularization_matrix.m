function R = build_regularization_matrix(R1, R2)
%

% (C) M. Zhong

if isempty(R1)
  R          = sparse(R2);
else
  if isempty(R2)
    R        = sparse(R1);
  else
    [m1, n1] = size(R1);
    [m2, n2] = size(R2);
    D1       = zeros(m1, n2);
    D2       = zeros(m2, n1);
    R        = sparse([R1, D1; D2, R2]);
  end
end
R            = transpose(R) * R;
end