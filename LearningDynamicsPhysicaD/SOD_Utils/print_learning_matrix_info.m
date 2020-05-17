function print_learning_matrix_info(Phi)
%
%

% Ming Zhong
% Postdoc Research at JHU

% print out what is being done
fprintf('\nThe following information is about the learning matrix, Phi.');
% find out the rank information
Phi_rank             = rank(Phi);
fprintf('\n  The learning matrix, Phi, has rank = %d.', Phi_rank);
% find out if Phi has full rank
[num_rows, num_cols] = size(Phi);
use_perc             = Phi_rank/num_cols * 100;
fprintf('\n  The learning matrix, Phi, has %d rows and %d columns.', ...
num_rows, num_cols);
fprintf('\n  It uses %6.2f percentage of columns.', use_perc);
% find out the maximum and minimum singular values of Phi
sigma_max            = norm(Phi);
cond_num             = cond(Phi);
sigma_min            = sigma_max/cond_num;
fprintf('\n  The maximum singular value of Phi is: %12.4e.', sigma_max);
fprintf('\n  The minimum singular value of Phi is: %12.4e.', sigma_min);
fprintf('\n  The condition       number of Phi is: %12.4e.', cond_num);

return