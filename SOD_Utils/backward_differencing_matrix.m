function D_mat = backward_differencing_matrix(time_vec)
%
%
%

% Ming Zhong
% Postdoc Research at JHU

% find out the length of time_vec
N                 = length(time_vec);
% we need time_vec contains increasing time instances
validateattributes(time_vec, {'numeric'}, ...
  {'vector', 'row', 'increasing'}, 'backward_differencing_matrix', ...
  'time_vec', 1);
% find out the time steps
time_steps        = zeros(size(time_vec));
time_steps(2 : N) = time_vec(2 : N) - time_vec(1 : N - 1);
time_steps(1)     = time_vec(1)     - time_vec(2);
% Construct backward differentiation matrix
% on the main diagonal is 1/\delta_t_i
main_diag         = ones(N, 1)./transpose(time_steps);
% on the sub-disgonal is -1/\delta_t_{i + 1}
sub_diag          = -ones(N - 1, 1)./transpose(time_steps(2 : N));
% to use spdiags, sub_diag and main_diag have to have the same size, just
% add a zero to sub_diag, since it won't be picked
sub_diag          = [sub_diag; 0];
% construct the matrix with spdiags, since it has only two diagonals
D_mat             = spdiags([sub_diag, main_diag], [-1, 0], N, N);
% D(1, 2) = -1/\delta_t_1
D_mat(1, 2)       = -1/time_steps(1);