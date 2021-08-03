function vec = get_rid_of_diagonal(mat)
% function vec = get_rid_of_diagonal(mat)
% takes out the diagonal entries and turn the matrix, mat, to a column vector

% (C) M. Zhong (JHU)

validateattributes(mat, {'numeric'},  {'2d', 'square'});
N   = size(mat, 1);
vec = mat(tril(true(N), -1) | triu(true(N), 1));
end