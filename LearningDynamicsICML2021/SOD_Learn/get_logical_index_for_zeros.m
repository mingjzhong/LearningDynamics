function idxs = get_logical_index_for_zeros(k, total_num_basis, num_basis)
% function idxs = get_logical_index_for_zeros(k, total_num_basis, num_basis)

% (C) M. Zhong

if total_num_basis > 0
  idxs              = true(total_num_basis, 1);
  ind1              = sum(num_basis(1 : k - 1)) + 1;
  ind2              = sum(num_basis(1 : k));
  idxs(ind1 : ind2) = false;
else
  idxs              = [];
end
end