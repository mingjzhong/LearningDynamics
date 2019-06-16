function neighbors = find_neighbors(x, neighbor_hood, kernel_type)
%
%
%

% Ming Zhong
% Postdoc Research at JHU

%
if strcmp(kernel_type, 'globa')
  neighbors  = [];
else
%
  pdist_mat  = squareform(pdist(transpose(x)), 'tomatrix');
%
  the_kernel = kernel_function(pdist_mat, neighbor_hood, kernel_type);
%
  neighbors  = sum(the_kernel, 2);
end