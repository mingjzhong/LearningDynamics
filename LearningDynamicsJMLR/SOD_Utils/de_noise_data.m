function data_denoised = de_noise_data(data, time_vec, how_to_denoise)
% data_denoised = de_noise_data(data, time_vec, how_to_denoise)
% tries to de-noise a matrix of data, where the the rows of the data matrix
% are samples of the data at different times, thus de-nosing is done on
% each individual row of the data matrix (possible parallelization).

% Ming Zhong
% Postdoc Researt at JHU

% find out the number of rows in data
num_rows                    = size(data, 1);
% allocate the storage for the de-noised data
data_denoised               = zeros(size(data));
% go through each row in data
parfor row_ind = 1 : num_rows
% find out the data for regularized differentiation, and transpose it to a
% column vector
  the_data                  = transpose(data(row_ind, :));
% set up the parameters for differentiation
% maximum number of iterations for de-noising
  max_iters                 = 500;
% the epsilon to make 1/\sqrt(u' + \epsilon) non-zero at the denominator
  epsilon                   = 1.0e-6;
% pick a small regularization parameter
  lambda                    = 1.0e-5;
% clean up the data  
  data_clean                = reg_denoise(the_data, time_vec, lambda, ...
  max_iters, epsilon, how_to_denoise);
% put it back to d_vec
  data_denoised(row_ind, :) = transpose(data_clean);
end