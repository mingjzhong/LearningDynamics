function [beta, sineFit] = get_JPL_sine_fit_to_dist(t_l, r_l, ZP_type)
% function [beta, sineFit] = get_JPL_sine_fit_to_dist(t_l, r_l, ZP_type)

% (C) M. Zhong

beta    = sineFit_using_FFT(t_l, r_l, ZP_type);
sineFit = @(t) beta(1) + beta(2) * sin(2 * pi * beta(3) * t + beta(4));
end