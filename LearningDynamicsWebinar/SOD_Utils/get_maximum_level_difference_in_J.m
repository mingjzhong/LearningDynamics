function max_J_diff = get_maximum_level_difference_in_J(idx, J)
% function max_J_diff = get_maximum_level_difference_in_J(idx, J)

% (C) M. Zhong

new_idx      = idx - 1;
if new_idx == 0
  max_J_diff = J - 1;
else
  max_J_diff = nnz(factor(new_idx) == 2);
end
end