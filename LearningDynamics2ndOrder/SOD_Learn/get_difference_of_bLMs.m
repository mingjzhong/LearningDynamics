function d_new = get_difference_of_bLMs(d_vec, F_vec)
% function d_new = get_difference_of_bLMs(d_vec, F_vec)

% (C) M. Zhong

if isempty(F_vec)
  d_new = d_vec;
else
  d_new = cell(size(d_vec));
  for k = 1 : length(d_vec)
    d_new{k} = d_vec{k} - F_vec{k};
  end
end
end



