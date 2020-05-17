function n = set_n_in_basis_info(max_n, degree, type, sub_type)
% function n = set_n_in_basis_info(max_n, degree, type, sub_type)

% (C) M. Zhong

n        = zeros(size(degree));
for idx = 1 : length(n)
  n(idx) = set_n_in_basis_info_by_type(max_n, degree(idx), type{idx}, sub_type{idx});
end
end
