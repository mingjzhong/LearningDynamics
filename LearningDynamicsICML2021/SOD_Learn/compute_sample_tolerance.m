function tol = compute_sample_tolerance(N, L, M, d)
% function tol = compute_sample_tolerance(N, L, M, d)

% (C) M. Zhong

total_num_samples = M * L * (N^2 - N)/2;
num_samples       = total_num_samples^(1/d);
tol               = num_samples/total_num_samples;
end