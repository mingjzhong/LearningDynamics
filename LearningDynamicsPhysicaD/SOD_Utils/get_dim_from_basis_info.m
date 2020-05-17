function dim = get_dim_from_basis_info(basis_info)
% function dim = get_dim_from_basis_info(basis_info)

% (C) M. Zhong

dim             = zeros(size(basis_info));
for k1 = 1 : size(dim, 1)
  for k2 = 1 : size(dim, 2)
    dim(k1, k2) = basis_info{k1, k2}.dim;
  end
end
end