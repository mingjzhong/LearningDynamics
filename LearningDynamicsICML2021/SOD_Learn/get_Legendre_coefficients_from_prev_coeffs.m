function coeffs_np1 = get_Legendre_coefficients_from_prev_coeffs(coeffs_n, coeffs_nm1)
% function coeffs_np1 = get_Legendre_coefficients_from_prev_coeffs(coeffs_n, coeffs_nm1)

% (C) M. Zhong

validateattributes(coeffs_n,   {'numeric'}, {'row', 'vector'}, ...
  'get_Legendre_coefficients_from_prev_coeffs', 'coeffs_n', 1);
validateattributes(coeffs_nm1, {'numeric'}, {'row', 'vector'}, ...
  'get_Legendre_coefficients_from_prev_coeffs', 'coeffs_nm1', 2);
n          = length(coeffs_n);
% method1 (original formula), however this is not numericallly stable after n = 41
% coeffs_np1 = (2 * n + 1)/(n + 1) * [coeffs_n, 0] - n/(n + 1) * [0, 0, coeffs_nm1];
% method2, just re-work the formula a bit, after n = 47, it also becomes unstable
coeffs_np1 = (2 - 1/(n + 1)) * [coeffs_n, 0] - (1 - 1/(n + 1)) * [0, 0, coeffs_nm1];
end