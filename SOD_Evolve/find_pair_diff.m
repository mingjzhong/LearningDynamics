function pair_diff = find_pair_diff(x)
% function pair_diff = find_pair_diff(x)
%   calculates the pair wise differences of observation (agents) in the data matrix x.
% IN:
%   x         : the data matrix, with each column of x, i.e., x_i, is a vector of states of agent i,
%               x is of size d * N, where d is the size of each state vector and N is the total 
%               number of agents (observations)
% Output:
%   pair_diff : pair wise different of the following form:
%               |x_1 - x_1, x_2 - x_1, \ldots, x_N - x_1|
%               |x_1 - x_2, x_2 - x_2, \ldots, x_N - x_2|
%               |   \vdots,    \vdots, \ddots,    \vdots|
%               |x_1 - x_N, x_2 - x_N, \ldots, x_N - x_N|

% (c) M. Zhong, JHU

% prepare for two big matrices
[d, N]    = size(x);                                                                                % find out the size of x, where the #rows is the size of the state, #cols is the number of samples
x_col_vec = reshape(x, [d * N, 1]);                                                                 % do the long column vector: (x_1, \ldots, x_N)^T
x_col_mat = repmat(x_col_vec, [1, N]);                                                              % obtain the matrix:
                                                                                                    % |   x_1,    x_1, \ldots,    x_1|
                                                                                                    % |   x_2,    x_2, \ldots,    x_2|
                                                                                                    % |\vdots, \vdots, \ddots, \vdots|
                                                                                                    % |   x_N,    x_N, \ldots,    x_N|
x_row_mat = repmat(x, [N, 1]);                                                                      % obtain the matrix:
                                                                                                    % |   x_1,    x_2, \ldots,    x_N|
                                                                                                    % |   x_1,    x_2, \ldots,    x_N|
                                                                                                    % |\vdots, \vdots, \ddots, \vdots|
                                                                                                    % |   x_1,    x_2, \ldots,    x_N|
pair_diff = x_row_mat - x_col_mat;                                                                  % obtain the pair wise difference matrix: x_i' - x_i
end